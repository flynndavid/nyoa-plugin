# Workflow: New Listing — Appointment to Live

Use this recipe when you've signed a listing agreement and are ready to get the property into market-ready shape in NYOA. Work through these steps in order — each one layers onto the next.

---

## Step 1 — Scaffold the listing folder

```
/nyoa-listing-add <address>
```

Provide: full address, listing price, property type (SFR / condo / townhouse / land / multi-family), bed/bath count, square footage, key features, your tentative go-live date, seller name (for internal cross-linking — not surfaced publicly), and any known challenges (deferred maintenance, estate sale, etc.).

NYOA will scaffold `nyoa-workspace/listings/<slug>/` with property, copy, comps, showings, offers, and photos files, then add the listing to the pipeline at "active — coming soon."

**After this step:** you have a single source of truth for every piece of content and every update on this listing.

---

## Step 2 — Build the listing presentation

```
/nyoa-listing-presentation <address>
```

Or: "build a listing presentation for <address>."

Provide your comps (paste the table or describe the comparables), suggested pricing strategy, and any marketing differentiators you want to lead with. NYOA reads the listing's `property.md` and your `nyoa-context/profile.md` to build a complete presentation deck outline — pricing rationale, marketing plan, seller timeline, and your value proposition.

**After this step:** you have a presentation-ready document saved to `listings/<slug>/copy.md` under a `## Listing Presentation` section.

---

## Step 3 — Generate all MLS and marketing copy

```
/nyoa-listing-copy <address>
```

Or: "write the MLS remarks for <address>."

NYOA reads `listings/<slug>/property.md` and your `nyoa-context/voice.md`, then generates:
- MLS remarks (within character limits)
- Long-form property description
- Social caption (Instagram / Facebook)
- Email blast body
- Short SMS teaser

Each asset is saved to `listings/<slug>/copy.md`. All copy passes a Fair Housing compliance check before delivery.

**After this step:** you can paste directly into your MLS system, email platform, and social scheduler without rewriting.

---

## Step 4 — Audit the live listing once published

```
/nyoa-listing-audit <listing URL>
```

Run this 1–2 days after the listing goes live. Provide the public URL (Zillow, Realtor.com, your brokerage site, or MLS portal link).

NYOA will evaluate: copy quality, photo count and order, price positioning vs. your comp set, online presence completeness, and Fair Housing compliance. It returns a scored audit with specific, actionable fixes — not vague advice.

**After this step:** you know exactly what to fix before the listing sits for more than a week.

---

## Step 5 — Confirm the listing on your pipeline

```
/nyoa-pipeline
```

Review the pipeline snapshot. Confirm the listing shows under "active" with the correct price and go-live date. Set the "next step" (first showing, open house, price review date). Update the last-activity stamp.

---

## Step 6 — Launch the social content series

```
/nyoa-social-content <address>
```

Or: "create social posts for <address> launch."

NYOA drafts a 3-post launch series — a coming-soon teaser, a just-listed announcement, and a feature-highlight deep dive. Each post is platform-appropriate (Instagram caption + hashtags, Facebook post, LinkedIn if applicable) and saved to `listings/<slug>/copy.md` under `## Social Content`.

**After this step:** queue the posts in your scheduler and you're done with launch content for the week.

---

**Next workflow:** if the listing sits more than 30 days without an offer, switch to the `listing-not-selling` workflow.
Run `/nyoa-help workflow listing-not-selling` to load it.

When you receive an offer, switch to the `under-contract` workflow.
Run `/nyoa-help workflow under-contract` to load it.

Voice used: NYOA house
