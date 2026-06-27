-- TripMate — Sprint 5: settlements + compute/mark-paid RPCs + RLS, and wiring
-- the now-real member dues check into remove_member (DB Design §4.7,
-- API §4.7/§4.8, PRD REQ-SET-01..02).

-- ---------------------------------------------------------------------------
-- Table
-- ---------------------------------------------------------------------------
create table if not exists public.settlements (
  id              uuid primary key default gen_random_uuid(),
  trip_id         uuid not null references public.trips (id) on delete cascade,
  from_member_id  uuid not null references public.trip_members (id) on delete restrict,
  to_member_id    uuid not null references public.trip_members (id) on delete restrict,
  amount          numeric(14, 2) not null check (amount > 0),
  status          text not null default 'pending'
                    check (status in ('pending', 'completed')),
  marked_by       uuid references public.trip_members (id) on delete set null,
  completed_at    timestamptz,
  version         integer not null default 1,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  deleted_at      timestamptz,
  check (from_member_id <> to_member_id)
);

create index if not exists settlements_trip_status
  on public.settlements (trip_id, status) where deleted_at is null;
create index if not exists settlements_from
  on public.settlements (from_member_id);
create index if not exists settlements_to
  on public.settlements (to_member_id);

alter table public.settlements enable row level security;

-- Members may read settlements; all writes go through security-definer RPCs
-- (owner/debtor checks live there). No direct insert/update/delete policy.
create policy settlements_select on public.settlements
  for select using (public.is_trip_member(trip_id) and deleted_at is null);

create trigger settlements_touch_updated_at before update on public.settlements
  for each row execute function public.touch_updated_at();

-- ---------------------------------------------------------------------------
-- Net balance per member (minor-safe numeric): Σ paid − Σ share over approved
-- expenses, adjusted by completed settlements. Sums to zero across a trip.
-- ---------------------------------------------------------------------------
create or replace function public.member_net(p_member_id uuid)
returns numeric language sql stable security definer set search_path = public as $$
  select
      coalesce((select sum(e.amount) from public.expenses e
                where e.paid_by = p_member_id
                  and e.deleted_at is null and e.status = 'approved'), 0)
    - coalesce((select sum(s.share_amount) from public.expense_splits s
                join public.expenses e on e.id = s.expense_id
                where s.member_id = p_member_id
                  and e.deleted_at is null and e.status = 'approved'), 0)
    + coalesce((select sum(st.amount) from public.settlements st
                where st.from_member_id = p_member_id
                  and st.status = 'completed' and st.deleted_at is null), 0)
    - coalesce((select sum(st.amount) from public.settlements st
                where st.to_member_id = p_member_id
                  and st.status = 'completed' and st.deleted_at is null), 0);
$$;

-- A member has dues when their net position is not yet zero (REQ-MEM-03).
-- Supersedes the Sprint 4 splits-only placeholder.
create or replace function public.member_has_dues(p_member_id uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select round(public.member_net(p_member_id), 2) <> 0;
$$;

-- ---------------------------------------------------------------------------
-- remove_member: now enforces the dues check (Sprint 4 left it a placeholder).
-- ---------------------------------------------------------------------------
create or replace function public.remove_member(
  p_trip_id uuid,
  p_member_id uuid
)
returns void
language plpgsql security definer set search_path = public as $$
declare
  v_member public.trip_members;
begin
  if not public.is_trip_owner(p_trip_id) then
    raise exception 'PERMISSION_DENIED' using errcode = '42501';
  end if;

  select * into v_member from public.trip_members
    where id = p_member_id and trip_id = p_trip_id;
  if not found then
    raise exception 'NOT_FOUND' using errcode = 'P0001';
  end if;
  if v_member.role = 'owner' then
    raise exception 'PERMISSION_DENIED' using errcode = '42501';
  end if;
  if public.member_has_dues(p_member_id) then
    raise exception 'MEMBER_HAS_DUES' using errcode = 'P0001';
  end if;

  update public.trip_members
    set status = 'removed', removed_at = now()
    where id = p_member_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- RPC: compute_settlement — recompute minimal who-pays-who, preserving
-- completed rows, validating zero-sum (API §4.7). Provided for contract parity
-- and non-offline clients; the Flutter client computes the graph locally.
-- ---------------------------------------------------------------------------
create or replace function public.compute_settlement(p_trip_id uuid)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  v_debtor uuid;
  v_creditor uuid;
  v_owe numeric;
  v_cred numeric;
  v_transfer numeric;
  v_net_sum numeric;
  v_settlements jsonb;
  v_balances jsonb;
begin
  if not public.is_trip_member(p_trip_id) then
    raise exception 'PERMISSION_DENIED' using errcode = '42501';
  end if;

  -- Working net balances for every member of the trip (active or removed).
  create temporary table _net on commit drop as
    select m.id as member_id, round(public.member_net(m.id), 2) as net
      from public.trip_members m
      where m.trip_id = p_trip_id;

  select coalesce(round(sum(net), 2), 0) into v_net_sum from _net;
  if v_net_sum <> 0 then
    raise exception 'SETTLEMENT_NOT_BALANCED' using errcode = 'P0001';
  end if;

  -- Regenerate the outstanding (pending) plan; completed history is preserved.
  delete from public.settlements
    where trip_id = p_trip_id and status = 'pending';

  loop
    v_debtor := null;
    v_creditor := null;
    select member_id, net into v_debtor, v_owe from _net
      where net < 0 order by net asc, member_id asc limit 1;
    select member_id, net into v_creditor, v_cred from _net
      where net > 0 order by net desc, member_id asc limit 1;
    exit when v_debtor is null or v_creditor is null;

    v_transfer := least(-v_owe, v_cred);
    insert into public.settlements
        (trip_id, from_member_id, to_member_id, amount, status)
      values (p_trip_id, v_debtor, v_creditor, v_transfer, 'pending');

    update _net set net = net + v_transfer where member_id = v_debtor;
    update _net set net = net - v_transfer where member_id = v_creditor;
  end loop;

  select coalesce(jsonb_agg(jsonb_build_object(
            'id', id, 'from_member_id', from_member_id,
            'to_member_id', to_member_id, 'amount', amount, 'status', status)),
          '[]'::jsonb)
    into v_settlements
    from public.settlements
    where trip_id = p_trip_id and deleted_at is null;

  select coalesce(jsonb_agg(jsonb_build_object(
            'member_id', member_id, 'net', net)), '[]'::jsonb)
    into v_balances from _net;

  return jsonb_build_object('settlements', v_settlements,
                            'net_balances', v_balances);
end;
$$;

-- ---------------------------------------------------------------------------
-- RPC: mark_settlement_paid — record a payment as completed (owner or debtor),
-- idempotent (API §4.8). Upserts by id so an offline client-created ledger
-- entry materializes server-side; replays are no-ops.
-- ---------------------------------------------------------------------------
create or replace function public.mark_settlement_paid(
  p_id uuid, p_trip_id uuid, p_from_member_id uuid, p_to_member_id uuid,
  p_amount numeric, p_marked_by uuid default null,
  p_expected_version integer default null
)
returns public.settlements
language plpgsql security definer set search_path = public as $$
declare
  v_settlement public.settlements;
begin
  -- Permission: trip owner, or the debtor (from_member's user).
  if not (public.is_trip_owner(p_trip_id) or exists (
            select 1 from public.trip_members tm
            where tm.id = p_from_member_id and tm.user_id = auth.uid())) then
    raise exception 'PERMISSION_DENIED' using errcode = '42501';
  end if;
  if p_amount <= 0 or p_from_member_id = p_to_member_id then
    raise exception 'VALIDATION_FAILED' using errcode = 'P0001';
  end if;

  select * into v_settlement from public.settlements where id = p_id for update;

  -- Idempotent replay: already completed → return as-is.
  if found and v_settlement.status = 'completed' then
    return v_settlement;
  end if;

  if found then
    if p_expected_version is not null
       and v_settlement.version <> p_expected_version then
      raise exception 'CONFLICT_VERSION' using errcode = 'P0001';
    end if;
    update public.settlements set
        status = 'completed', marked_by = p_marked_by,
        completed_at = now(), version = version + 1
      where id = p_id returning * into v_settlement;
  else
    insert into public.settlements (id, trip_id, from_member_id, to_member_id,
          amount, status, marked_by, completed_at)
      values (p_id, p_trip_id, p_from_member_id, p_to_member_id, p_amount,
          'completed', p_marked_by, now())
      returning * into v_settlement;
  end if;

  -- Notify the creditor that a payment was recorded (settlement_completed).
  insert into public.notifications (user_id, trip_id, type, title, body)
  select tm.user_id, p_trip_id, 'settlement_completed',
         'Payment recorded', 'A settlement was marked paid.'
    from public.trip_members tm where tm.id = p_to_member_id;

  return v_settlement;
end;
$$;
