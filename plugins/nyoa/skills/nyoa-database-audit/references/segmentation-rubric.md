# Segmentation Rubric

The defaults `/nyoa-database-audit` uses to decide A / B / C / D. Agents can override any threshold through `nyoa-context/feedback.md` — if the agent has filed a correction ("12 months is too long for cold — use 9"), the rubric respects that.

## Decision order

For each contact, apply these rules in order. Stop at the first match.

1. **Hard exclusions → D** (regardless of activity)
   - `unsubscribed: true` in profile
   - `do-not-contact: true` in profile
   - Manual `Segment: D` override in profile
2. **Past client + referrer → A**
   - Has a `closed` entry in their timeline or pipeline AND
   - Has a `Referred: [name]` entry in their timeline, or a `referrals_given` count ≥ 1 in profile
3. **Past client → A** (without referral but recently engaged)
   - Has a closed entry AND last activity within 90 days
4. **Past client → B** (warm but slipping)
   - Has a closed entry AND last activity 91-365 days ago
5. **Past client → C** (gone quiet)
   - Has a closed entry AND last activity 366+ days ago
6. **Active pipeline lead → B**
   - Has `Stage: lead | active | under-contract` in pipeline AND last activity within 60 days
7. **Stale pipeline lead → C**
   - Has `Stage: lead | active` AND last activity 61-365 days ago
8. **Long-dormant pipeline lead → D**
   - Has `Stage: lead | active` AND last activity 366+ days ago AND never reached `under-contract`
9. **Sphere-only (no pipeline entry) → B**
   - No pipeline row, but timeline shows activity within 365 days
10. **Sphere-only stale → C**
    - No pipeline row, timeline last activity 366-730 days ago
11. **Sphere-only dormant → D**
    - No pipeline row, timeline last activity 731+ days ago, no referral history
12. **Default if nothing else matches → C**
    - Surface a red flag — the contact is in the workspace but has insufficient data to segment confidently.

## Threshold defaults (overridable in feedback.md)

| Threshold | Default | Where to override |
|---|---|---|
| Past-client → A vs. B cutoff | 90 days | `feedback.md`: `database_audit.past_client_recent_days: <int>` |
| Past-client → B vs. C cutoff | 365 days | `feedback.md`: `database_audit.past_client_warm_days: <int>` |
| Stale pipeline lead cutoff | 365 days | `feedback.md`: `database_audit.stale_lead_days: <int>` |
| Sphere → D dormancy cutoff | 730 days (2 years) | `feedback.md`: `database_audit.sphere_archive_days: <int>` |
| Referrals required for automatic A | 1 | `feedback.md`: `database_audit.auto_A_referral_count: <int>` |

## Override format

An agent can write override lines to `nyoa-context/feedback.md` under a `## Database audit preferences` section:

```markdown
## Database audit preferences
- past_client_warm_days: 270
- sphere_archive_days: 540
- auto_A_referral_count: 2
```

The skill reads these and applies them. Surface the applied overrides in the output ("Using agent overrides: past_client_warm_days=270") so the agent knows the rubric tightened or loosened.

## How segment tags get written to profile.md

After the audit, each `clients/<slug>/profile.md` gets a section like:

```markdown
## Segment
- 2026-01-08 — A (past client + 2 referrals)
- 2025-01-12 — A (past client, recent activity)
- 2024-01-09 — B (warm sphere)
```

History is preserved. The most recent row is the current segment. `/nyoa-pipeline` reads the most recent row when filtering by segment.

## What to do for each segment (the action plan)

The audit output includes a recommended action per segment. These are starting points; the agent adjusts.

**A list (past clients + active referrers).** Next action defaults:
- Run `/nyoa-touch-cadence` for any A-segment client without one already scheduled.
- Send a personalized "checking in" note within 2 weeks (use `/nyoa-buyer-seller-comms` past-client-birthday template if a birthday is near, otherwise a casual check-in).
- If they've referred someone, send a "thank-you" if you haven't yet.

**B list (warm sphere + active leads).** Next action defaults:
- Add to the next monthly market-update mailing list (run via `/nyoa-market-update` and use the email connector if available).
- For pipeline leads, refresh the listing match against their saved criteria.

**C list (cold leads).** Next action defaults:
- A 3-touch reactivation sequence (market update → useful resource → soft check-in).
- After the sequence, contacts that don't reply move to D in the next audit.

**D list (archive candidates).** Next action defaults:
- No outreach. Move the folder to `clients/_archive/<slug>/` after a 12-week review window so the agent has a chance to override before files leave the active tree.
- The 12-week window gives the agent time to remember "wait, the [Smith] couple should stay active — their kid is graduating and they said they'd move after."

## Honoring "do not contact"

A contact with `do-not-contact: true` or `unsubscribed: true` in their profile:
- Always gets segmented D regardless of any other signal.
- Never appears in any segment's "next action" outreach list.
- The audit output flags them as "DNC" so the agent sees they were respected.

This is the single most important rule. Honor it without exception.
