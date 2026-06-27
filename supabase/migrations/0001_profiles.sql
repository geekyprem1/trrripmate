-- TripMate — Sprint 1 schema: profiles (DB Design §4.1).
-- Extends auth.users with app-level profile data.

create table if not exists public.profiles (
  id            uuid primary key references auth.users (id) on delete cascade,
  display_name  text not null check (char_length(display_name) between 1 and 60),
  avatar_url    text,
  email         text,
  phone         text,
  tier          text not null default 'free' check (tier in ('free', 'premium')),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

alter table public.profiles enable row level security;

-- Anyone authenticated may read profiles (needed for member display);
-- a user may insert/update only their own row.
create policy profiles_select on public.profiles
  for select using (auth.role() = 'authenticated');

create policy profiles_insert on public.profiles
  for insert with check (id = auth.uid());

create policy profiles_update on public.profiles
  for update using (id = auth.uid()) with check (id = auth.uid());
