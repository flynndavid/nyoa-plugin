---
name: nyoa-listing-copy
description: Generate complete listing-launch copy for a real estate listing — MLS remarks, long description, social variants for X / Instagram / Facebook, and a buyer email blast — from the property's facts. Use this skill whenever the user wants to write or rewrite listing copy, generate social posts for a listing, draft a new-listing email, or produce a full listing-launch package. Triggers on phrases like "write listing copy", "MLS remarks for", "social posts for this listing", "new listing email", "launch this listing", or when the user gives a property fact sheet and asks for marketing copy.
---

# Listing Copy

Turn a property fact sheet into a complete listing-launch package. Five deliverables in one pass: MLS remarks, long description, three social variants, and a buyer email blast.

## When this skill triggers

- "Write listing copy / MLS remarks / a long description for [address]"
- "Social posts for this listing"
- "Send out a new-listing email for [address]"
- "Launch this listing"
- User pastes a property fact sheet (address + beds / baths / sqft + features) and asks for marketing copy
- User just renamed or updated a property and asks for a new copy package

## Inputs you need

Required:
- **Address** (verifiable — never invent)
- **Price**
- **Beds / baths / square footage**
- **3-8 specific features** (finishes, layout, lot, location anchors)

Optional but improves output:
- Year built
- Lot size
- Voice mode (see below)
- Property-tone preset (see `references/voice-presets.md`)
- Open house time
- Photo URLs or descriptions
- Buyer profile (first-time / move-up / luxury / investor / downsizer / land)
- Anything verifiable from the agent: school district, HOA fee, recent renovation, comp activity

If any required input is missing, ask. Do **not** invent property facts.

## Voice modes

Determine voice in this order:

1. **Per-agent voice file** — Look for `agents/<agent-name>/voice.md` or `voice.md` in the working directory or anywhere the user pointed Claude. If present, match that voice exactly. Read it before drafting.
2. **Property-tone preset** — If no agent voice file is available (or the user explicitly asks for a tone), use one of the presets in `references/voice-presets.md`: `luxury`, `starter`, `investor`, `fixer`, `land`. Default if unspecified: `starter` for sub-$500K, `luxury` for $1.5M+, otherwise neutral NYOA house style.
3. **NYOA house style** — fallback. Warm, specific, confident. No clichés ("nestled", "boasts", "must see", "stunning", "luxury living awaits"). Concrete features over abstract adjectives. Buyer self-identifies in the first sentence.

## Workflow

1. Confirm the inputs. If anything required is missing, ask once and wait.
2. Resolve voice mode.
3. Write the **MLS remarks** first (`assets/templates/mls-remarks.md`). The hook from the MLS remarks is the seed for everything else.
4. Expand into the **long description** (`assets/templates/long-description.md`).
5. Draft the **three social variants** (`assets/templates/social-x.md`, `social-instagram.md`, `social-facebook.md` if requested — see note below).
6. Draft the **email blast** (`assets/templates/email-blast.md`).
7. Run the compliance pass on every output (see Compliance below).
8. Write through to the workspace (see Workspace integration below).
9. Deliver everything in one Markdown response, in this order: MLS · long · social-x · social-instagram · email blast.

> **Social platforms:** Default set is X, Instagram, and a buyer email. If the user asks for Facebook, LinkedIn, or TikTok script, generate those too using the same voice — the templates are shaped enough to extend.

## Compliance pass (mandatory before delivering)

Scan every output for:

- **Fair Housing red flags** — "great for families", "perfect for kids", "family neighborhood", "walk to church / synagogue / mosque", "Christian / Jewish / Muslim community", "bachelor pad", "perfect for newlyweds", "exclusive community" (when targeting protected class), "great schools" (without source).
- **"Master bedroom"** — replace with "primary bedroom".
- **Unsourced structural claims** — never write "fully renovated", "new roof / HVAC / electrical", "completely updated" unless the agent confirmed it. If unconfirmed, soften ("recently refreshed kitchen") or pull entirely.
- **Cliché ban** — strip "stunning", "must see", "nestled", "boasts", "rare opportunity", "luxury living awaits", "don't miss". Replace with concrete specifics.

If the agent's input itself contains a Fair Housing red flag, surface it explicitly: "I flagged 'great for families' in your input — Fair Housing risk. Rewriting around the lifestyle without the demographic claim."

## Workspace integration

If `nyoa-workspace/listings/<slug>/` exists for the address (or one matches an existing listing folder), also write the canonical copy there:

- Save MLS remarks, long description, hero line, social one-liner, and email blurb into `nyoa-workspace/listings/<slug>/copy.md` under the matching headers.
- Append a line to that file's `## Revision history` with today's date and a one-line summary of what changed.
- Refresh `pipeline.md` last-activity date for the listing.

If the listing folder doesn't exist, ask: "Want me to create `listings/<slug>/` so future copy + comps + showings live alongside this?" If yes, defer to `/nyoa-listing-add`. If no (or if `nyoa-workspace/` doesn't exist at all), skip the write-through silently — the inline Markdown response is still complete.

## Output format

Single Markdown response. Each section under a clear `##` heading. Each output is independently copy-pasteable into the right channel. End with a one-line "Voice used: <agent name | preset name | NYOA house>" so the agent knows what produced this. If the workspace write-through ran, also confirm: "Saved to nyoa-workspace/listings/<slug>/copy.md."
