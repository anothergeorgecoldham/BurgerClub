create extension if not exists pgcrypto;

create table if not exists public.opt_ins (
  id uuid primary key default gen_random_uuid(),
  friend_name text not null,
  preferred_day text not null check (
    preferred_day in (
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    )
  ),
  preferred_meal text not null check (preferred_meal in ('Lunch', 'Dinner')),
  burger_joint text not null,
  address text not null,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (friend_name)
);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_opt_ins_updated_at on public.opt_ins;

create trigger set_opt_ins_updated_at
before update on public.opt_ins
for each row
execute function public.set_updated_at();

alter table public.opt_ins enable row level security;

grant usage on schema public to anon;
grant select, insert, update on public.opt_ins to anon;

drop policy if exists "Anyone can view opt ins" on public.opt_ins;
drop policy if exists "Anyone can add opt ins" on public.opt_ins;
drop policy if exists "Anyone can update opt ins" on public.opt_ins;

create policy "Anyone can view opt ins"
on public.opt_ins
for select
to anon
using (true);

create policy "Anyone can add opt ins"
on public.opt_ins
for insert
to anon
with check (true);

create policy "Anyone can update opt ins"
on public.opt_ins
for update
to anon
using (true)
with check (true);
