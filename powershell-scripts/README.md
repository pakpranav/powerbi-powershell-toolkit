# PowerShell Automation Scripts

Small, config-driven scripts for automating recurring admin/reporting tasks. Each script should:

- Read settings from `config.json` (never hardcode workspace IDs, paths, or credentials in the script body)
- Fail loudly with a clear error message rather than silently continuing
- Log what it did (to console and/or a log file, gitignored)

## Setup

1. Copy `config.example.json` to `config.json`.
2. Fill in your real values in `config.json` — this file is gitignored and will never be committed.
3. Run the script you need, e.g.:

   ```powershell
   .\Set-ReportPermissions.ps1 -ConfigPath .\config.json
   ```

## Scripts

| Script | Purpose |
|---|---|
| `Set-ReportPermissions.ps1` | Reconciles Power BI row-level security (RLS) role assignments — e.g. department → security group — against a dataset, so access doesn't have to be updated by hand in the Power BI service every time someone's role changes. |
| `Move-ReportBetweenWorkspaces.ps1` | Migrates a report + dataset from one workspace to another via the REST API. Written for a Pro-licensed (non-Premium) tenant, where the built-in deployment pipeline feature isn't available, so promotion between dev/test/prod has to go through the API instead of a manual export/import click-through. |

Both scripts are stubbed at the actual Power BI REST/management-module calls (marked with comments) rather than wired to a live tenant — the point of including them here is the pattern (config-driven, logged, fails loudly) rather than a working connection to any specific environment.

## Why externalize config

The same script should work in a dev, test, or prod environment without editing code — just point it at a different config file. It also means you can safely share the script (in a repo, with a classmate, in a portfolio) without leaking real workspace IDs or paths.
