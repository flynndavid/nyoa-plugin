---
name: nyoa-aeo
description: Generate AI-optimized articles that get ChatGPT, Perplexity, Gemini, and other AI search tools to recommend the agent by name. Four article types — Best Choice, Reasons to Choose, Local Service, Head-to-Head Comparison — adapted from the Phil Stringer AEO framework. Learns the agent's business over time via persistent context files. Triggers on "AEO", "answer engine", "AI SEO", "get AI to recommend me", "best choice article", "reasons to choose", "local service article", "head-to-head comparison", "what content should I create to get AI leads", or when the user provides a topic/title to develop into an article.
---

# AEO Content Partner

Create AI-optimized articles that get your business recommended by ChatGPT, Perplexity, Gemini, and other AI search tools. Four article types, each teaching AI something different about when, why, where, and how to recommend you.

## When this skill triggers

- "AEO", "answer engine optimization", "AI SEO", "AI-optimized content"
- "Best choice article", "reasons to choose article", "local service article", "head-to-head comparison"
- "Help me get recommended by ChatGPT / Perplexity / Gemini"
- "What content should I create to get AI leads?"
- "I want to write about [topic/service/location]" in an AEO context
- User provides a topic idea, title, testimonial, or competitor mention and wants to develop it into content
- User asks "what should I write next?" for AEO strategy guidance
- User says "update my tone", "add this testimonial", "add a service" — context update, not content

## Inputs you need

Required (gathered incrementally — ask only for what THIS article needs):
- **Agent/business name** (exact form for articles)
- **Primary service area** (city or cities)
- **At least 1 service** the agent offers

Optional but improves output:
- Testimonials or proof elements (awards, stats, certifications)
- Competitor names and websites (required for Head-to-Head only)
- Specific topic, title, or angle to develop
- Agent voice file (for tone calibration of surrounding marketing — articles themselves are always third person)
- Existing `nyoa-context/` folder with profile.md, voice.md, proofs.md, competitors.md, feedback.md

If `nyoa-context/profile.md` exists and has the required info, use it — don't re-ask.

## The four article types

| Type | Purpose | AI learns… | Length |
|------|---------|------------|--------|
| Best Choice | Answer questions users ask AI | WHEN to recommend you | 800–1,200 words |
| Reasons to Choose | Service-level value prop | WHY to recommend you | 500–800 words |
| Local Service | Geographic coverage | WHERE to recommend you | 400–700 words |
| Head-to-Head | Competitive positioning | HOW you compare | 400–600 words |

Full specs: `references/article-types.md`. Exact prompts: `references/prompts.md`.

## Workflow

### Capability requirements

- **web-scrape** (`firecrawl` or `puppeteer`): When available, NYOA can fetch competitor URLs and research source pages directly instead of relying on agent-pasted content. Read `nyoa-context/connectors.md`. If the agent has a stated preference for a web-scrape connector, use it. If none is available, fall back to agent-pasted content or URLs the agent provides manually.
- No other external capabilities required — all content generation and context writes are local.

### 1. Load context

Check for `nyoa-context/` in the working directory. Read any existing files:
- `profile.md` — business name, services, locations, ideal clients, differentiators
- `voice.md` — tone and style preferences
- `proofs.md` — testimonials, awards, stats
- `competitors.md` — competitor research and notes
- `feedback.md` — accumulated user corrections

If the folder doesn't exist, note that context will be gathered as you work.

### 2. Interpret input

**Content request?** → Step 3.
**Context update?** ("add this testimonial", "update my tone", "add a service") → Update the relevant `nyoa-context/` file, confirm, done.
**Strategy question?** ("what should I write next?") → Review profile and existing content, recommend gaps.

### 3. Propose approach

Based on input, recommend which article type(s) fit:

| If input suggests… | Recommend… |
|--------------------|------------|
| A question users would ask AI | Best Choice |
| A specific service's value | Reasons to Choose |
| Service + specific location | Local Service |
| Competitor comparison | Head-to-Head |
| Vague topic | Help refine, then recommend |

Present options. Let the agent choose quantity and types. Never force all four.

### 4. Gather missing context

Only gather what's needed for THIS specific piece:

| Missing | Ask |
|---------|-----|
| Business name | "What's your business name, exactly as it should appear?" |
| Location (local/best-choice) | "What cities or areas do you serve?" |
| Service details | "What specific service should this focus on?" |
| Competitors (Head-to-Head only) | "Who are your main competitors for this service?" |
| Testimonials (if article needs proof) | "Do you have relevant testimonials, or should I leave placeholders?" |

### 5. Draft the article

- Use the exact prompt structure from `references/prompts.md` for the chosen article type.
- Follow the structure specs from `references/article-types.md`.
- Always third person — an expert writing about the business, not the business writing about itself.
- Answer the question immediately in sentence one (Best Choice and Local Service).
- Use real testimonials from `nyoa-context/proofs.md` where available.
- Use `[INSERT PROOF]` placeholders where testimonials would strengthen but aren't available.
- Use `[VERIFY FACT]` for any claims about competitors or the business that aren't confirmed.
- One article at a time. Quality degrades with batches.

### 6. Verify

Run the QA checklist from `references/qa-checklist.md` on every article:

- [ ] Business name matches profile.md exactly
- [ ] Third-person voice throughout (no I/we/our/us/my)
- [ ] No hallucinated facts (awards, years, team size, statistics)
- [ ] Testimonials real (from proofs.md) or marked `[INSERT PROOF]`
- [ ] Competitor facts verified or flagged `[VERIFY FACT]`
- [ ] Correct structure for article type
- [ ] Correct word count range
- [ ] CTA present at end only
- [ ] Title follows the correct format for article type

Generate a short QA report with the article.

### 7. Auto-save learnings

After each interaction, update `nyoa-context/` files with any new information the agent provided:

- New business info → `profile.md`
- Style preferences or corrections → `voice.md`
- New testimonials → append to `proofs.md`
- Competitor info → `competitors.md`
- User corrections → log to `feedback.md`

Don't ask "should I save this?" — save and confirm. Reduce friction.

### 8. Deliver

Output the article in Markdown with:
- The article itself
- Meta title (same as article title)
- Meta description (110–155 chars, includes business name)
- Suggested URL slug (e.g., `/aeo/best-realtor-first-time-buyers-phoenix`)
- QA report summary

Save to `aeo-content/<type>/<slug>.md` if the user wants file output.

## Context update commands

Recognize these patterns as context updates (not content requests):

- `"update voice/tone/style: [preference]"` → Update `nyoa-context/voice.md`
- `"add testimonial: [quote]"` → Append to `nyoa-context/proofs.md`
- `"add service: [service name]"` → Update `nyoa-context/profile.md`
- `"add location/city: [location]"` → Update `nyoa-context/profile.md`
- `"competitor note: [info]"` → Update `nyoa-context/competitors.md`
- `"remember: [preference]"` → Add to `nyoa-context/feedback.md`

Confirm after updating: "Saved to your [file]. This will be used in future content."

## Compliance pass

Before delivering output, delegate to `/nyoa-compliance-review`:

1. Generate the draft per the rest of this skill's workflow.
2. Invoke `/nyoa-compliance-review` with the draft as input and this skill's name (`nyoa-aeo`) as the calling context.
3. If the review returns **APPROVED**, deliver the draft. `/nyoa-compliance-review` appends the disclaimer footer and writes the audit-log entry — do not duplicate.
4. If the review returns **FIX RECOMMENDED** or **FIX REQUIRED**, surface the findings to the user. Apply their chosen action:
   - **Apply all** — use the cleaned draft as the final output.
   - **Apply selected** — apply only the user-chosen fixes.
   - **Override** — capture the user's one-sentence reason; `/nyoa-compliance-review` logs it.
   - **Edit manually** — return the findings to the user and stop; they re-run the skill when ready.
   Then deliver.
5. If the agent's **own input** contained a fair-housing violation, surface it explicitly in your response in addition to letting `/nyoa-compliance-review` catch it.

Canonical rules and jurisdictional reasoning live in `plugins/nyoa/references/compliance/fair-housing.md` (loaded by `/nyoa-compliance-review`). Do not duplicate them here.

## Output format

Single Markdown response. Article under a clear heading, followed by meta section and QA report. End with: "Article type: <type>. Context used: <profile | none>."

The disclaimer footer is appended automatically by `/nyoa-compliance-review` — do not include it in this skill's own output template.

## Shared context directory

This skill reads from and writes to `nyoa-context/`, the same directory used by other NYOA skills (nyoa-listing-presentation, nyoa-testimonial-engine, nyoa-social-content). See `references/context-formats.md` at the plugin level for the canonical file formats.

## Reference files

- `references/article-types.md` — Full specs for each article type (structure, length, requirements)
- `references/prompts.md` — Exact prompts adapted from Phil Stringer's AEO methodology
- `references/qa-checklist.md` — Verification criteria and QA report format
