# Fair Housing & Advertising Compliance — Canonical Reference

This is the single source of truth for fair-housing and real-estate advertising compliance across NYOA. The `/nyoa-compliance-review` skill loads this file on every run. All other generative skills delegate compliance to that skill rather than duplicating these rules.

---

## Federal floor — Fair Housing Act

The federal Fair Housing Act (FHA) protects seven classes from discrimination in the sale, rental, and advertising of housing:

1. **Race**
2. **Color**
3. **Religion**
4. **National origin**
5. **Sex** (including, per current HUD guidance, sexual orientation and gender identity)
6. **Familial status** (presence of children under 18; pregnant women; people securing custody)
7. **Disability**

Advertising that "indicates any preference, limitation, or discrimination" based on these classes — or that would lead an ordinary reader to a discriminatory inference — is prohibited under 42 U.S.C. § 3604(c). HUD enforces this against listing copy, social ads, digital ads (including platform-level targeting filters), flyers, and any other marketing media.

### 55+ housing exception (HOPA)

The Housing for Older Persons Act creates a narrow exception for senior housing. To qualify:

- At least one occupant aged 55 or older per unit, and
- At least 80% of occupied units have one such occupant, and
- The community publishes and consistently applies an age-restriction policy.

Only communities that meet all three criteria may target the 55+ demographic in advertising. For all other housing, age-targeted language is prohibited.

### HUD restrictions on demographic-targeting in advertising

- Digital ad targeting on protected-class proxies (zip codes selected for racial composition, "lookalike" audiences derived from protected-class data, etc.) violates the FHA. Meta settled a federal case on this in 2022 and now restricts housing-category ad targeting.
- Demographic stock photography that signals preference (only one race shown, only one family type, etc.) is treated as advertising signal under HUD guidance — use diverse imagery or no people at all.
- Geographic descriptors that act as protected-class proxies (e.g. "quiet [ethnic] neighborhood") are treated the same as direct claims.

---

**Instruction to Claude:** Apply your knowledge of fair-housing and real-estate advertising rules for the agent's `license_state` (read from `nyoa-context/profile.md`). State-level rules vary — many states protect additional classes beyond the federal seven (e.g. source of income, sexual orientation, gender identity, marital status, age, ancestry). Apply those state-specific rules. If `nar_member: yes`, also apply NAR Code of Ethics Articles 10 (no discrimination) and 12 (truth in advertising). Apply current FTC guidance on AI-generated advertising. Catch paraphrases, not just exact-string matches. When uncertain, surface the uncertainty as a FIX RECOMMENDED finding rather than silently approving.

---

## Illustrative examples (not exhaustive)

These phrases tank a listing under the FHA federal floor — and most state extensions go further. Strip them whenever they appear in agent input, and never generate them yourself. This list is illustrative; Claude must catch paraphrases the same way.

- **"Great for families"** / **"perfect for kids"** / **"family neighborhood"** / **"growing family"** — familial status preference.
- **"Walk to church / synagogue / mosque"** — religion preference. Replace with a secular landmark or the street name: "walk to [main street]".
- **"Christian community"** / **"Jewish community"** / **"Muslim community"** — religion preference. Any ethnic / religious / national-origin neighborhood claim falls under this rule.
- **"Bachelor pad"** / **"perfect for newlyweds"** / **"couples retreat"** — sex / familial status preference.
- **"Exclusive"** when paired with anything that implies a protected class — sex, race, religion, national origin, etc.
- **"Great schools"** without a sourceable claim — replace with "in [district name] district" only if verifiable and stated. Unsourced school-quality language is a familial-status proxy and an FTC-deception risk.
- **"Quiet [ethnic] neighborhood"** / **"safe neighborhood"** / **"good area"** — race / national-origin proxies. Be specific about what the agent means (low-traffic street, walkable, etc.) without the demographic shorthand.
- **"Handicap accessible"** — replace with specific ADA-aligned features ("single-level", "step-free entry", "wide doorways", "roll-in shower", "first-floor primary bedroom").
- **"Mature buyers"** / **"empty-nesters"** — age / familial status. Describe the home, not the buyer.

---

## Always-replace rules

These apply to every output regardless of channel, jurisdiction, or voice mode.

- **"Master bedroom"** → **"primary bedroom"**. NAR's official guidance since 2020; most MLSs require it; copy that still uses "master" reads dated even where not formally prohibited.
- **"Master bath"** → **"primary bath"**.
- **No unsourced structural claims.** Never assert "fully renovated", "new roof", "new HVAC", "new electrical", "new plumbing", "completely updated", "down to the studs" unless the agent has confirmed it. If unconfirmed, soften ("recently refreshed kitchen") or pull entirely. FTC truth-in-advertising and NAR Article 12 both apply.
- **No invented facts.** Awards, years in business, team size, stats, transaction counts, and testimonials must be real and sourceable. Use `[VERIFY FACT]` for uncertain claims and `[INSERT PROOF]` for needed-but-missing testimonials — these placeholders are the agent's cue to fill in or pull the claim.
- **No clichés.** Strip "stunning", "must see", "nestled", "boasts", "rare opportunity", "luxury living awaits", "don't miss", "won't last". Replace with concrete specifics (what stuns? what kind of luxury?). Clichés don't sell and dilute compliance-cleaner copy.

---

## Where this rulebook lives in the skill graph

- The canonical version is this file. Update it here when rules change.
- `/nyoa-compliance-review` loads this file on every run.
- All generative skills (`/nyoa-listing-copy`, `/nyoa-social-content`, `/nyoa-buyer-seller-comms`, `/nyoa-neighborhood-page`, `/nyoa-aeo`, `/nyoa-market-update`, `/nyoa-open-house`, `/nyoa-listing-presentation`, `/nyoa-testimonial-engine`, etc.) delegate to `/nyoa-compliance-review` and do **not** maintain duplicate rule lists.
- The legacy red-flag list in `nyoa-listing-copy/references/voice-presets.md` is preserved for context but is no longer canonical — see the note at the top of that file.
