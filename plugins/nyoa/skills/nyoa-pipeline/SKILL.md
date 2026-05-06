---
name: nyoa-pipeline
description: Show, summarize, and edit the agent's pipeline of clients and listings — surfaces stale entries, suggests follow-ups, and lets the agent move clients between stages. Use this skill when an agent says "show my pipeline", "what am I working on", "who haven't I followed up with", "move <client> to under-contract", or "clean up my pipeline". Triggers on phrases like "pipeline", "my deals", "what am I working on", "stale leads", "who needs a follow-up".
---

# Pipeline

The single command for the agent to see, edit, and act on their book of business. Reads `nyoa-workspace/pipeline.md` and the underlying client/listing folders; writes back to `pipeline.md` when the agent makes changes.

## When this skill triggers

- "Show my pipeline" / "what am I working on" / "how many active deals do I have"
- "Who haven't I followed up with" / "stale leads" / "clean up my pipeline"
- "Move <Jane> to under-contract" / "close out <address>"
- Phrases: "pipeline", "deals", "book", "active"

## Inputs you need

Nothing required. The skill reads the workspace. The agent may follow up with edits.

## Workflow

### Capability requirements

This skill can use:
- **calendar** — if google-workspace calendar is detected and preferred, `/nyoa-pipeline` offers to sync deadline entries as Calendar events. Falls back to writing to `nyoa-workspace/calendar.md` only.

Read `nyoa-context/connectors.md` and check `User-stated preferences.calendar`. If set and available, offer to sync; always ask for confirmation before creating events.

### 1. Read state

- Read `nyoa-workspace/pipeline.md`. If it doesn't exist, ask the agent to run `/nyoa-setup` (or `/nyoa-client-add` / `/nyoa-listing-add`) first.
- For each entry, follow the link to the canonical folder. Read:
  - For clients: `clients/<slug>/profile.md` (stage), `timeline.md` (last entry timestamp).
  - For listings: `listings/<slug>/property.md` (status, list date), `showings.md` last entry, `offers.md` last entry.
- Compute "last activity" as the most recent timestamp across the relevant logs.

### 2. Summarize

Return a stage-by-stage table:

```
## Pipeline summary (as of YYYY-MM-DD)

| Stage | Count | Hot (≤7d) | Warm (8-21d) | Stale (>21d) |
|-------|-------|----------|-------------|---------------|
| Leads | N | n | n | n |
| Active | N | n | n | n |
| Under contract | N | n | n | n |
| Closed (90d) | N | — | — | — |
```

Below the table, list the entries grouped by stage with last-activity dates and the next action for each.

### 3. Surface stale entries

Define stale as: lead with no activity >14 days, active with no activity >7 days, listing on market >30 days with no recent showings, under-contract with no activity >5 days during the contingency window. Tune to taste based on what the agent's feedback.md says.

For each stale entry, propose one concrete follow-up:

- Stale lead with email on file → "Run `/nyoa-buyer-seller-comms` for a check-in email."
- Stale active buyer → "Send 3 fresh listings matching their preferences."
- Active listing >30 days → "Run `/nyoa-listing-audit` to diagnose; consider price reduction discussion."
- Stale under-contract → "Status check with lender + escrow."

### 4. Write rolling sections to pipeline.md

When `/nyoa-pipeline` runs and makes any edits, it also refreshes two rolling sections at the bottom of `pipeline.md`. These sections are regenerated fresh each run — source files are never modified.

#### `## Recent logs (last 7d)`

Read recent activity from the underlying folders and render a reverse-chronological summary:

- Read `nyoa-workspace/clients/*/timeline.md` for entries dated within the last 7 days.
- Read `nyoa-workspace/listings/*/showings.md` and `listings/*/offers.md` for entries dated within the last 7 days.
- Render as a reverse-chronological list (newest first):

  ```
  ## Recent logs (last 7d)
  - YYYY-MM-DD — [Client/Listing] — [one-line summary]
  - YYYY-MM-DD — [Client/Listing] — [one-line summary]
  ```

- Entries older than 7 days drop off each refresh — they are not deleted from the source files, just not shown here.
- If no activity in the last 7 days: "No activity logged in the last 7 days."

#### `## Stale items needing attention`

Regenerated each run using the same stale-detection logic as Step 3:

```
## Stale items needing attention
- [Name/Address] — [stage] — last activity [N] days ago — suggested: [action]
```

If no stale items: "No stale items. Pipeline looks healthy."

Both rolling sections live at the bottom of `pipeline.md`, above the `---` footer line and `Last updated:` stamp.

### 5. Edits the agent can request

Accept these in plain language and rewrite `pipeline.md` accordingly:

- **Move stage**: "move Jane to under-contract" → remove from old section, append to new section, append a `timeline.md` entry, refresh `Last updated:` stamp.
- **Update next step**: "Jane next step is send disclosures by Friday" → update the entry's `next:` clause.
- **Mark closed**: triggers a follow-up suggestion — "Run `/nyoa-testimonial-engine` to draft a review request."
- **Remove**: "drop Jane from pipeline" → ask for confirmation; if yes, move to `## On hold / nurture` (don't delete the folder).

Never delete a client or listing folder — stage moves are pipeline-only.

### 6. Calendar + tasks integration

If an entry's `next:` clause includes a date, also append to `nyoa-workspace/calendar.md` and `tasks.md`. If `nyoa-context/connectors.md` shows google-workspace is wired up and `User-stated preferences.calendar` is set, offer to sync the deadline as a Calendar event — don't auto-sync without confirmation.

## Compliance pass

- Don't echo PII in the summary unless the agent's screen is private (assume it isn't — use first names + last initial in summaries).
- Stage moves involving "closed" should be paired with a referral / review prompt; don't skip that nudge.

## Output format

Markdown summary table, then per-stage entries, then "Stale entries needing follow-up", then any edits performed in this run.

End with: `Voice used: NYOA house`.

## Shared context

Reads `nyoa-workspace/pipeline.md`, `clients/*/`, `listings/*/`. Writes `pipeline.md`, appends to relevant `timeline.md` files when stages move, may append to `calendar.md` / `tasks.md`.

## Reference files

- `plugins/nyoa/references/context-formats.md` — pipeline entry format
