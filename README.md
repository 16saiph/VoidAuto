# AutoSparx

A simple Codespaces-friendly dashboard prototype for scanning Sparx homework tasks in a dark grey/black theme.

## Files included

- `index.html` — the dashboard page
- `styles.css` — sleek rounded dark theme
- `script.js` — login session flow, homework scan simulation, selection details, and PDF generation

## New features

- Session-only login for Sparx account access
- Automatic route mapping to Sparx login URLs:
  - `https://selectschool.sparx-learning.com/`
  - `https://selectschool.sparx-learning.com/?app=sparx_science&forget=1`
  - `https://selectschool.sparx-learning.com/?app=sparx_reader&forget=1`
- Homework scanning and completion percentage display
- Select homework and view question details
- Generate a step-by-step PDF for completed homework
- Dashboard settings to change theme, wallpaper, and language

## Run locally in GitHub Codespaces

1. Open the repository in Codespaces.
2. Start a simple local server from the workspace root:
   - `python3 -m http.server 8000`
3. Open `http://localhost:8000` in your browser.

The page uses session-only credentials and does not persist passwords to storage.

## Notes

- This implementation now loads homework from a local JSON API endpoint and uses real external API calls for assignment completion.
- Math calculation and answer evaluation is performed with a live MathJS API call, while an external AdviceSlip API verifies the remote connection during scanning.
