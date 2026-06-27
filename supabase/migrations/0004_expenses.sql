-- TripMate — Sprint 4: expenses + expense_splits + RPCs + RLS + receipts bucket
-- (DB Design §4.5/§4.6, API §4.3-§4.6, PRD REQ-EXP-01..06).

-- ---------------------------------------------------------------------------
-- Tables
-- ---------------------------------------------------------------------------
create table if not exists public.expenses (
  id                   uuid primary key default gen_random_uuid(),
  trip_id              uuid not null references public.trips (id) on delete cascade,
  paid_by              uuid not null references public.trip_members (id) on delete restrict,
  amount               numeric(14, 2) not null check (amount > 0),
  currency             char(3) not null,
  category             text not null,
  description          text,
  expense_date         timestamptz not null default now(),
  status               text not null default 'approved'
                         check (status in ('pending', 'approved', 'rejected')),
  split_type           text not null default 'equal',
  receipt_storage_path text,
  created_by           uuid not null references public.profiles (id) on delete restrict,
  version              integer not null default 1,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now(),
  deleted_at           timestamptz
);

create table if not exists public.expense_splits (
  id            uuid primary key default gen_random_uuid(),
  expense_id    uuid not null references public.expenses (id) on delete cascade,
  member_id     uuid not null references public.trip_members (id) on delete restrict,
  share_amount  numeric(14, 2) not null check (share_amount >= 0),
  unique (expense_id, member_id)
);

create index if not exists expenses_trip_status
  on public.expenses (trip_id, status) where deleted_at is null;
create index if not exists expenses_trip_date
  on public.expenses (trip_id, expense_date);
create index if not exists expense_splits_member
  on public.expense_splits (member_id);

alter table public.expenses enable row level security;
alter table public.expense_splits enable row level security;

create policy expenses_select on public.expenses
  for select using (public.is_trip_member(trip_id) and deleted_at is null);

create policy expense_splits_select on public.expense_splits
  for select using (
    exists (select 1 from public.expenses e
            where e.id = expense_id and public.is_trip_member(e.trip_id))
  );

create trigger expenses_touch_updated_at before update on public.expenses
  for each row execute function public.touch_updated_at();

-- ---------------------------------------------------------------------------
-- Helper: write the split rows for an expense from a jsonb array, validating
-- that they sum to the amount (EXPENSE_SPLIT_MISMATCH).
-- ---------------------------------------------------------------------------
create or replace function public._write_splits(
  p_expense_id uuid, p_amount numeric, p_splits jsonb
)
returns void language plpgsql as $$
declare
  v_total numeric := 0;
  v_split jsonb;
begin
  delete from public.expense_splits where expense_id = p_expense_id;
  for v_split in select * from jsonb_array_elements(p_splits) loop
    insert into public.expense_splits (expense_id, member_id, share_amount)
    values (p_expense_id,
            (v_split->>'member_id')::uuid,
            (v_split->>'share_amount')::numeric);
    v_total := v_total + (v_split->>'share_amount')::numeric;
  end loop;
  if round(v_total, 2) <> round(p_amount, 2) then
    raise exception 'EXPENSE_SPLIT_MISMATCH' using errcode = 'P0001';
  end if;
end;
$$;

-- ---------------------------------------------------------------------------
-- RPC: create_expense — expense + splits atomically (API §4.3).
-- ---------------------------------------------------------------------------
create or replace function public.create_expense(
  p_id uuid, p_trip_id uuid, p_paid_by uuid, p_amount numeric,
  p_currency text, p_category text, p_expense_date timestamptz,
  p_status text, p_split_type text, p_splits jsonb,
  p_description text default null, p_idempotency_key uuid default null
)
returns public.expenses
language plpgsql security definer set search_path = public as $$
declare
  v_expense public.expenses;
begin
  if not public.is_trip_member(p_trip_id) then
    raise exception 'PERMISSION_DENIED' using errcode = '42501';
  end if;
  if p_amount <= 0 then
    raise exception 'EXPENSE_AMOUNT_INVALID' using errcode = 'P0001';
  end if;

  select * into v_expense from public.expenses where id = p_id;
  if found then
    return v_expense; -- idempotent replay
  end if;

  insert into public.expenses (id, trip_id, paid_by, amount, currency,
        category, description, expense_date, status, split_type, created_by)
  values (p_id, p_trip_id, p_paid_by, p_amount, p_currency, p_category,
        p_description, p_expense_date, coalesce(p_status, 'approved'),
        coalesce(p_split_type, 'equal'), auth.uid())
  returning * into v_expense;

  perform public._write_splits(p_id, p_amount, p_splits);
  return v_expense;
end;
$$;

-- ---------------------------------------------------------------------------
-- RPC: update_expense — optimistic concurrency + re-approval (API §4.4).
-- ---------------------------------------------------------------------------
create or replace function public.update_expense(
  p_id uuid, p_amount numeric, p_category text, p_expense_date timestamptz,
  p_splits jsonb, p_expected_version integer, p_description text default null
)
returns public.expenses
language plpgsql security definer set search_path = public as $$
declare
  v_expense public.expenses;
begin
  select * into v_expense from public.expenses where id = p_id for update;
  if not found then
    raise exception 'NOT_FOUND' using errcode = 'P0001';
  end if;
  if not public.is_trip_member(v_expense.trip_id) then
    raise exception 'PERMISSION_DENIED' using errcode = '42501';
  end if;
  if p_expected_version is not null
     and v_expense.version <> p_expected_version then
    raise exception 'CONFLICT_VERSION' using errcode = 'P0001';
  end if;
  if p_amount <= 0 then
    raise exception 'EXPENSE_AMOUNT_INVALID' using errcode = 'P0001';
  end if;

  update public.expenses set
    amount = p_amount, category = p_category, description = p_description,
    expense_date = p_expense_date, version = version + 1,
    -- Material change reverts an approved expense to pending (REQ-EXP-02).
    status = case when status = 'approved' and amount <> p_amount
                  then 'pending' else status end
    where id = p_id
    returning * into v_expense;

  perform public._write_splits(p_id, p_amount, p_splits);
  return v_expense;
end;
$$;

-- ---------------------------------------------------------------------------
-- RPC: delete_expense — soft-delete (owner) (API §4.5).
-- ---------------------------------------------------------------------------
create or replace function public.delete_expense(p_id uuid)
returns void
language plpgsql security definer set search_path = public as $$
declare
  v_trip uuid;
begin
  select trip_id into v_trip from public.expenses where id = p_id;
  if v_trip is null then return; end if;
  if not public.is_trip_owner(v_trip) then
    raise exception 'PERMISSION_DENIED' using errcode = '42501';
  end if;
  update public.expenses
    set deleted_at = now(), version = version + 1 where id = p_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- RPC: set_expense_status — approve / reject (owner) (API §4.6).
-- ---------------------------------------------------------------------------
create or replace function public.set_expense_status(p_id uuid, p_status text)
returns public.expenses
language plpgsql security definer set search_path = public as $$
declare
  v_expense public.expenses;
begin
  select * into v_expense from public.expenses where id = p_id for update;
  if not found then
    raise exception 'NOT_FOUND' using errcode = 'P0001';
  end if;
  if not public.is_trip_owner(v_expense.trip_id) then
    raise exception 'PERMISSION_DENIED' using errcode = '42501';
  end if;
  if v_expense.status <> 'pending' then
    raise exception 'EXPENSE_STATUS_INVALID' using errcode = 'P0001';
  end if;
  if p_status not in ('approved', 'rejected') then
    raise exception 'VALIDATION_FAILED' using errcode = 'P0001';
  end if;

  update public.expenses set status = p_status, version = version + 1
    where id = p_id returning * into v_expense;

  insert into public.notifications (user_id, trip_id, type, title, body)
  values (v_expense.created_by, v_expense.trip_id,
          'expense_' || p_status, 'Expense ' || p_status,
          'Your expense was ' || p_status);

  return v_expense;
end;
$$;

-- ---------------------------------------------------------------------------
-- RPC: set_expense_receipt — persist the storage path after upload (§10).
-- ---------------------------------------------------------------------------
create or replace function public.set_expense_receipt(
  p_expense_id uuid, p_path text
)
returns void
language plpgsql security definer set search_path = public as $$
declare
  v_trip uuid;
begin
  select trip_id into v_trip from public.expenses where id = p_expense_id;
  if v_trip is null or not public.is_trip_member(v_trip) then
    raise exception 'PERMISSION_DENIED' using errcode = '42501';
  end if;
  update public.expenses set receipt_storage_path = p_path
    where id = p_expense_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- Dues check used by remove_member (Sprint 3 placeholder now implemented):
-- a member with any approved expense split is considered to have dues.
-- ---------------------------------------------------------------------------
create or replace function public.member_has_dues(p_member_id uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.expense_splits s
    join public.expenses e on e.id = s.expense_id
    where s.member_id = p_member_id
      and e.deleted_at is null and e.status = 'approved'
  );
$$;

-- ---------------------------------------------------------------------------
-- Receipts: private bucket + path-scoped Storage RLS (Architecture §10).
-- ---------------------------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('receipts', 'receipts', false)
on conflict (id) do nothing;

create policy receipts_member_read on storage.objects
  for select using (
    bucket_id = 'receipts'
    and public.is_trip_member((split_part(name, '/', 1))::uuid)
  );

create policy receipts_member_write on storage.objects
  for insert with check (
    bucket_id = 'receipts'
    and public.is_trip_member((split_part(name, '/', 1))::uuid)
  );
