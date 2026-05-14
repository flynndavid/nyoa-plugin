---
name: nyoa-listing-audit
description: Two modes in one skill. **Listing mode (default):** analyze any real estate listing and produce a strategic audit report, a redesigned listing page (Markdown), and/or a polished HTML demo page with the original photos saved locally. Use this whenever the user shares a property listing — by URL (Zillow, Realtor.com, Redfin, Compass, MLS), address, or pasted content. **Site audit mode (new in v0.7.0):** when the URL is the agent's own marketing website (not a listing), run a paired SEO + AEO audit and produce a prioritized fix list. Triggers on "audit this listing", "what's wrong with this listing", "rewrite this listing", "redo this listing page", "generate a demo listing page", "show me what it could look like", or — for site mode — "audit my site", "SEO audit", "AEO audit", "audit my website", or the agent passing their own site's homepage URL.
---

# Listing Audit

Read the listing the user shared, score it across a fixed rubric, and return a structured audit report. Optionally produce a redesigned listing page in Markdown, or a self-contained HTML demo page with the original photos saved locally.

## When this skill triggers

**Listing mode:**
- User pastes a Zillow / Realtor.com / Redfin / Compass / MLS URL
- User pastes raw listing copy (description, MLS remarks, photo list)
- User gives an address and asks for a review
- Phrases: "audit", "review", "what's wrong with", "fix", "rewrite", "redo", "redesign", "score this listing"

**Site audit mode (new in v0.7.0):**
- User passes the URL of their own marketing website (homepage or any internal page) — not a listing URL
- Phrases: "audit my site", "audit my website", "SEO audit", "AEO audit", "AI-search audit", "is my site getting recommended", "site SEO + AEO", "audit my homepage"

The skill auto-detects: if the URL hostname matches a known portal (zillow.com, redfin.com, realtor.com, compass.com, etc.) → listing mode. If the URL is anywhere else AND no listing keywords are present in the prompt → ask the agent: "Is this a listing audit or a site audit?" Don't guess.

## What to produce

Three possible outputs. Pick based on what the user asked for; ask them if it's ambiguous:

| Output | Template | When to produce |
|---|---|---|
| **Audit report** | `assets/templates/audit-report.md` | Default. Always produce this unless the user explicitly skips. |
| **Redesigned listing (Markdown)** | `assets/templates/redesigned-listing.md` | When the user asks for a rewrite, rewrite, or "redo the copy". |
| **Demo listing page (HTML)** | `assets/templates/listing-page.html` | When the user asks for a "demo page", "mock-up", "visual rebuild", "show me what it could look like", or wants something they can show a seller. Requires images — see Ingest. |

## Workflow

### Capability requirements

Read `nyoa-context/connectors.md`. If user has a stated preference for a web-scrape connector, use it. If multiple web-scrape connectors are available and no preference is set, prefer Firecrawl over Puppeteer (better structured output). If none are available, fall back to agent paste.

- **web-scrape** (`firecrawl` or `puppeteer`): Required for fetching listing pages from Zillow, Redfin, Realtor.com, and Compass, which render with JavaScript and block plain HTTP fetches. Firecrawl is preferred; Puppeteer is the secondary fallback. If neither is available, ask the agent to paste the MLS remarks and photo URLs directly (Tier 3 ingest).
- No other external capabilities required — all audit analysis, report writing, and HTML generation are local.

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

## Compliance pass

Before delivering output, delegate to `/nyoa-compliance-review`:

1. Generate the draft per the rest of this skill's workflow.
2. Invoke `/nyoa-compliance-review` with the draft as input and this skill's name (`nyoa-listing-audit`) as the calling context.
3. If the review returns **APPROVED**, deliver the draft. `/nyoa-compliance-review` appends the disclaimer footer and writes the audit-log entry — do not duplicate.
4. If the review returns **FIX RECOMMENDED** or **FIX REQUIRED**, surface the findings to the user. Apply their chosen action:
   - **Apply all** — use the cleaned draft as the final output.
   - **Apply selected** — apply only the user-chosen fixes.
   - **Override** — capture the user's one-sentence reason; `/nyoa-compliance-review` logs it.
   - **Edit manually** — return the findings to the user and stop; they re-run the skill when ready.
   Then deliver.
5. If the agent's **own input** contained a fair-housing violation, surface it explicitly in your response in addition to letting `/nyoa-compliance-review` catch it.

Canonical rules and jurisdictional reasoning live in `plugins/nyoa/references/compliance/fair-housing.md` (loaded by `/nyoa-compliance-review`). Do not duplicate them here.

## Examples

See `references/examples.md` for two short worked examples (one with severe issues, one already strong).

## Site audit mode (v0.7.0)

When the URL is the agent's own marketing website (not a listing), the skill runs a different rubric — `references/site-audit-rubric.md` — that pairs traditional SEO with AEO (AI-search optimization).

The output is a prioritized fix list with each issue tagged P0 / P1 / P2:

- **Meta titles and descriptions** — length, keyword inclusion, uniqueness across pages.
- **H1 / H2 / H3 hierarchy** — one H1 per page, logical structure, conversational H2s (AEO-shaped).
- **Schema.org markup** — `RealEstateAgent`, `LocalBusiness`, `FAQPage`, `BreadcrumbList`, `RealEstateListing` if applicable.
- **`llms.txt`** — present at root, structured per the emerging convention. Generated starter if missing.
- **Citation-worthy paragraphs** — every major claim has a data point or date.
- **Internal linking** — key pages cross-linked, no orphan pages.
- **Mobile readability** — font size, button size, viewport meta.
- **Image optimization** — lazy-loading, alt text, file sizes.
- **Page-lead structure** — does each page lead with the answer, then the explanation? (AEO crawlers reward this.)
- **Trust signals** — license number, brokerage name, geographic specificity, real contact info visible.
- **Footer NAP consistency** — Name / Address / Phone matches Google Business Profile and brokerage records.

The site-audit output ends with a **5-step implementation roadmap** ordered for impact-per-hour-of-work. Most agents won't fix 30 things; they'll fix the top 5.

For the AEO portion specifically, see `references/site-audit-rubric.md` for the specific checks (conversational H2s, FAQ schema, direct-answer paragraphs, llms.txt structure).

## Output format

Always Markdown. Always headed with the property address and price (listing mode) or the site URL and primary market (site-audit mode). Always end with a "What I'd do first" 3-bullet summary so the agent can act in <2 minutes.

The disclaimer footer is appended automatically by `/nyoa-compliance-review` — do not include it in this skill's own output template.
