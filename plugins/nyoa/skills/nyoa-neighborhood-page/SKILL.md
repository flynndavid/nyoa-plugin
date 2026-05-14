---
name: nyoa-neighborhood-page
description: Generate a Fair-Housing-compliant neighborhood landing page for the agent's website — title, meta, H1, intro, 4-5 feature blocks, 3 schema-ready FAQs, CTA — and file it under `nyoa-workspace/web/neighborhoods/<slug>.md` so the agent can paste it into their CMS. Pairs with `/nyoa-aeo` for AI-search visibility. Use this skill when building or refreshing the agent's neighborhood-specific landing pages. Triggers on "neighborhood page", "build a page for [neighborhood]", "neighborhood landing page", "neighborhood content for my site", "SEO page for [neighborhood]", "guide for [neighborhood]".
---

# Neighborhood Page

A neighborhood landing page — the kind that lives on the agent's site as "/neighborhoods/east-nashville" — written to NYOA's Fair Housing rules and structured for both traditional SEO and AI-search visibility.

The standard real-estate-agent neighborhood page is a Fair Housing landmine waiting to happen: school rankings, "great for families", demographic descriptions. NYOA's version stays on geography, housing stock, market data, and amenities — the things that actually move a buyer and don't violate the FHA.

## When this skill triggers

- "Neighborhood page for [neighborhood]"
- "Build a landing page for [neighborhood]"
- "Neighborhood guide for my site"
- "SEO page for [neighborhood]"
- "Refresh my [neighborhood] page"
- Agent provides a neighborhood name + 5-10 facts and asks for a page

## Inputs you need

Required:
- **Neighborhood name** — the exact phrase the agent uses (e.g., "Lockeland Springs", "5 Points", "East Nashville").
- **Market** — the city / metro it sits inside (e.g., "Nashville").
- **5-10 facts about the neighborhood** — geography, housing stock, age/style of homes, lot sizes, walkability, transit, parks, coffee shops, local businesses, market data (median price, typical DOM). Concrete things, not adjectives.

Optional but improves output:
- Recent market data the agent has filed for this neighborhood — pulled from `nyoa-workspace/market-updates/` if available.
- Photo URLs the agent wants referenced in the page.
- Internal-link targets (other neighborhood pages, the buyer guide, the seller guide) — pulled from the agent's profile if filed.
- The CMS the agent uses (just for "paste-ready" formatting — Squarespace likes one format, Webflow another).

## Workflow

### Capability requirements

Read `nyoa-context/connectors.md`. If the agent has a stated preference for a capability, use the corresponding connector. If multiple connectors are available for a capability and no preference is set, ask which to use. If none are available, fall back to file-only behavior.

- **web-scrape** (`firecrawl` or equivalent): When available, NYOA offers to pull the agent's existing neighborhood page (if one exists at the given URL) so we can preserve internal links and the agent's existing structure. Falls back to writing the page from scratch.
- **docs** (`google-workspace` or `notion`): When available, NYOA offers to save the page to cloud storage alongside the workspace write-through.
- No other external capabilities required.

1. **Resolve the neighborhood and market.** Slug the neighborhood name. Check `nyoa-workspace/web/neighborhoods/<slug>.md` for any prior version.
2. **Read market data** if `nyoa-workspace/market-updates/` has recent files mentioning this neighborhood — pull a current data point for the FAQ section.
3. **Resolve voice.** Per-agent voice file → `nyoa-context/voice.md` → NYOA house style.
4. **Draft the page** in the structure below.
5. **Compliance pass** — Fair Housing is the dominant check for this skill.
6. **Write to workspace** and offer connector push.
7. **Deliver inline as Markdown.**

## Page structure

Single Markdown file with these elements, copy-paste ready into any CMS:

1. **Title** — `<NeighborhoodName>, <Market>: Homes, Market, and What to Know` — ≤ 60 characters.
2. **Meta description** — single sentence with the headline fact and the market data point — ≤ 155 characters.
3. **H1** — paraphrases the title, neighborhood-and-city explicit.
4. **Intro paragraph** — 100-150 words. Anchor with one geographic specific (which side of downtown, which streets bound it, what's adjacent) plus the headline market data point (median price as of YYYY-MM).
5. **Feature blocks (4-5)** — H2 written as a question or specific claim, then 80-120 words of plain language. Suggested H2s:
   - "Where exactly is [neighborhood]?" — geography, boundaries, commuting context.
   - "What kind of homes will you find?" — architectural styles, lot sizes, typical age/condition. No demographic claims.
   - "What's within walking distance?" — coffee, parks, transit, restaurants. Real walking distance, not aspirational.
   - "How does the market move here?" — recent price trend, typical DOM, list-to-sale ratio, sourced.
   - "What's a day in [neighborhood] actually like?" — streetscape, rhythm of the neighborhood (Saturday morning, Sunday evening). No demographic / "you'll fit in if…" framing.
6. **FAQ section (3 questions, schema-ready)** — each Q + A in 50-100 words, formatted so the agent can paste the agent's CMS's FAQPage schema block.
   - Common: "How much does a typical [neighborhood] home cost?"
   - Common: "What's the typical lot size?" or "What architectural style is most common?"
   - Common: "How often do homes come up for sale in [neighborhood]?"
7. **CTA block** — one paragraph + a soft form prompt. "Want to see what's available in [neighborhood] right now?" + contact form fields.
8. **Compliance footer** (verbatim, below).
9. **Suggested internal links** — 3 links to other agent pages (other neighborhood pages, buyer guide, seller guide) if the agent's profile lists them.
10. **(Optional) FAQ schema JSON-LD** — if the agent asks for it, generate a `<script type="application/ld+json">` block with the three FAQs in FAQPage schema. Pasteable into the page head.

## Compliance pass

Before delivering output, delegate to `/nyoa-compliance-review`:

1. Generate the draft per the rest of this skill's workflow.
2. Invoke `/nyoa-compliance-review` with the draft as input and this skill's name (`nyoa-neighborhood-page`) as the calling context.
3. If the review returns **APPROVED**, deliver the draft. `/nyoa-compliance-review` appends the disclaimer footer and writes the audit-log entry — do not duplicate.
4. If the review returns **FIX RECOMMENDED** or **FIX REQUIRED**, surface the findings to the user. Apply their chosen action:
   - **Apply all** — use the cleaned draft as the final output.
   - **Apply selected** — apply only the user-chosen fixes.
   - **Override** — capture the user's one-sentence reason; `/nyoa-compliance-review` logs it.
   - **Edit manually** — return the findings to the user and stop; they re-run the skill when ready.
   Then deliver.
5. If the agent's **own input** contained a fair-housing violation, surface it explicitly in your response in addition to letting `/nyoa-compliance-review` catch it.

Canonical rules and jurisdictional reasoning live in `plugins/nyoa/references/compliance/fair-housing.md` (loaded by `/nyoa-compliance-review`). Do not duplicate them here.

## Workspace integration

If `nyoa-workspace/web/neighborhoods/` exists (or scaffold it from `plugins/nyoa/assets/workspace-template/web/`):

- **Save the page** to `nyoa-workspace/web/neighborhoods/<slug>.md`. If a prior version exists, save the new one and back the old one up to `<slug>.bak.md` first.
- **Refresh `pipeline.md`** — note "Neighborhood page drafted: [name]" under content shipped.
- **Append to `tasks.md`** — a "review and publish neighborhood page for [name]" task with a 7-day target.

## Output format

Single Markdown response, structured to copy-paste into any CMS. End with: "Voice used: <agent name | NYOA house>. Saved to nyoa-workspace/web/neighborhoods/<slug>.md."

The disclaimer footer is appended automatically by `/nyoa-compliance-review` — do not include it in this skill's own output template.

## Shared context

Reads from `nyoa-context/`:
- `profile.md` — agent identity, market area, internal-link targets.
- `voice.md` — tone resolution.
- `connectors.md` — capability branching.

Reads from `nyoa-workspace/`:
- `web/neighborhoods/<slug>.md` — prior version if any.
- `market-updates/*.md` — recent neighborhood-level data points.

Writes to `nyoa-workspace/`:
- `web/neighborhoods/<slug>.md` — primary writer.
- `pipeline.md` — content-shipped note.
- `tasks.md` — review-and-publish task.

## Reference files

- `references/fair-housing-checklist.md` — the full red-flag list specific to neighborhood content, organized by violation type.
