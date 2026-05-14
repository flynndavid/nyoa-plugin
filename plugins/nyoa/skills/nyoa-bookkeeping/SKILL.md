---
name: nyoa-bookkeeping
description: The end-of-month bookkeeping helper — three modes in one skill. `receipts` categorizes a month of expense line items into standard real-estate categories and drafts the bookkeeper email; `settlement` extracts gross commission, brokerage split, net commission, and concessions from an ALTA / HUD-1 / closing statement; `mileage` builds a calendar-derived mileage log. Every output writes to `nyoa-workspace/finance/<YYYY-MM>/` with a verification footer. Use this skill at month-end, after every closing, or whenever the agent asks for an expense report, settlement summary, or mileage log. Triggers on "categorize my receipts", "settlement statement", "ALTA", "HUD-1", "closing statement", "mileage log", "expense report", "bookkeeping", "monthly finances".
---

# Bookkeeping

The three end-of-month finance tasks every agent has and most agents postpone: receipts categorization, settlement statement filing, mileage log. NYOA bundles them in one skill because they share the same compliance posture (a drafter for a human bookkeeper's review) and the same output home (`nyoa-workspace/finance/<YYYY-MM>/`).

The skill has three modes. Default behavior: ask which one when the agent invokes the slash command without an argument. The agent can also pass `receipts`, `settlement`, or `mileage` directly.

## When this skill triggers

- "Categorize my receipts for [month]"
- "Process this settlement statement"
- "Settlement statement for [address]"
- "ALTA" / "HUD-1" / "closing statement"
- "Mileage log for [month]"
- "Build my [month] expense report"
- "Bookkeeping help"
- "Monthly finances"
- Agent uploads a PDF/CSV that's recognizably a receipt batch, a settlement statement, or a calendar export

## Inputs you need

Required (vary by mode — the skill prompts for what's missing):
- For `receipts`: the receipts themselves OR an expense list, plus the month and year.
- For `settlement`: the statement PDF or text, plus the property address.
- For `mileage`: the month's calendar entries OR the `calendar.md` file for the month.

Optional:
- The agent's brokerage split agreement (for `settlement` validation).
- The agent's office address (for `mileage` distance estimates).
- Custom category list in `feedback.md` (for `receipts`).
- Prior month's `finance/<YYYY-MM>/` outputs (for consistency in formatting and category usage).

## Workflow

### Mode dispatch

The skill is invoked via `$ARGUMENTS`:

- `/nyoa-bookkeeping receipts` → receipts categorizer
- `/nyoa-bookkeeping settlement` → settlement-statement extractor
- `/nyoa-bookkeeping mileage` → mileage log generator
- `/nyoa-bookkeeping` (no argument) → ask the agent which of the three they want

Each mode's input/output is documented below; the agent picks one per invocation.

**`receipts` — expense categorizer + bookkeeper email**

Input: a batch of receipts (PDFs, image uploads, or a pasted/CSV expense list with date / vendor / amount / description).
Output:
- Categorized line-item table (sorted by date).
- Category summary table (% of total per category).
- Draft bookkeeper email noting any flagged items.

Default real-estate categories: Marketing, Dues & Fees (NAR, MLS, brokerage), Vehicle, Professional Development, Client Gifts, Office, Meals (50% deductibility flag), Travel, Photography & Staging, Software & Subscriptions, Other (flag for review). The agent can override the list in `nyoa-context/feedback.md` under a `## Bookkeeping categories` section.

**`settlement` — settlement-statement extractor**

Input: ALTA settlement statement, HUD-1, or closing disclosure (PDF upload or pasted text).
Output: transaction details, commission details (gross / side / brokerage split / net / referral fees / concessions), expenses tied to the transaction, accounting entry draft, anything ambiguous flagged for review.

**`mileage` — calendar-derived mileage log**

Input: a month of calendar entries (paste, CSV export, or the agent's `nyoa-workspace/calendar.md` for the month).
Output: mileage log table (date, location, purpose, estimated round-trip miles, notes), monthly total broken down by purpose, accounting entry draft.

Mileage estimates default to a flat 12 miles for in-market trips when no specific distance is supplied; the agent can override with their own distances or by setting an "office address" in `profile.md` so the skill computes from there.

### Capability requirements

Read `nyoa-context/connectors.md`. If the agent has a stated preference for a capability, use the corresponding connector. If multiple connectors are available for a capability and no preference is set, ask which to use. If none are available, fall back to file-only behavior.

- **email** (`google-workspace` or `outlook`): For `receipts` mode, when available, NYOA offers to push the bookkeeper email as a draft with the categorized report attached. Always confirm the recipient and attachments before sending — never auto-send.
- **docs** (`google-workspace` or `notion`): When available, NYOA offers to save all three output types to cloud storage alongside the workspace write-through. Particularly useful for `settlement` since CPAs typically want closing files in shared storage.
- **calendar** (`google-workspace` or equivalent): For `mileage` mode, when available, NYOA offers to read the month's calendar directly from the connector instead of asking the agent to paste/export. Falls back to `nyoa-workspace/calendar.md`.
- No other external capabilities required — extraction itself is local.

1. **Resolve the mode.** If the agent said `receipts`, `settlement`, or `mileage`, go to that mode. If they passed nothing or something ambiguous, ask which mode.
2. **Gather inputs** per the mode.
3. **Run the extraction / categorization** per the mode's logic.
4. **Compliance pass.**
5. **Write outputs to `nyoa-workspace/finance/<YYYY-MM>/`.**
6. **Deliver inline as Markdown.**

## Compliance pass

This skill operates on local files only and produces internal financial records. The compliance focus is data handling and accuracy, not fair-housing language.

- **PII stays local:** account numbers, settlement figures, commission amounts, and any client financial details stay in `nyoa-workspace/finance/` files only — never copied into outward-facing communication.
- **No invented numbers:** never fabricate transaction amounts, dates, or counts. Extracted amounts come straight from the source document. If a number is unreadable on a PDF, flag it and ask the agent to verify rather than guessing.
- **No tax advice.** NYOA categorizes; the CPA decides deductibility. Never write "this is deductible" — write "categorized as Marketing" and let the bookkeeper confirm treatment.
- **Flag the close calls.** Any line that could go in two categories gets explicitly flagged in the output (e.g., "May 30 laminator $89 — Office or Marketing depending on use"). The agent decides; we don't.
- **Honor brokerage agreements.** For `settlement`, never compute a net commission that contradicts the brokerage split percentage. If the split on file disagrees with what the statement implies, surface the disagreement — don't override.
- **For `mileage`: the IRS wants contemporaneous records.** A calendar-derived log is a starting point, not a substitute for a real-time mileage app. State that explicitly in the footer.
- **No disparaging language** about clients, vendors, brokerages, or bookkeepers in any record.

If this skill's output is ever copied into outward-facing communication, run `/nyoa-compliance-review` on it first.

Canonical fair-housing rules: `plugins/nyoa/references/compliance/fair-housing.md`.

Footers (one per mode, included verbatim on the relevant output):

`receipts`:
> Categorizations here are a first pass for your bookkeeper or CPA, not a tax-treatment opinion. Verify every line against the source receipt and your accounting policy before importing. Deductibility decisions belong with your tax professional.

`settlement`:
> The original settlement statement is the authoritative source for every figure. The numbers extracted here are a draft for entry into your books — confirm each one against the statement and against your brokerage's split agreement before recording. Any line item flagged for review needs a human's read.

`mileage`:
> A calendar-derived mileage log is an estimator's starting point, not a contemporaneous record. The IRS expects records kept at or near the time of the trip — verify these miles with a real-time GPS-based mileage app, your odometer, or your fleet tracking system before claiming them on a return.

## Workspace integration

If `nyoa-workspace/finance/` exists (or scaffold it from `plugins/nyoa/assets/workspace-template/finance/`):

For all modes, write to `nyoa-workspace/finance/<YYYY-MM>/`:
- `receipts.md` for the `receipts` mode (one file per month — if it exists, back up to `receipts.bak.md` first).
- `settlement-<property-slug>.md` for the `settlement` mode (one file per closing — never overwrite).
- `mileage.md` for the `mileage` mode (one file per month — if it exists, back up to `mileage.bak.md` first).

Cross-link `settlement-<property-slug>.md` from `nyoa-workspace/listings/<slug>/`:
- Append a line to `listings/<slug>/offers.md` (the closing entry): `Settlement filed: ../../finance/YYYY-MM/settlement-<slug>.md`.
- Append a line to `pipeline.md` row: `Settlement filed YYYY-MM-DD`.

## Output format (per mode)

### `receipts` output

1. Header (month/year, expense count).
2. Categorized line-items table.
3. Category summary (total per category, % of total).
4. Flagged items (close calls, anything that needs the agent's eyes).
5. Bookkeeper email draft (subject + body, with the categorized report attached or pasted).
6. Compliance footer (verbatim, `receipts` version).
7. Workspace confirmation.

### `settlement` output

1. Transaction details block.
2. Commission details block.
3. Expenses tied to the transaction.
4. Accounting entry draft (single row, formatted for the agent's accounting system).
5. Flagged items.
6. Compliance footer (verbatim, `settlement` version).
7. Workspace confirmation, including the cross-links to the listing folder.

### `mileage` output

1. Mileage log table.
2. Monthly total + breakdown by purpose.
3. Accounting entry draft.
4. Flagged items (trips without a clear business purpose, trips that double-count).
5. Compliance footer (verbatim, `mileage` version).
6. Workspace confirmation.

End every output with: "Saved to nyoa-workspace/finance/YYYY-MM/<filename>." Skip the save line if no workspace.

## Shared context

Reads from `nyoa-context/`:
- `profile.md` — agent identity, office address (for mileage), brokerage name.
- `feedback.md` — custom category list, mileage rate overrides.
- `connectors.md` — capability branching.

Reads from `nyoa-workspace/`:
- `calendar.md` — for `mileage` mode.
- `listings/<slug>/offers.md` — for `settlement` validation against pipeline state.
- `finance/<prior-YYYY-MM>/` — for category consistency.

Writes to `nyoa-workspace/`:
- `finance/<YYYY-MM>/receipts.md`
- `finance/<YYYY-MM>/settlement-<property-slug>.md`
- `finance/<YYYY-MM>/mileage.md`
- `listings/<slug>/offers.md` (settlement cross-link)
- `pipeline.md` (settlement-filed note)

## Reference files

- `references/expense-categories.md` — default category definitions with examples of what goes in each. Includes the meals 50%-deductibility flag and the home-office gray zone.
- `references/settlement-anatomy.md` — guide to reading ALTA vs. HUD-1 vs. closing disclosure — which line numbers correspond to which extraction fields, what differs by side (buyer / seller), and the most common ambiguities.
- `references/mileage-rules.md` — IRS rules summary for what counts as business mileage, what doesn't, what the home-office-deduction interaction is. NYOA categorizes; the CPA decides.
