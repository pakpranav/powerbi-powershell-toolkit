# MIS Portfolio

A working portfolio repo for Management Information Systems coursework and personal projects — dashboards, automation scripts, and data/systems work, versioned and documented like production tooling.

## Why this exists

MIS sits at the intersection of business and tech: the goal isn't just to write code, it's to show you can turn a business problem (reporting, a manual process, a messy dataset) into something reliable and reusable. This repo is structured so each project stands on its own, with a README that explains the *business* problem it solves, not just the technical implementation.

## Structure

```
.
├── powerbi-reports/        # Power BI projects — one folder per dashboard/report
│   └── sample-dashboard/   # Example: swap in your own
├── powershell-scripts/     # Automation scripts (RLS management, migrations, etc.)
├── docs/                   # Screenshots, architecture diagrams, write-ups
└── .github/workflows/      # Optional CI checks (script linting, etc.)
```

## Conventions

- **One project per folder.** Don't dump every assignment into one repo — each meaningful project (a dashboard, a script, a database design) gets its own top-level folder with its own README.
- **No hardcoded credentials or secrets.** Config values (API keys, workspace IDs, connection strings) go in a `config.example.json` or `.env.example` file that's checked in, with the real values in a gitignored `config.json`/`.env`. See `powershell-scripts/config.example.json` for the pattern.
- **Screenshots over raw binaries.** `.pbix` files are binary and don't diff well in git. Where possible, include a screenshot or short write-up of the dashboard in the project's README, and only commit the `.pbix` itself if the file size is reasonable.
- **README per project** answering: what business problem does this solve, what does it do, how do you run it, what would you improve next.

## Getting started

1. Clone the repo.
2. `training-investment-dashboard` and the two PowerShell scripts are a fleshed-out example (fictional data, no real org details) showing the level of detail worth including — swap them for your own projects, or add new folders following the same pattern.
3. Update this top-level README's project list below as you add things.

## Projects

| Project | Type | Description |
|---|---|---|
| `powerbi-reports/training-investment-dashboard` | Power BI | Dashboard giving department leads a live view of training spend vs. budget, sourced from a SharePoint request list, with department-level row-level security |
| `powershell-scripts/` | PowerShell | RLS role reconciliation and cross-workspace report migration, both config-driven with no hardcoded IDs or secrets |

## License

MIT — see `LICENSE`. Feel free to adjust if your coursework has different requirements.
