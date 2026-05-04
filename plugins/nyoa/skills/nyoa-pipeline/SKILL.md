---
name: nyoa-pipeline
description: Show, summarize, and edit the agent's pipeline of clients and listings — surfaces stale entries, suggests follow-ups, and lets the agent move clients between stages. Use this skill when an agent says "show my pipeline", "what am I working on", "who haven't I followed up with", "move <client> to under-contract", or "clean up my pipeline". Triggers on phrases like "pipeline", "my deals", "what am I working on", "stale leads", "who needs a follow-up".
---

# Pipeline

The single command for the agent to see, edit, and act on their book of business. Reads `nyoa-workspace/pipeline.md` and the underlying client/listing folders; writes back to `pipeline.md` when the agent makes changes.

## When this skill triggers

- "Show my pipeline" / "what am I working on" / "how many active deals do I have"
- "Who haven’t I followed up with" / "stale leads" / "clean up my pipeline"
- "Move <Jane> to under-contract" / "close out <address>"
- Phrases: "pipeline", "deals", "book", "active"

## Inputs you need

Nothing required. The skill reads the workspace. The agent may follow up with edits.

## Workflow

### 1. Read state

- Read `nyoa-workspace/pipeline.md`. If it doesn’t exist, ask the agent to run `/nyoa-setup` (or `/nyoa-client-add` / `/nyoa-listing-new`) first.
- For each entry, follow the link to the canonical folder. Read:
  - For clients: `clients/<slug>/profile.md` (stage), `timeline.md` (last entry timestamp).
  - For listings: `listings/<slug>/property.md` (status, list date), `showings.md` last entry, `offers.md` last entry.
- Compute “last activity” as the most recent timestamp across the relevant logs.

### 2. Summarize

Return a stage-by-stage table:

```
## Pipeline summary (as of YYYY-MM-DD)

| Stage | Count | Hot (≤7d) | Warm (8–21d) | Stale (>21d) |
|-------|-------|----------|-------------|---------------|
| Leads | N | n | n | n |
| Active | N | n | n | n |
| Under contract | N | n | n | n |
| Closed (90d) | N | — | — | — |
```

Below the table, list the entries grouped by stage with last-activity dates and the next action for each.

### 3. Surface stale entries

Define stale as: lead with no activity >14 days, active with no activity >7 days, listing on market >30 days with no recent showings, under-contract with no activity >5 days during the contingency window. Tune to taste based on what the agent’s feedback.md says.

For each stale entry, propose one concrete follow-up:

- Stale lead with email on file → "Run `/nyoa-buyer-seller-comms` for a check-in email."
- Stale active buyer → "Send 3 fresh listings matching their preferences."
- Active listing >30 days → "Run `/nyoa-listing-audit` to diagnose; consider price reduction discussion."
- Stale under-contract → "Status check with lender + escrow."

### 4. Edits the agent can request

Accept these in plain language and rewrite `pipeline.md` accordingly:

- **Move stage**: "move Jane to under-contract" → remove from old section, append to new section, append a `timeline.md` entry, refresh `Last updated:` stamp.
- **Update next step**: "Jane next step is send disclosures by Friday" → update the entry’s `next:` clause.
- **Mark closed**: triggers a follow-up suggestion — "Run `/nyoa-testimonial-engine` to draft a review request."
- **Remove**: "drop Jane from pipeline" → ask for confirmation; if yes, move to `## On hold / nurture` (don’t delete the folder).

Never delete a client or listing folder — stage moves are pipeline-only.

### 5. Calendar + tasks integration

If an entry’s `next:` clause includes a date, also append to `nyoa-workspace/calendar.md` and `tasks.md`. If `nyoa-context/connectors.md` shows google-calendar or a CRM is wired up, suggest syncing there too — don’t auto-sync without confirmation.

## Compliance pass

- Don’t echo PII in the summary unless the agent’s screen is private (assume it isn’t — use first names + last initial in summaries).
- Stage moves involving "closed" should be paired with a referral/review prompt; don’t skip that nudge.

## Output format

Markdown summary table, then per-stage entries, then “Stale entries needing follow-up”, then any edits performed in this run.

End with: `Voice used: NYOA house`.

## Shared context

Reads `nyoa-workspace/pipeline.md`, `clients/*/`, `listings/*/`. Writes `pipeline.md`, appends to relevant `timeline.md` files when stages move, may append to `calendar.md` / `tasks.md`.

## Reference files

- `plugins/nyoa/references/context-formats.md` — pipeline entry format
