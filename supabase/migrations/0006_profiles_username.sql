-- TripMate — Sprint 2 schema: unique username on profiles.
-- Each user gets a short handle chosen during onboarding, used for QR-based
-- friend/trip invites (PRD REQ-MEM-03).

alter table public.profiles
  add column if not exists username text;

-- Enforce uniqueness case-insensitively so "Rahul" and "rahul" cannot coexist.
create unique index if not exists profiles_username_unique_idx
  on public.profiles (lower(username))
  where username is not null;
