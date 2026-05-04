# AEO Article QA Checklist

Run this verification on every article before delivery.

## Checks

### 1. Business Name Accuracy
- [ ] Business name appears exactly as specified in `nyoa-context/profile.md`
- [ ] No variations or typos in business name
- [ ] Business name appears in first paragraph

### 2. Voice Consistency
- [ ] Entire article is in third person
- [ ] No first-person language (I, we, our, us, my, I'm, we're, we've)
- [ ] Reads like an expert writing about the business, not the business writing about itself

### 3. Factual Accuracy
- [ ] No hallucinated facts (invented awards, years in business, team size, statistics)
- [ ] All claims match what's in `nyoa-context/profile.md` or are marked `[VERIFY FACT]`
- [ ] No invented testimonials (only quotes from `nyoa-context/proofs.md` or marked `[INSERT PROOF]`)

### 4. Testimonial Handling
- [ ] All testimonials are real (from `nyoa-context/proofs.md`)
- [ ] OR properly marked with `[INSERT PROOF]` or `[INSERT TESTIMONIAL]`
- [ ] Testimonials attributed correctly (name/source from proofs.md)

### 5. Competitor Facts (Head-to-Head only)
- [ ] Competitor info matches `nyoa-context/competitors.md`
- [ ] Any uncertain claims flagged with `[VERIFY FACT]`
- [ ] No negative or defamatory language about competitors
- [ ] Balanced treatment — competitors get fair credit

### 6. Structure Compliance
- [ ] Follows the correct structure for article type (see article-types.md)
- [ ] Appropriate length:
  - Best Choice: 800–1,200 words
  - Reasons to Choose: 500–800 words
  - Local Service: 400–700 words
  - Head-to-Head: 400–600 words
- [ ] CTA present at end (and only at end)

### 7. Title Format
- [ ] Best Choice: Natural question format
- [ ] Reasons to Choose: "Top Reasons to Choose [Business] for [Service]"
- [ ] Local Service: Question with location
- [ ] Head-to-Head: "Who's the Best [Service] in [City]? A Full Comparison"

### 8. Fair Housing Compliance
- [ ] No protected-class language ("great for families", "family neighborhood", etc.)
- [ ] No religious/ethnic references ("walk to church", "Christian community")
- [ ] "Primary bedroom" not "master bedroom"
- [ ] No unsourced structural claims

---

## QA Report Format

After checking, generate a report:

```
## QA Report: [Article Title]

**Article Type:** [Best Choice / Reasons to Choose / Local Service / Head-to-Head]
**Word Count:** [X]

### Checks Passed
- ✓ Business name accurate
- ✓ Third-person voice maintained
- ✓ Structure compliant
- ✓ Fair Housing compliant

### Issues Found
- ⚠️ [Issue description and location]

### Placeholders Remaining
- [INSERT PROOF] — paragraph 3 (needs testimonial about [topic])
- [VERIFY FACT] — competitor section (years in business for [competitor])

### Recommendation
[APPROVED / NEEDS REVISION]
```

---

## Common Issues and Fixes

| Issue | Fix |
|-------|-----|
| First-person slips | "We offer..." → "[Business Name] offers..." |
| Vague reasons | "Great customer service" → "Same-day response time with dedicated point of contact" |
| Missing proof | Add real testimonial from proofs.md OR `[INSERT PROOF]` placeholder |
| Competitor tone too negative | Reframe as "best suited for different client types" |
| Word count off | Too short: expand with specific details. Too long: trim redundant points |
| CTA scattered | Remove mid-article CTAs. Keep only the final CTA sentence |

---

## Pre-Publish Final Check

Before marking article as complete:

1. [ ] All placeholders replaced with real content OR clearly noted for user
2. [ ] Article saved to correct folder (`aeo-content/[type]/`)
3. [ ] Filename is URL-friendly slug
4. [ ] Meta description drafted (110–155 characters including business name)

### Meta Output Template

```
Meta Title: [Same as article title]
Meta Description: [110-155 char summary including business name and key value prop]
Suggested Slug: /aeo/[url-friendly-title]
```
