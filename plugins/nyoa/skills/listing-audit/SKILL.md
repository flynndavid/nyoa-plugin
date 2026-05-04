---
name: listing-audit
description: Analyze any real estate listing and produce a strategic audit report, a redesigned listing page (Markdown), and/or a polished HTML demo page with the original photos saved locally. Use this skill whenever the user shares a property listing — by URL (Zillow, Realtor.com, Redfin, Compass, MLS), address, or pasted content — and wants to evaluate, fix, rebuild, or generate a visual mock-up of it. Triggers on phrases like "audit this listing", "what's wrong with this listing", "rewrite this listing", "redo this listing page", "generate a demo listing page", "show me what it could look like", or when the user simply pastes a listing URL.
---

# Listing Audit

Read the listing the user shared, score it across a fixed rubric, and return a structured audit report. Optionally produce a redesigned listing page in Markdown, or a self-contained HTML demo page with the original photos saved locally.

## When this skill triggers

- User pastes a Zillow / Realtor.com / Redfin / Compass / MLS URL
- User pastes raw listing copy (description, MLS remarks, photo list)
- User gives an address and asks for a review
- Phrases: "audit", "review", "what's wrong with", "fix", "rewrite", "redo", "redesign", "score this listing"

## What to produce

Three possible outputs. Pick based on what the user asked for; ask them if it's ambiguous:

| Output | Template | When to produce |
|---|---|---|
| **Audit report** | `assets/templates/audit-report.md` | Default. Always produce this unless the user explicitly skips. |
| **Redesigned listing (Markdown)** | `assets/templates/redesigned-listing.md` | When the user asks for a rewrite, rewrite, or "redo the copy". |
| **Demo listing page (HTML)** | `assets/templates/listing-page.html` | When the user asks for a "demo page", "mock-up", "visual rebuild", "show me what it could look like", or wants something they can show a seller. Requires images — see Ingest. |

## Workflow

### 1. Ingest — three tiers, try in order

The MLS portals (Zillow, Redfin, Realtor.com, Compass) render with JavaScript and aggressively block scrapers. Plain WebFetch will return shells of pages or login walls. Use this fallback ladder:

#### Tier 1 — Firecrawl MCP (preferred when available)

If the Firecrawl MCP is installed (tools named `mcp__*__firecrawl_*`), use it. Firecrawl runs a real browser, handles JS rendering, and returns structured data + image URLs.

- Use `firecrawl_extract` with a schema for: `address`, `price`, `beds`, `baths`, `sqft`, `lot_size`, `year_built`, `days_on_market`, `status`, `mls_remarks`, `listing_agent`, `brokerage`, `photo_urls` (array of full-resolution image URLs).
- Fall back to `firecrawl_scrape` if extract fails — request `formats: ["markdown", "screenshot"]` and pull image URLs from the markdown.

#### Tier 2 — WebFetch

If no Firecrawl, try WebFetch. Works for some MLS / brokerage pages, fails on most consumer portals. If the response looks like a login wall, JavaScript stub, or "are you a robot" page, skip to Tier 3.

#### Tier 3 — User paste

Ask the user to paste the MLS remarks + the photo URLs (or upload photos directly). Confirm address + price before proceeding. Do not invent property facts.

### 1b. Save the photos locally (only if producing the HTML demo page)

Once you have photo URLs, save them under the user's current working directory:

```
./listings/<address-slug>/images/
  ├── 01-hero.jpg
  ├── 02-kitchen.jpg
  ├── 03-livingroom.jpg
  └── ...
```

- `<address-slug>` = lowercase, dash-separated address (e.g., `123-maple-st-east-nashville`).
- Number the files in the order they appear in the listing (the first one is usually the hero).
- Use Bash + `curl -L -o` for each URL. Add a `User-Agent` header (`-A "Mozilla/5.0"`) for portals that block default curl. Skip any that 403 — note them in the audit but don't fail the run.
- Cap at 25 photos. If there are more, save the first 25.
- After saving, list the local paths so the HTML template can reference them with relative paths (`./images/01-hero.jpg`).

If you don't have photo URLs and the user can't paste them, skip the HTML demo page and tell the user explicitly (don't synthesize a demo page from stock photos).

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

### 5. (Optional) Write the redesigned listing — Markdown

Only if the user asked for a rewrite. Use `assets/templates/redesigned-listing.md`. The redesign keeps every verifiable fact from the original (square footage, beds/baths, year built, etc.) and rewrites the narrative.

If a per-agent voice file is available (`agents/<name>/voice.md` or wherever the user points), match that voice. Otherwise use NYOA house style: warm, specific, confident, no real-estate clichés ("nestled", "boasts", "must see", "luxury living awaits"), no fair-housing risk language.

### 6. (Optional) Generate the demo HTML listing page

Only if the user asked for a demo / mock-up / visual rebuild AND photos are available locally (step 1b). Use `assets/templates/listing-page.html` as the starting structure.

- Copy the template to `./listings/<address-slug>/index.html`.
- Substitute every `{{variable}}` with real values. The hero photo is `./images/01-hero.jpg`; gallery photos are `./images/02-*.jpg` through whatever the highest number is.
- Use the redesigned MLS remarks (step 5) for the hero copy and the redesigned long description for the body. Don't reuse the old broken copy.
- Inline all CSS in `<style>`. The HTML must work as a single file opened from the local filesystem (`file://...`).
- After writing, tell the user the absolute path to the file so they can open it in a browser.

## Compliance guardrails

- **Never** include language implying preference for or against protected classes (race, color, religion, sex, disability, familial status, national origin). The rubric in `references/rubric.md` lists common red-flag phrases.
- **Never** assert structural facts not in the source (no "fully renovated" if you can't verify it; no school district claims unless the listing stated them).
- **Never** suggest removing or altering disclosures.
- If the source has compliance issues, flag them as P0 in the audit and rewrite without them.

## Examples

See `references/examples.md` for two short worked examples (one with severe issues, one already strong).

## Output format

Always Markdown. Always headed with the property address and price. Always end with a "What I'd do first" 3-bullet summary so the agent can act in <2 minutes.
