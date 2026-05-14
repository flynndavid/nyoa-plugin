---
name: nyoa-database-audit
description: Annual deep audit of the agent's full contact database. Reads the entire `nyoa-workspace/clients/` folder and `pipeline.md`, segments every contact into A (past clients + active referrers), B (warm sphere), C (cold 12-month+), or D (archive candidates), and writes a segmentation report to `reviews/` plus segment tags on each client profile. Use this skill once a year (January or after a major business pivot), or whenever the agent asks "audit my database", "segment my contacts", or "who haven't I talked to in a year". Triggers on "database audit", "annual segmentation", "A/B/C/D list", "audit my CRM", "who's stale", "clean up my contact list".
---

# Database Audit

The annual deep read of the agent's full contact list. Where `/nyoa-pipeline` shows what's in flight, this skill audits everyone — including the long tail of past clients, dormant leads, and one-time sphere contacts that have aged out of the active pipeline.

Output is a four-bucket segmentation (A/B/C/D), a per-segment action plan, and segment tags written to each client's profile so the next `/nyoa-pipeline` run can surface segments.

## When this skill triggers

- "Database audit"
- "Annual segmentation"
- "Segment my contacts into A/B/C/D"
- "Audit my CRM"
- "Who haven't I talked to in a year"
- "Who's stale"
- "Clean up my contact list"
- "First week of January database review"

## Inputs you need

Required:
- A populated `nyoa-workspace/clients/` folder. If the agent has fewer than ~20 client folders, the audit isn't yet useful — say so.

Optional but improves output:
- A CSV export from the agent's CRM (if they have one outside NYOA) — we'll merge it with the workspace data to give a fuller picture. Paste or upload.
- Stated criteria from the agent ("anyone who's referred me twice is automatic A", "I want B to mean active-this-year not active-this-quarter") — overrides the defaults.
- A target output (do they want the report, or the report + the segment tags + the first action email per segment?).

## Workflow

### Capability requirements

Read `nyoa-context/connectors.md`. If the agent has a stated preference for a capability, use the corresponding connector. If multiple connectors are available for a capability and no preference is set, ask which to use. If none are available, fall back to file-only behavior.

- **crm** (`follow-up-boss`, `hubspot`, `salesforce`, or equivalent): When available, NYOA offers to pull contacts the agent has in their CRM but not in `nyoa-workspace/clients/` and merge them into the audit. Falls back to a "paste your CRM export" prompt.
- **docs** (`google-workspace` or `notion`): When available, NYOA offers to save the segmentation report to cloud storage alongside the workspace write-through.
- No other external capabilities required.

1. **Read the full clients folder.** Enumerate every `clients/<slug>/` folder. For each: pull last activity date from `timeline.md`, lead source from `profile.md`, current stage from `pipeline.md`, and any prior segment tag from `profile.md`.
2. **Apply the segmentation rubric** (`references/segmentation-rubric.md`):
   - **A** — Past clients who have referred someone, or who have shown up in the timeline in the last 90 days.
   - **B** — Warm sphere / active leads — appeared in any timeline within 365 days, or actively in pipeline.
   - **C** — Cold leads — last activity 12-18 months ago, never closed.
   - **D** — Archive candidates — last activity 18+ months ago AND never closed AND no referral history. Or explicitly marked "do not contact" / "unsubscribed".
3. **Honor agent overrides.** If the agent has a `profile.md` line that explicitly states a segment, that wins over the rubric.
4. **Build the segmentation table.** One row per contact: name, segment, reason for the segment, last activity date, recommended next action.
5. **Build the summary counts and the action plan.**
6. **Compliance pass.**
7. **Write to workspace.**
8. **Deliver inline as Markdown.**

## Compliance pass

This skill produces an agent-facing segmentation report and writes tags into local client profiles. The report itself is internal, but recommended actions per segment may seed outward-facing comms.

- **If you copy any part of this output into outward-facing communication** (segment-specific emails, reactivation sequences, goodbye notes), run `/nyoa-compliance-review` on the drafted message first.
- **Honor unsubscribes.** Any contact with `unsubscribed: true` or `do-not-contact: true` in their profile goes to D regardless of activity. They never appear in any segment's "next action" outreach plan.
- **No segmentation for marketing without consent.** D-segment contacts are not "send a goodbye email and archive". They're "leave alone and archive folder reference". Don't draft a goodbye email unless the agent explicitly asks.
- **No protected-class segmentation.** Never segment by anything that resembles a protected class (age, family status, religion, etc.) even if the agent's `profile.md` records it.
- **PII stays local:** segment tags, contact details, and segmentation reasoning live in `nyoa-workspace/` files only — never in outputs intended for external sharing.
- **No invented activity.** If a client has no timeline file, don't infer activity from elsewhere. Mark them "no activity logged" and segment based on last `pipeline.md` mention or `profile.md` create date.
- **No disparaging language** about contacts in any record (the segment reason is neutral fact — "last activity 14 months ago", not "cold and unresponsive").

Canonical fair-housing rules: `plugins/nyoa/references/compliance/fair-housing.md`.

Footer to include on the output (verbatim):

> Segmentation is a snapshot based on the workspace as of {{audit_date}}. CRM data outside the workspace was not consulted unless the agent provided it. Verify any "do not contact" / "unsubscribed" tag against the agent's source-of-truth list before any outreach.

## Workspace integration

- **Save the report** to `nyoa-workspace/reviews/database-audit-YYYY-MM-DD.md`. Reports are dated and never overwrite — running again next year keeps both for year-over-year comparison.
- **Write segment tags** to each `clients/<slug>/profile.md` under a `## Segment` section. Format: `Segment: A | B | C | D` with a one-line reason and date. Existing segment tags get appended-to, not overwritten — `/nyoa-pipeline` can read the most recent.
- **Refresh `pipeline.md`** — surface the summary counts (e.g., "47 A / 142 B / 89 C / 108 D") at the top of the file under a `## Database snapshot (YYYY-MM-DD)` section.
- **Append to `tasks.md`** — one task per segment with the recommended first action and a target date (default: A within 2 weeks, B within 6 weeks, C within 8 weeks, D archive review within 12 weeks).

## Output format

Single Markdown response with these sections:

1. **Header** — audit date, total contacts audited, source (workspace only vs. workspace + CRM import).
2. **Summary counts** — count and % per segment.
3. **Segmentation table** — one row per contact, sortable.
4. **Per-segment action plan** — what the agent should do for each segment, with target dates and which existing NYOA skills to chain (e.g., A → `/nyoa-touch-cadence` for any past client without one; B → `/nyoa-buyer-seller-comms` for next month's market update; C → 3-email reactivation sequence; D → archive review).
5. **Red flags** — contacts whose data is incomplete, mis-tagged, or suspicious (no email, no activity, duplicate names, contradictory tags). Each red flag gets a one-line fix recommendation.
6. **Compliance footer** (verbatim).
7. **Workspace confirmation** — what was filed.

End with: "Audit saved to nyoa-workspace/reviews/database-audit-YYYY-MM-DD.md. Segment tags written to {{n}} client profiles."

## Shared context

Reads from `nyoa-context/`:
- `connectors.md` — capability branching.
- `feedback.md` — any prior corrections about segmentation thresholds.

Reads from `nyoa-workspace/`:
- `clients/<slug>/profile.md` for every slug.
- `clients/<slug>/timeline.md` for every slug.
- `pipeline.md` — current stages, prior database snapshot.
- `reviews/` — prior audits, for year-over-year diffs if the agent asks.

Writes to `nyoa-workspace/`:
- `reviews/database-audit-YYYY-MM-DD.md` — primary writer.
- `clients/<slug>/profile.md` — appends a `## Segment` section.
- `pipeline.md` — refreshes the database-snapshot section.
- `tasks.md` — appends per-segment action tasks.

## Reference files

- `references/segmentation-rubric.md` — full A/B/C/D rules, threshold defaults, override behavior.
