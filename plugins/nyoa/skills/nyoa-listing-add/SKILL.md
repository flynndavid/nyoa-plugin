---
name: nyoa-listing-add
description: Add a new listing to the local NYOA workspace — scaffolds a structured listing folder (property facts, copy, comps, showings, offers, photos) and registers it on the pipeline. Use this skill when an agent says "new listing", "got a new listing", "add this listing", "track this property", or "set up a listing for <address>". Triggers on phrases like "new listing", "add listing", "track this property", or whenever the agent wants a place for a property's marketing, comps, showings, and offers to live.
---

# Add a Listing

Create a structured folder for a new property the agent has just listed (or is preparing to list), and register it on the pipeline. The folder is the canonical home for everything tied to that property: copy, comps, showings, offers, photos.

## When this skill triggers

- "New listing" / "got a new listing" / "add this listing"
- "Track this property" / "set up <address>" / "i just listed <address>"
- Agent pastes an MLS export, a new listing email, or a coming-soon announcement

## Inputs you need

Required:
- **Address** (street + city + state, ideally + zip)
- **List price** (or "TBD" if not yet decided)
- **Status**: coming-soon / active / pending / under-contract / closed / withdrawn

Optional but recommended (ask once, accept what's volunteered):
- MLS #
- Beds / baths / sqft / lot / year built
- List date, contract date, close date
- Property type, garage, HOA, taxes
- Seller name (links to a client folder if one exists)
- Showing instructions, lockbox code
- Photographer / stager / pre-list improvements

## Workflow

### 1. Detect or scaffold the workspace

If `nyoa-workspace/` doesn't exist yet, create it from `plugins/nyoa/assets/workspace-template/`. Tell the agent: "Workspace didn't exist, scaffolded one. Run `/nyoa-setup` later to fill in your business profile."

### 2. Slug + collision check

Generate the slug from the address per `plugins/nyoa/references/context-formats.md` (lowercase, dash-separated, ASCII; strip punctuation). Examples:

- `123 Maple St, East Nashville, TN 37206` → `123-maple-st-east-nashville`
- `4521 Lookout Mountain Pl #4B` → `4521-lookout-mountain-pl-4b`

If `nyoa-workspace/listings/<slug>/` already exists, confirm with the agent: same property? If yes, update mode. If no, append `-2`.

### 3. Create the folder

Copy `plugins/nyoa/assets/workspace-template/listings/_template/` to `nyoa-workspace/listings/<slug>/`. Replace `{{address}}` placeholders. Fill in every field the agent provided; leave the rest blank for later.

Files created: `property.md`, `copy.md`, `comps.md`, `showings.md`, `offers.md`, `photos.md`.

Also create `nyoa-workspace/listings/<slug>/images/` (empty) so subsequent `/nyoa-listing-audit` photo downloads have a destination.

### 4. Link to the seller (if known)

If the agent named a seller:

- Look for `nyoa-workspace/clients/<seller-slug>/`. If it exists, write the relative path into `property.md` under `## Seller → Client folder`.
- If it doesn't exist, ask: "Want me to create a client folder for <seller name>?" If yes, defer to `/nyoa-client-add` (or inline-create) and link both ways.

### 5. Register on the pipeline

Append a row to `nyoa-workspace/pipeline.md` under the appropriate stage:

```
- [<address>](listings/<slug>/) — listing — last activity YYYY-MM-DD — next: <action + when>
```

Default next-step suggestions by status:
- coming-soon → "finalize copy + photos before go-live"
- active → "audit copy and run social cadence"
- pending → "track inspection / appraisal milestones"
- under-contract → "closing checklist"
- closed → "send review request"

### 6. Suggest the next action

Return a tight "what to do next" list based on what's missing:

- No copy in `copy.md` → "Run `/nyoa-listing-copy` to draft MLS remarks + long description."
- No comps in `comps.md` → "Paste your comps export and I'll structure it."
- Photos URL or local path available → "Run `/nyoa-listing-audit <address>` to score the current marketing."
- Status is `coming-soon` or `active` and no social done → "Run `/nyoa-social-content` for launch posts."
- Status is `active` → "Run `/nyoa-listing-presentation` if you haven't already done the seller meeting."

## Compliance pass

- **No protected-class language** anywhere in `property.md` (no "perfect for families", no "safe neighborhood", no school-quality claims unless in the source).
- **No structural claims** the agent didn't verify ("fully renovated", "new roof") — only record what the agent provided.
- **Lockbox codes, gate codes, alarm codes**: save to `property.md` only if the agent insists; flag that this file is local-only and should not be shared.

## Output format

Short confirmation:

```
Created listings/<slug>/
Added to pipeline.md → <status>
Next: <best next action>
```

Followed by 2–3 ranked next-step skills with one-line context for each.

End with: `Voice used: NYOA house`.

## Shared context

Reads `nyoa-context/profile.md`. Writes `nyoa-workspace/listings/<slug>/*` and appends to `nyoa-workspace/pipeline.md`. May invoke or hand off to `/nyoa-client-add`.

## Reference files

- `plugins/nyoa/assets/workspace-template/listings/_template/` — structure copied per listing
- `plugins/nyoa/references/context-formats.md` — slug rules, file conventions
