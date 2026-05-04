---
name: nyoa-client-add
description: Add or update a client in the local NYOA workspace — creates a structured client folder (profile, timeline, preferences, documents) and registers them on the pipeline. Use this skill when an agent says "new client", "add a buyer", "add a seller", "new lead", "got a new client", or "track this client". Triggers on phrases like "add client", "new lead", "new buyer", "new seller", "track this person", or whenever the agent wants to start managing a relationship.
---

# Add a Client

Create a structured folder for a new client (or update an existing one) and register them on the pipeline. Every other NYOA skill that touches communications or follow-ups reads from these folders.

## When this skill triggers

- "New client" / "new lead" / "got a new buyer" / "got a new seller"
- "Add Jane Doe as a buyer" / "track this person"
- Agent pastes contact info from Zillow / Realtor.com / referral text

## Inputs you need

Required:
- **Name** (or initials if anonymizing)
- **Type**: buyer / seller / both / investor / renter

Optional but improves cataloging (ask once, accept whatever the agent volunteers, don't interrogate):
- Email, phone, preferred channel
- Source (referral / sphere / Zillow / website / open house / other)
- Stage (lead / nurturing / active / under-contract / closed)
- Timeline / deadline
- Budget range
- Target areas
- Pre-approval status + lender (buyers)
- Property address (sellers)
- Notes

## Workflow

### 1. Detect or scaffold the workspace

If `nyoa-workspace/` doesn't exist yet, create it from `plugins/nyoa/assets/workspace-template/` (top-level files only — no `_template/` subfolders). Tell the agent: "Workspace didn't exist, I scaffolded one. Run `/nyoa-setup` later to fill in your business profile."

### 2. Slug + collision check

Generate a slug from the name per the rule in `plugins/nyoa/references/context-formats.md` (lowercase, dash-separated, ASCII). If `nyoa-workspace/clients/<slug>/` already exists:

- Confirm with the agent: same person? If yes, switch to update mode (modify existing files, don't overwrite). If no, append `-2` (or next available number) to the slug.

### 3. Create the folder

Copy `plugins/nyoa/assets/workspace-template/clients/_template/` to `nyoa-workspace/clients/<slug>/`. Replace `{{client_name}}` placeholders.

Files created:
- `profile.md` — fill in everything the agent provided
- `timeline.md` — add a first entry: today's date, channel, "Client added to NYOA workspace."
- `preferences.md` — fill in whatever was shared; leave the rest blank
- `documents.md` — empty table

### 4. Register on the pipeline

Append a row to `nyoa-workspace/pipeline.md` under the appropriate stage section:

```
- [<Name>](clients/<slug>/) — <type> — last activity YYYY-MM-DD — next: <next step + when>
```

If no "next step" was provided, propose one based on type and stage (e.g., for a new buyer lead with no pre-approval: "send pre-approval reminder by +3 days"). Confirm with the agent before writing.

Update the `Last updated:` stamp at the bottom of `pipeline.md`.

### 5. Cross-link a listing (sellers only)

If the client is a seller and they mentioned a property address, also run a quick prompt: "Want me to create a listing folder for <address> too?" If yes, defer to `/nyoa-listing-add` (or scaffold inline using the same listing template) and link the client folder from `listings/<slug>/property.md` under `## Seller → Client folder`.

### 6. Auto-save side-effects

- If the agent provided a testimonial or referral source worth tracking, also append to `nyoa-context/proofs.md` (testimonials) per the testimonial-engine format.
- If they mentioned a competitor by name, append to `nyoa-context/competitors.md`.
- Don't ask permission for these saves — confirm afterward.

## Compliance pass

- **No protected-class language** in profile.md or preferences.md — "young family" → "household of [N]"; "good schools" → keep but don't infer race / income; never write religion / national-origin / disability inferences.
- **PII handling**: phone numbers, emails, lockbox codes, license #s are saved locally only. Don't echo them back unnecessarily.
- **Source attribution**: always note where the lead came from — helps the agent see ROI by source later.

## Output format

Short confirmation:

```
Created clients/<slug>/
Added to pipeline.md → <stage>
Next: <next step + when>
```

Followed by a one-line suggestion of which skill to run next given context (e.g., "Run `/nyoa-buyer-seller-comms` to draft an intro email.").

End with: `Voice used: NYOA house` (or per `nyoa-context/voice.md` if the next-step suggestion includes copy).

## Shared context

Reads `nyoa-context/profile.md` (agent name, signature). Writes `nyoa-workspace/clients/<slug>/*` and appends to `nyoa-workspace/pipeline.md`. May append to `nyoa-context/proofs.md` and `competitors.md` per Step 6.

## Reference files

- `plugins/nyoa/assets/workspace-template/clients/_template/` — the structure copied for each new client
- `plugins/nyoa/references/context-formats.md` — slug rules, file conventions
