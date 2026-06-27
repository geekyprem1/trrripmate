-- TripMate — Sprint 3: invitations, notifications, member/invite RPCs, RLS
-- (DB Design §4.4/§4.9/§9, API §5, PRD REQ-MEM-01..03).

-- ---------------------------------------------------------------------------
-- Tables
-- ---------------------------------------------------------------------------
create table if not exists public.invitations (
  id            uuid primary key default gen_random_uuid(),
  trip_id       uuid not null references public.trips (id) on delete cascade,
  invited_by    uuid not null references public.profiles (id) on delete restrict,
  target_email  text,
  target_phone  text,
  invite_code   text not null unique,
  status        text not null default 'pending'
                  check (status in ('pending', 'accepted', 'rejected', 'expired')),
  expires_at    timestamptz not null default now() + interval '7 days',
  accepted_by   uuid references public.profiles (id),
  created_at    timestamptz not null default now()
);

-- One pending invite per email/phone per trip (DB Design §4.4).
create unique index if not exists invitations_one_pending_email
  on public.invitations (trip_id, target_email)
  where status = 'pending' and target_email is not null;
create unique index if not exists invitations_one_pending_phone
  on public.invitations (trip_id, target_phone)
  where status = 'pending' and target_phone is not null;
create index if not exists invitations_trip_status
  on public.invitations (trip_id, status);

create table if not exists public.notifications (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references public.profiles (id) on delete cascade,
  trip_id     uuid references public.trips (id) on delete cascade,
  type        text not null,
  title       text not null,
  body        text not null,
  payload     jsonb,
  is_read     boolean not null default false,
  created_at  timestamptz not null default now()
);
create index if not exists notifications_user_unread
  on public.notifications (user_id, is_read, created_at desc);

alter table public.invitations enable row level security;
alter table public.notifications enable row level security;

-- Members may read invitations for their trips; the invitee path uses RPCs.
create policy invitations_select on public.invitations
  for select using (public.is_trip_member(trip_id));

create policy notifications_select on public.notifications
  for select using (user_id = auth.uid());
create policy notifications_update on public.notifications
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ---------------------------------------------------------------------------
-- Helper: random URL-safe invite code.
-- ---------------------------------------------------------------------------
create or replace function public.gen_invite_code()
returns text language sql volatile as $$
  select translate(encode(gen_random_bytes(9), 'base64'), '+/=', 'abc');
$$;

-- ---------------------------------------------------------------------------
-- RPC: invite_create — owner creates an invitation (API §5.1).
-- ---------------------------------------------------------------------------
create or replace function public.invite_create(
  p_trip_id uuid,
  p_email text default null,
  p_phone text default null
)
returns public.invitations
language plpgsql security definer set search_path = public as $$
declare
  v_invite public.invitations;
begin
  if not public.is_trip_owner(p_trip_id) then
    raise exception 'PERMISSION_DENIED' using errcode = '42501';
  end if;
  if exists (select 1 from public.trips
             where id = p_trip_id and status = 'archived') then
    raise exception 'TRIP_ARCHIVED' using errcode = 'P0001';
  end if;

  -- Reuse an existing pending invite for the same target (idempotent).
  select * into v_invite from public.invitations
    where trip_id = p_trip_id and status = 'pending'
      and ((p_email is not null and target_email = p_email)
        or (p_phone is not null and target_phone = p_phone))
    limit 1;
  if found then
    return v_invite;
  end if;

  insert into public.invitations (trip_id, invited_by, target_email,
                                  target_phone, invite_code)
  values (p_trip_id, auth.uid(), p_email, p_phone, public.gen_invite_code())
  returning * into v_invite;

  return v_invite;
end;
$$;

-- ---------------------------------------------------------------------------
-- RPC: invite_preview — public-by-code read for the Join screen (API §5).
-- ---------------------------------------------------------------------------
create or replace function public.invite_preview(p_code text)
returns table (
  invite_code text, trip_name text, owner_name text,
  member_count integer, status text, expires_at timestamptz
)
language plpgsql security definer set search_path = public as $$
declare
  v_inv public.invitations;
begin
  select * into v_inv from public.invitations where invite_code = p_code;
  if not found then
    raise exception 'INVITE_INVALID' using errcode = 'P0001';
  end if;

  return query
    select v_inv.invite_code,
           t.name,
           p.display_name,
           (select count(*)::int from public.trip_members m
              where m.trip_id = t.id and m.status = 'active'),
           case when v_inv.status = 'pending' and v_inv.expires_at < now()
                then 'expired' else v_inv.status end,
           v_inv.expires_at
      from public.trips t
      join public.profiles p on p.id = t.owner_id
     where t.id = v_inv.trip_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- RPC: invite_accept — join the trip (idempotent) (API §5.2).
-- ---------------------------------------------------------------------------
create or replace function public.invite_accept(p_code text)
returns table (trip_id uuid, member_id uuid)
language plpgsql security definer set search_path = public as $$
declare
  v_inv public.invitations;
  v_uid uuid := auth.uid();
  v_member_id uuid;
begin
  if v_uid is null then
    raise exception 'AUTH_UNAUTHORIZED' using errcode = '28000';
  end if;

  select * into v_inv from public.invitations where invite_code = p_code
    for update;
  if not found then
    raise exception 'INVITE_INVALID' using errcode = 'P0001';
  end if;
  if v_inv.status <> 'pending' or v_inv.expires_at < now() then
    raise exception 'INVITE_EXPIRED' using errcode = 'P0001';
  end if;

  -- Already a member? Idempotent success.
  select id into v_member_id from public.trip_members
    where trip_id = v_inv.trip_id and user_id = v_uid;
  if found then
    update public.invitations set status = 'accepted', accepted_by = v_uid
      where id = v_inv.id;
    return query select v_inv.trip_id, v_member_id;
    return;
  end if;

  insert into public.trip_members (trip_id, user_id, role)
  values (v_inv.trip_id, v_uid, 'member')
  returning id into v_member_id;

  update public.invitations set status = 'accepted', accepted_by = v_uid
    where id = v_inv.id;

  -- Notify the trip owner.
  insert into public.notifications (user_id, trip_id, type, title, body)
  select t.owner_id, t.id, 'invite_accepted', 'New member',
         coalesce(p.display_name, 'Someone') || ' joined the trip'
    from public.trips t
    left join public.profiles p on p.id = v_uid
   where t.id = v_inv.trip_id;

  return query select v_inv.trip_id, v_member_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- RPC: invite_reject (API §5.3).
-- ---------------------------------------------------------------------------
create or replace function public.invite_reject(p_code text)
returns void
language plpgsql security definer set search_path = public as $$
begin
  update public.invitations set status = 'rejected'
    where invite_code = p_code and status = 'pending';
end;
$$;

-- ---------------------------------------------------------------------------
-- RPC: remove_member — owner removes a member, dues-checked (API §4.10).
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

  -- Dues check is a no-op until Sprint 5 (settlements). Placeholder guard:
  -- if exists (unsettled balance for this member) raise 'MEMBER_HAS_DUES'.

  update public.trip_members
    set status = 'removed', removed_at = now()
    where id = p_member_id;
end;
$$;

-- Allow members to read each other's profiles already covered by
-- profiles_select; roster embeds rely on that policy.
