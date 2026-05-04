---
name: nyoa-log
description: Quick interaction log — captures "I just talked to <client>" or "I just showed <address>" into the right timeline file and refreshes the pipeline last-activity stamp. Use this skill when an agent says "log this", "i just talked to", "i just showed", "add to timeline", "record this call", or wants to drop a quick note about an interaction. Triggers on phrases like "log", "just talked to", "just showed", "record", "note that", "add to timeline".
---

# Log an Interaction

The lowest-friction way to keep the workspace current. The agent says one sentence; this skill files it correctly.

## When this skill triggers

- "I just talked to Jane about Tuesday's showing"
- "Log: showed 123 Maple to the Smiths, lukewarm"
- "Add to timeline for Jane: she's pre-approved at $650k"
- "Note that the inspection on 4521 Lookout came back with a roof issue"
- Phrases: "log", "just talked", "just showed", "record", "note that"

## Inputs you need

The agent's sentence. Parse it.

Required (extract or ask):
- **Subject**: which client and / or which listing
- **What happened**: 1-3 sentences

Optional:
- Channel (call / text / email / in-person / showing / other)
- Sentiment / interest level (hot / warm / cold)
- Next step

## Workflow

### 1. Identify the subject

Match against existing folders:

- Search `nyoa-workspace/clients/*/profile.md` for the named client (case-insensitive, fuzzy on first name + initial).
- Search `nyoa-workspace/listings/*/property.md` for the named address.

If no match:

- Ask: "I don't have <name> in your workspace yet — want me to run `/nyoa-client-add` first?"
- Or for an address: `/nyoa-listing-add`.

If the entry mentions both a client and a listing (e.g., "showed 123 Maple to the Smiths"), log to **both** timelines so cross-referencing works later.

### 2. Append to the timeline

For each subject, append to its `timeline.md` in the canonical format:

```
## YYYY-MM-DD HH:MM — <channel>
<one paragraph: what happened, what was decided, what's next>
Next step: <action + owner + when>
```

If no time was provided, use the current local time. If no channel, default to `note`. Never overwrite — always append.

For showings specifically, also append to `listings/<slug>/showings.md`:

```
## YYYY-MM-DD HH:MM — <buyer's agent name + brokerage, or "<buyer> direct">
Feedback: <what they said>
Interest level: [hot / warm / cold]
Follow-up: <action + when>
```

For offers, append to `listings/<slug>/offers.md` per its template.

### 3. Refresh the pipeline

Update the matching entry in `nyoa-workspace/pipeline.md`:

- Refresh the `last activity YYYY-MM-DD` field.
- If the log includes a next step, replace the existing `next:` clause.
- Update the `Last updated:` stamp at the bottom.

### 4. Detect stage changes

If the log implies a stage change ("we got pre-approved" → lead→active; "offer accepted" → active→under-contract; "closed today" → UC→closed; "deal fell through" → back to active), confirm with the agent: "Sounds like Jane just moved to <new stage>. Move her on the pipeline?" Default yes.

Closed deals trigger a follow-up suggestion: "Want me to draft a review request via `/nyoa-testimonial-engine`?"

### 5. Auto-side-effects

- If the log includes a referral mention ("they were referred by Mark"), append to that source's context (a future feature, but at minimum note in the client's profile.md under `Source:`).
- If the log includes a testimonial-shaped quote ("they said working with me was the best part"), prompt: "Sounds like a testimonial — save to proofs.md?" If yes, run `/nyoa-testimonial-engine` ingestion.
- If the log mentions a competitor agent by name, append a neutral note to `nyoa-context/competitors.md`.

## Compliance pass

- Don't embellish what the agent said. Faithful capture only.
- No protected-class language in logs ("young couple" → "couple"; "Spanish-speaking buyer" only if relevant to representation needs and noted neutrally).
- Don't auto-share logs anywhere external.

## Output format

Ultra-short confirmation:

```
Logged → clients/<slug>/timeline.md
Pipeline refreshed (last activity YYYY-MM-DD)
```

If a stage change happened or a side-effect was suggested, add one line about it.

End with: `Voice used: NYOA house`.

## Shared context

Reads `nyoa-workspace/clients/*/`, `listings/*/`, `pipeline.md`. Writes the matching `timeline.md` (always) and `showings.md` / `offers.md` (when applicable), refreshes `pipeline.md`. May trigger `/nyoa-testimonial-engine` ingestion or `/nyoa-pipeline` stage move.

## Reference files

- `plugins/nyoa/references/context-formats.md` — timeline / showing / offer entry formats
