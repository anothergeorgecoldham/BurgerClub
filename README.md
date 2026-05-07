# Burger Club Planner

A single-page static web app for coordinating a monthly burger catchup with friends.

Live site: <https://anothergeorgecoldham.github.io/BurgerClub/>

Repository: <https://github.com/anothergeorgecoldham/BurgerClub>

## Current state

- The app is a single static file: `index.html`.
- It is hosted with GitHub Pages from the `main` branch.
- Friends can opt in with:
  - name
  - preferred day, Sunday to Saturday
  - lunch or dinner
  - one burger joint suggestion
  - address lookup via OpenStreetMap Nominatim, with manual address fallback
  - optional notes
- The schedule view chooses the most popular day and meal time, then rotates through suggested venues for the next six monthly catchups.
- Data currently uses browser `localStorage`, so each device has its own copy.
- Export/import buttons are available for manual backup or sharing while there is no shared backend.

## Run locally

No build step is required.

1. Clone the repository:

   ```powershell
   git clone https://github.com/anothergeorgecoldham/BurgerClub.git
   cd BurgerClub
   ```

2. Open `index.html` in a browser.

If browser security restrictions ever affect address lookup from a local file, use a tiny local static server instead:

```powershell
python -m http.server 8080
```

Then open <http://localhost:8080/>.

## Deploy

Deployment is handled by GitHub Pages.

1. Commit changes to `main`.
2. Push to GitHub:

   ```powershell
   git push
   ```

3. GitHub Pages will update the live site automatically.

Pages URL: <https://anothergeorgecoldham.github.io/BurgerClub/>

## Backup and restore data

Until a shared backend is added:

- Use **Export club data** to download `burger-club-data.json`.
- Use **Import club data** to restore that file into another browser/device.
- Because the current storage is local-only, friends will not automatically see each other's opt-ins.

## Recommended next step: Supabase backend

Supabase is the recommended backend for the best user experience. It lets the GitHub Pages frontend read and write shared opt-ins without hosting a custom server.

When resuming, collect these from Supabase:

1. Supabase project URL, for example `https://xxxxx.supabase.co`
2. Supabase anon public key
3. Decision on access model:
   - recommended starting point: anyone with the site link can submit and view opt-ins
   - destructive actions such as reset/delete should be removed from the public app or restricted later

Suggested first database table:

```sql
create table public.opt_ins (
  id uuid primary key default gen_random_uuid(),
  friend_name text not null,
  preferred_day text not null check (preferred_day in ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')),
  preferred_meal text not null check (preferred_meal in ('Lunch', 'Dinner')),
  burger_joint text not null,
  address text not null,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (friend_name)
);

alter table public.opt_ins enable row level security;

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

create policy "Anyone can update their named opt in"
on public.opt_ins
for update
to anon
using (true)
with check (true);
```

Notes:

- This starter policy is intentionally simple for a small private friend group, but it is not strong identity-based security.
- For a more controlled version, add Supabase Auth and only allow each signed-in user to update their own opt-in.
- Once Supabase is connected, replace the `localStorage` load/save functions in `index.html` with Supabase `select`, `insert`, and `upsert` calls.

## Resume checklist

1. Confirm the static site still opens: <https://anothergeorgecoldham.github.io/BurgerClub/>
2. Create or open the Supabase project.
3. Run the SQL table/policy setup above in Supabase SQL Editor.
4. Add the Supabase project URL and anon key to `index.html`.
5. Replace local-only storage with shared Supabase reads/writes.
6. Commit and push the updated app.
