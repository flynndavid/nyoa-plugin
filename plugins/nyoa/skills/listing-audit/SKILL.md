---
name: listing-audit
description: Analyze any real estate listing and produce a strategic audit report and (optionally) a redesigned listing page. Use this skill whenever the user shares a property listing — by URL (Zillow, Realtor.com, Redfin, MLS), address, or pasted content — and wants to evaluate, fix, or rebuild it. Triggers on phrases like "audit this listing", "what's wrong with this listing", "rewrite this listing", "redo this listing page", or when the user simply pastes a listing URL.
---

# Listing Audit

Read the listing the user shared, score it across a fixed rubric, and return a structured audit report. Optionally redesign the listing page.

## When this skill triggers

- User pastes a Zillow / Realtor.com / Redfin / Compass / MLS URL
- User pastes raw listing copy (description, MLS remarks, photo list)
- User gives an address and asks for a review
- Phrases: "audit", "review", "what's wrong with", "fix", "rewrite", "redo", "redesign", "score this listing"

## What to produce

By default, produce **only the audit report** (`assets/templates/audit-report.md`). Only produce the redesigned listing page (`assets/templates/redesigned-listing.md`) if the user explicitly asks for a rewrite or redesign.

## Workflow

### 1. Ingest

If the user shared a URL → fetch the page (use WebFetch). Pull:
- Address, price, beds, baths, square footage, lot size, year built, days on market, status
- MLS remarks / public description (verbatim)
- Photo count + brief description of each photo if available
- Listing agent name + brokerage
- Any flags: price drops, back-on-market, contingencies

If the user pasted text → ask them to confirm address + price, then proceed with what they gave you.

If the user only gave an address with no other info → ask for a URL or the MLS remarks before continuing. Do not invent property facts.

### 2. Score across the rubric

Use the rubric in `references/rubric.md`. Score each dimension 1–5. Calculate the overall grade.

Rubric dimensions (full definitions in `references/rubric.md`):

1. **Hook strength** — does the first sentence stop a buyer scrolling?
2. **Lifestyle clarity** — can a buyer picture their life there?
3. **Specificity** — concrete features, finishes, dimensions vs vague adjectives?
4. **Photo–copy alignment** — does the copy match what the photos show?
5. **Buyer-targeting** — is it written for a defined buyer (first-time / move-up / investor / luxury / downsizer)?
6. **Compliance & risk** — Fair Housing language, no protected-class implications, no unverified structural claims
7. **Call to action** — what does the buyer do next, and is the path frictionless?
8. **Differentiation** — does it sound like every other listing or like a specific home?

### 3. Find the kill issues

Pull out 1–3 "kill issues" — the things hurting this listing the most. These belong at the top of the report. Prioritize:
- Compliance / Fair Housing violations (always P0)
- Photo–copy contradictions (e.g., copy says "move-in ready" but photos show construction)
- Wasted hook (boring or generic first line)
- Missing buyer target

### 4. Write the audit report

Use `assets/templates/audit-report.md` as the structure. Fill it out completely. The report should be scannable — agent should be able to read it in under 90 seconds.

### 5. (Optional) Write the redesigned listing

Only if the user asked for a rewrite. Use `assets/templates/redesigned-listing.md`. The redesign keeps every verifiable fact from the original (square footage, beds/baths, year built, etc.) and rewrites the narrative.

If a per-agent voice file is available (`agents/<name>/voice.md` or wherever the user points), match that voice. Otherwise use NYOA house style: warm, specific, confident, no real-estate clichés ("nestled", "boasts", "must see", "luxury living awaits"), no fair-housing risk language.

## Compliance guardrails

- **Never** include language implying preference for or against protected classes (race, color, religion, sex, disability, familial status, national origin). The rubric in `references/rubric.md` lists common red-flag phrases.
- **Never** assert structural facts not in the source (no "fully renovated" if you can't verify it; no school district claims unless the listing stated them).
- **Never** suggest removing or altering disclosures.
- If the source has compliance issues, flag them as P0 in the audit and rewrite without them.

## Examples

See `references/examples.md` for two short worked examples (one with severe issues, one already strong).

## Output format

Always Markdown. Always headed with the property address and price. Always end with a "What I'd do first" 3-bullet summary so the agent can act in <2 minutes.
