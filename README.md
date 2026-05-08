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
- The schedule view chooses the most popular day and meal time, schedules the matching weekday closest to the middle of each month, then rotates through suggested venues for the next six monthly catchups.
- Data is shared through Supabase, so friends see the same opt-ins and schedule.
- The app keeps a browser `localStorage` backup of the latest shared data for graceful fallback if Supabase is temporarily unavailable.
- Export/import buttons are still available for manual backup or bulk restore.

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

The app now uses Supabase as the shared backend. Export/import remains useful for manual backups:

- Use **Export club data** to download `burger-club-data.json`.
- Use **Import club data** to upload that file into the shared Supabase database.

## Supabase backend

Supabase is the shared backend for the app. The setup SQL is stored in `supabase-setup.sql`.

Current frontend configuration in `index.html`:

- Supabase project URL: `https://svgtpekdyanunabsavlp.supabase.co`
- Supabase key type: publishable key
- Access model: anyone with the site link can submit, view, and update opt-ins by name
- Destructive reset/delete is not exposed in the public app

Database setup: open `supabase-setup.sql`, paste it into the Supabase SQL Editor, and run it if setting up a new project.

Notes:

- This starter policy is intentionally simple for a small private friend group, but it is not strong identity-based security.
- For a more controlled version, add Supabase Auth and only allow each signed-in user to update their own opt-in.

## Resume checklist

1. Confirm the static site still opens: <https://anothergeorgecoldham.github.io/BurgerClub/>
2. Confirm Supabase is reachable from the app by checking the **Shared database connected** status under the opt-in heading.
3. If moving to a different Supabase project, run `supabase-setup.sql` in the new project and update `SUPABASE_URL` plus `SUPABASE_PUBLISHABLE_KEY` in `index.html`.
4. Commit and push future app changes to deploy through GitHub Pages.
