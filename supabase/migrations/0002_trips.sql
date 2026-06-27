-- TripMate — Sprint 2 schema: trips + trip_members + RPCs + RLS
-- (DB Design §4.2/§4.3/§9, API §3.2/§4.1/§4.2).

-- ---------------------------------------------------------------------------
-- Tables
-- ---------------------------------------------------------------------------
create table if not exists public.trips (
  id            uuid primary key default gen_random_uuid(),
  owner_id      uuid not null references public.profiles (id) on delete restrict,
  name          text not null check (char_length(name) between 1 and 60),
  destination   text,
  start_date    date,
  end_date      date,
  currency      char(3) not null,
  total_budget  numeric(14, 2) check (total_budget is null or total_budget >= 0),
  status        text not null default 'active'
                  check (status in ('active', 'archived', 'deleted')),
  version       integer not null default 1,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  deleted_at    timestamptz,
  constraint trips_date_order check (end_date is null or start_date is null
                                     or end_date >= start_date)
);

create table if not exists public.trip_members (
  id          uuid primary key default gen_random_uuid(),
  trip_id     uuid not null references public.trips (id) on delete cascade,
  user_id     uuid not null references public.profiles (id) on delete restrict,
  role        text not null default 'member'
                check (role in ('owner', 'member', 'admin')),
  status      text not null default 'active' check (status in ('active', 'removed')),
  joined_at   timestamptz not null default now(),
  removed_at  timestamptz,
  unique (trip_id, user_id)
);

-- One owner per trip.
create unique index if not exists trip_members_one_owner
  on public.trip_members (trip_id) where role = 'owner';

create index if not exists trips_owner_active
  on public.trips (owner_id) where status = 'active' and deleted_at is null;
create index if not exists trips_updated on public.trips (updated_at);
create index if not exists trip_members_user on public.trip_members (user_id);

-- ---------------------------------------------------------------------------
-- Membership helper (security definer) — the RLS anchor (DB Design §9).
-- ---------------------------------------------------------------------------
create or replace function public.is_trip_member(p_trip_id uuid)
returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.trip_members m
    where m.trip_id = p_trip_id
      and m.user_id = auth.uid()
      and m.status = 'active'
  );
$$;

create or replace function public.is_trip_owner(p_trip_id uuid)
returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.trip_members m
    where m.trip_id = p_trip_id
      and m.user_id = auth.uid()
      and m.role = 'owner'
      and m.status = 'active'
  );
$$;

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------
alter table public.trips enable row level security;
alter table public.trip_members enable row level security;

create policy trips_select on public.trips
  for select using (public.is_trip_member(id) and deleted_at is null);

create policy trips_update on public.trips
  for update using (public.is_trip_owner(id))
  with check (public.is_trip_owner(id));

create policy trip_members_select on public.trip_members
  for select using (public.is_trip_member(trip_id));

-- ---------------------------------------------------------------------------
-- RPC: create_trip — enforces free-tier quota + owner membership (API §4.1).
-- ---------------------------------------------------------------------------
create or replace function public.create_trip(
  p_id uuid,
  p_name text,
  p_currency text,
  p_destination text default null,
  p_start_date date default null,
  p_end_date date default null,
  p_total_budget numeric default null,
  p_idempotency_key uuid default null
)
returns public.trips
language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_active_count integer;
  v_tier text;
  v_trip public.trips;
begin
  if v_uid is null then
    raise exception 'AUTH_UNAUTHORIZED' using errcode = '28000';
  end if;

  -- Idempotent replay: return the existing row if already created.
  select * into v_trip from public.trips where id = p_id;
  if found then
    return v_trip;
  end if;

  select tier into v_tier from public.profiles where id = v_uid;
  select count(*) into v_active_count from public.trips
    where owner_id = v_uid and status = 'active' and deleted_at is null;

  if coalesce(v_tier, 'free') = 'free' and v_active_count >= 3 then
    raise exception 'QUOTA_TRIP_LIMIT' using errcode = 'P0001';
  end if;

  insert into public.trips (id, owner_id, name, destination, start_date,
                            end_date, currency, total_budget)
  values (p_id, v_uid, p_name, p_destination, p_start_date, p_end_date,
          p_currency, p_total_budget)
  returning * into v_trip;

  insert into public.trip_members (trip_id, user_id, role)
  values (p_id, v_uid, 'owner');

  return v_trip;
end;
$$;

-- ---------------------------------------------------------------------------
-- RPC: delete_trip — soft-delete cascade (owner only) (API §4.2).
-- ---------------------------------------------------------------------------
create or replace function public.delete_trip(p_trip_id uuid)
returns public.trips
language plpgsql security definer set search_path = public as $$
declare
  v_trip public.trips;
begin
  if not public.is_trip_owner(p_trip_id) then
    raise exception 'PERMISSION_DENIED' using errcode = '42501';
  end if;

  update public.trips
    set status = 'deleted', deleted_at = now(),
        updated_at = now(), version = version + 1
    where id = p_trip_id
    returning * into v_trip;

  return v_trip;
end;
$$;

-- Keep updated_at fresh on direct updates.
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists trips_touch_updated_at on public.trips;
create trigger trips_touch_updated_at before update on public.trips
  for each row execute function public.touch_updated_at();
