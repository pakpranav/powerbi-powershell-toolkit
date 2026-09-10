# Training Investment Dashboard

## Business problem

Department leads were tracking employee training requests and spend in a shared Excel workbook that got emailed around and re-versioned constantly — nobody had a single up-to-date view of how much a department had committed to spend against its training budget for the year, and finance found out about overruns after the fact instead of before approving the next request.

This dashboard pulls training requests from a SharePoint list (where managers submit requests through a simple form) and gives each department lead a live view of committed spend vs. budget, broken out by quarter and training category, so overruns get caught at approval time instead of at quarter close.

## Data source

- **SharePoint list** (`Training Requests`) — one row per request: employee, department, course name, vendor, cost, approval status, date requested.
- **Departmental budget table** — maintained separately (Excel, synced into Power BI) since budget figures change less often than requests.

## What it does

- **Spend vs. budget by department**, updated as new requests are approved (not just submitted, so pending requests don't inflate the number).
- **Quarterly trend view** so a department lead can see whether they're pacing ahead of or behind their annual budget.
- **Category breakdown** (technical certifications, conferences, internal training, etc.) to show what the money is actually going toward.
- **Row-level security by department** — a department lead only sees their own department's requests and budget; a small admin group sees everything. This was the main reason for building out the RLS automation in `powershell-scripts/` — manually adding people to the right RLS role in the Power BI service every time someone changed departments wasn't sustainable.

## Constraints worth knowing about

- Built on Power BI **Pro** licensing, not Premium — this ruled out some deployment pipeline options (no dataflows gateway automation, tighter API rate limits) and shaped how the refresh and RLS assignment scripts had to work around those limits rather than through a cleaner Premium-tier pipeline.
- SharePoint list as a data source means schema changes on the list (a manager adding a new "training category" choice, for example) can break the report's category grouping if the Power Query step isn't updated to match — this is a known fragility point, not something solved yet.

## How to run it

1. Open `TrainingInvestment.pbix` in Power BI Desktop.
2. Update the SharePoint site URL and list name in Power Query (Transform Data → Data source settings) to point at your own list.
3. Refresh.
4. To manage who sees what department's data, use `../../powershell-scripts/Set-ReportPermissions.ps1` rather than adding RLS members by hand in the service.

## Screenshots

_Add a screenshot of the actual report here once built — `docs/` at the repo root is a good place for it._

## Next steps

- Move from manual refresh to a scheduled gateway refresh now that the data volume justifies it.
- Add a "budget at risk" alert (via Power Automate) that flags a department once committed spend crosses 90% of budget, instead of relying on someone opening the dashboard to notice.
- Evaluate whether category taxonomy should move off the SharePoint list's free-text-ish choice field and into a proper lookup table, to stop the schema-fragility issue above.
