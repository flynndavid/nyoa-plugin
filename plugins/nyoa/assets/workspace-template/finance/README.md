# Finance

Bookkeeping artifacts produced by `/nyoa-bookkeeping`. Organized by month under `finance/YYYY-MM/`.

## File types

Each month folder can contain:

- **`receipts.md`** — categorized expense report + bookkeeper email draft (one per month).
- **`settlement-<property-slug>.md`** — settlement-statement extraction (one per closing). Cross-linked from `nyoa-workspace/listings/<slug>/offers.md`.
- **`mileage.md`** — month's mileage log (one per month).

If the skill is re-run with corrected data, the prior version is backed up to `<filename>.bak.md` before the new one is written. Settlement files are never overwritten — each closing is its own permanent file.

## What this folder is for

Drafting only. The agent's authoritative books live in their accounting system (QuickBooks, Xero, brokerage system, spreadsheet). These files are a fast-pass categorization that the agent (or their bookkeeper) reviews before importing.

NYOA categorizes; the CPA decides deductibility. Every output in this folder carries a verification footer to that effect.

## Privacy

This folder contains financial data. Don't commit it to the public NYOA repo if you're using NYOA in a tracked git workspace. The repo's `.gitignore` should exclude `nyoa-workspace/finance/`.
