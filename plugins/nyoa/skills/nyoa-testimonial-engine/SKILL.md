---
name: nyoa-testimonial-engine
description: Collect, catalog, and repurpose client testimonials — ingest reviews from any source, save to the shared proof bank, and transform them into social posts, AEO proof elements, listing presentation quotes, and review-request messages. Use this skill when an agent says "I got a great review", "add this testimonial", "help me ask for reviews", "turn this review into a post", or "what testimonials do I have?" Triggers on testimonial ingestion, repurposing requests, review-request generation, or proof bank queries.
---

# Testimonial Engine

Collect, organize, and repurpose client testimonials into every NYOA skill that needs proof. This skill is the connective tissue — every testimonial added here makes AEO articles, listing presentations, and social content stronger.

## When this skill triggers

- "I got a great review" / "add this testimonial" / "here's what my client said"
- "Turn this review into a social post" / "repurpose my reviews"
- "Help me ask for reviews" / "write a review request"
- "What testimonials do I have?" / "show me my proof bank"
- User pastes a Google review, Zillow review, or client message
- "I need proof for my listing presentation / AEO article"

## Inputs you need

Required (for ingestion):
- **The testimonial text** — pasted, quoted, or paraphrased
- **Client name or initials**
- **Service type** — buying, selling, investing, relocation, first-time buyer, etc.

Optional but improves cataloging:
- Source (Google review, Zillow, video transcription, direct message, verbal — agent paraphrase)
- Specific property or transaction details
- Permission status (has the client agreed to be quoted by name?)
- What the agent wants to do with it (social post, AEO article, listing presentation, review request)

## Workflow

### Capability requirements

Read `nyoa-context/connectors.md`. If user has a stated preference for a capability, use the corresponding connector. If none is available, fall back to file-only behavior.

- **email** (`google-workspace` or `outlook`): When available, NYOA offers to push the review-request email directly to the agent's email client, pre-addressed to the past client. Always confirm before sending — never auto-send. Falls back to delivering the draft inline for the agent to send manually.
- No other external capabilities required — testimonial ingestion, cataloging, repurposing, and proof bank queries are all local.

### 1. Ingest and catalog

Accept the testimonial. Extract:
- Client name or initials
- Service type
- Key quote — the 1–2 sentences that are most compelling (pull-quote ready)
- Full text (if longer)
- Source
- Date (if known)
- Permission status (yes / pending / paraphrased)

Save to `nyoa-context/proofs.md` in the standard format from `references/context-formats.md`.

### 2. Tag for reuse

Identify which NYOA skills can use this testimonial:
- **AEO:** Tag by service type → can replace `[INSERT PROOF]` in Best Choice and Reasons to Choose articles
- **Listing presentation:** Tag as "seller proof" or "buyer proof" → "Why [Agent Name]" section
- **Social content:** Flag as "spotlight-ready" if compelling enough for a standalone post
- **Buyer-seller-comms:** Flag if useful as social proof in follow-up emails

### 3. Repurpose on demand

Based on what the agent requests:

**Social post:** Turn the testimonial into a narrative post (not just the quote with a stock caption). Tell the micro-story of the transaction, then land the quote. Format per the nyoa-social-content skill's platform specs (Instagram, X, Facebook, LinkedIn).

**AEO proof element:** Format for insertion into an AEO article — third person, attributed, with a context sentence. Example: "As one recent client shared: '[quote]' — [Client Name], [Source]"

**Listing presentation quote:** Format as a pull-quote with attribution for the "Why [Agent Name]" section. Short, punchy, relevant to the seller audience.

**Review-request message:** See step 4.

### 4. Review request generation

When the agent says "help me get more reviews":

**Post-close email** (`assets/templates/review-request-email.md`):
- Reference a specific memory from their transaction (not generic "thanks for your business")
- Include a direct link to the review platform (Google, Zillow — agent provides the link)
- One clear ask: leave a review
- ≤150 words

**Follow-up SMS** (`assets/templates/review-request-sms.md`):
- ≤320 chars
- Send if email goes unresponded after 5–7 days
- Casual, not pushy

**Timing:** Send 2–4 weeks post-close (same window as nyoa-buyer-seller-comms referral-ask, but separate message — don't combine the review request with the referral ask).

### 5. Proof bank query

When the agent asks "what testimonials do I have?" or "show me my proof bank":
- Read `nyoa-context/proofs.md`
- Present an inventory: how many testimonials, organized by service type, which have been used and where, which are spotlight-ready

### 6. Compliance pass

Scan every output for:
- **Never fabricate or embellish testimonials** — use exactly what the client said. Shortening is fine; changing meaning is not.
- **Fair Housing in client language** — if a client testimonial contains Fair Housing violations ("great family neighborhood", "walk to church"), flag them and suggest a redacted version for marketing use. The original stays in proofs.md; the marketing version strips the problematic language.
- **Permission status** — if the testimonial is marked "paraphrased" or "pending", include a note: "Verify with [client name] before publishing."
- **No incentivized reviews** — review requests must not offer incentives ("leave a review and I'll send you a gift card").
- **Attribution accuracy** — name/initials and source must match what's in proofs.md.

## Output format

**For ingestion:** Confirmation of what was saved, tags applied, and which skills can now use this testimonial.

**For repurposing:** The repurposed content in the requested format (social post, AEO proof, presentation quote).

**For review requests:** Email and SMS copy, ready to send.

**For inventory queries:** Organized table of testimonials by service type with status.

End with: "Saved to nyoa-context/proofs.md." (for ingestion) or "Voice used: <agent name | NYOA house>." (for repurposed content).

## How this connects to other skills

| Skill | What testimonial-engine feeds it |
|-------|--------------------------------|
| **AEO** | Proof elements replace `[INSERT PROOF]` placeholders in articles |
| **Listing presentation** | Seller testimonials power the "Why [Agent Name]" section |
| **Social content** | Spotlight-ready testimonials become standalone narrative posts |
| **Buyer-seller-comms** | Social proof quotes strengthen follow-up emails |

## Shared context

This skill is the **primary writer** for `nyoa-context/proofs.md`. All other skills read from it.

Also reads:
- `profile.md` — for agent name and service types when tagging
- `voice.md` — for tone when repurposing into social posts or emails

## Reference files

- `assets/templates/review-request-email.md` — post-close email requesting a Google/Zillow review
- `assets/templates/review-request-sms.md` — follow-up SMS for unresponded review requests
