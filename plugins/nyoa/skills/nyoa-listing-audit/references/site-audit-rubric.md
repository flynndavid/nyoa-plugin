# Site Audit Rubric (SEO + AEO)

The site-audit mode of `/nyoa-listing-audit` runs every page it can reach through this rubric. The output is a prioritized fix list ordered P0 / P1 / P2.

Two layered passes: **SEO** (traditional Google search) and **AEO** (AI-search / answer engines: ChatGPT search, Perplexity, Claude search, Google AI Overviews, Gemini). The two overlap on some checks (schema, structure) and diverge on others (heading style, paragraph structure).

## SEO checks (traditional Google)

### Meta titles

- Present on every page (P0 if missing)
- Length 50-60 characters (P1 if outside; P0 if over 70)
- Includes primary keyword
- Unique across the site (P0 if two pages share a title)
- Not generic ("Home", "About Us") — must be specific to the page

### Meta descriptions

- Present on every page (P1 if missing)
- Length 130-155 characters (P2 if outside)
- Includes a CTA or value statement
- Unique across the site

### H1 tag

- Exactly one per page (P0 if zero, P0 if multiple)
- Descriptive and keyword-relevant
- Distinct from the meta title (different angle on the same topic)

### H2 / H3 hierarchy

- Logical nesting (H3 inside H2, never H3 directly under H1)
- Scannable — major sections have H2s, sub-points have H3s
- Not used purely for visual styling

### Internal linking

- Key pages (homepage, neighborhood pages, buyer guide, seller guide, contact) cross-linked
- No orphan pages (pages with no internal links pointing to them)
- Anchor text descriptive (not "click here")

### Image optimization

- Lazy-loading attribute on below-fold images
- Alt text on every image, accurate and ≤ 125 chars
- File size reasonable (P2 if hero images exceed 500 KB)

### Mobile readability

- Viewport meta tag present
- Font size ≥ 16px for body
- Tap targets ≥ 44px (buttons, links in primary nav)

### Footer NAP

- Name, Address, Phone present and matches Google Business Profile
- Brokerage name present
- License number visible

## AEO checks (AI-search / answer engines)

### llms.txt

- Present at `/llms.txt` (P0 if missing)
- Structured per the emerging convention: H1 with the site name, blockquote summary, H2 sections for Agent / Service Area / Pages with markdown links
- If missing, the audit output generates a starter llms.txt the agent can copy to root

Example starter (for the audit to generate, substituting the agent's actual info):

```
# {{Agent or Brokerage Name}}

> {{One-sentence description of what this agent / brokerage does and the market served}}.

## Agent

{{Full name}}, REALTOR
License #{{license_number}}
Brokerage: {{brokerage_name}}

## Service Area

{{Primary market and any specific neighborhoods}}

## Pages

- [About](/about)
- [Listings](/listings)
- [Buyer Guide](/buyer-guide)
- [Seller Guide](/seller-guide)
- [FAQ](/faq)
- [Contact](/contact)
```

### Conversational headings

- H2 / H3 written as questions a human would actually ask, not brochure copy
- "What does a [city] REALTOR do?" beats "Our Services"
- "How much does a typical [neighborhood] home cost?" beats "Market Data"

### Citation-worthy paragraphs

- Every major claim has a specific data point, date, or named source nearby
- "Median home in [neighborhood] sold for $X in [month, year] per [source]" beats "Strong market"
- P0 if the homepage and About page have zero specific data points

### Direct-answer paragraphs

- Pages lead with the answer, then the explanation
- For a page titled "What does a REALTOR do?" — the first paragraph answers it. The rest expands.
- AI crawlers reward this structure (lifts the page into featured snippets and AI Overview citations)

### FAQ schema

- FAQ pages have `FAQPage` JSON-LD structured data
- Each Q has a question text and an answer text of 50-150 words
- The schema matches what's visible on the page (no schema-only "secret" answers)

### Real-estate schemas

- `RealEstateAgent` JSON-LD in the homepage head
- `LocalBusiness` JSON-LD in the footer
- `RealEstateListing` schema on every active listing page (if the site shows listings)
- `BreadcrumbList` on every page deeper than the homepage

### Trust signals

- License number visible
- Brokerage name visible
- Years of experience stated specifically (with a date, not "years")
- Geographic specificity — exact neighborhoods, not "the area"
- Citations to verifiable sources (named MLS, named association, named publications)

## Severity defaults

Default P0 if any of these is missing or broken:
- One H1 per page
- Meta title present and unique
- Schema for RealEstateAgent + LocalBusiness
- llms.txt at root
- Conversational H2s on the top 3 traffic pages

Default P1 if any of these is suboptimal:
- Meta descriptions on every page
- FAQ schema if FAQs exist
- Direct-answer paragraph structure
- Internal-link coverage

Default P2:
- Image lazy-loading
- File-size optimization
- Footer NAP consistency edge cases

The audit output gives an explicit priority for every fix so the agent can stack-rank.

## What the audit doesn't check

The skill audits **content + structure**, not **technical performance**. It does not measure Lighthouse score, Core Web Vitals, page load time, or rendering speed — those require running a live performance audit tool the agent can run separately (Google PageSpeed Insights, WebPageTest, Lighthouse CLI).

If the agent asks for performance audits explicitly, the skill says so: "Performance audits aren't in scope here — run [Lighthouse / PageSpeed Insights] for those. I can audit content + structure."

## Output structure

The site-audit output is one Markdown response with:

1. **Header** — site URL, primary market detected from the homepage, audit date.
2. **Summary** — count of P0 / P1 / P2 issues.
3. **Per-page findings** — for each page the audit reached, the issues found, tagged by severity.
4. **Prioritized fix list** — top 10 issues across the site, ordered by severity and impact.
5. **5-step implementation roadmap** — what to do this week, this month, this quarter. The agent picks the first 5; the audit picks the rest.
6. **What I'd do first** — 3-bullet summary so the agent can act in 2 minutes.

End with: "Voice used: NYOA house style (audit voice). Saved to nyoa-workspace/web/site-audit-YYYY-MM-DD.md." (Skip the save line if no workspace.)
