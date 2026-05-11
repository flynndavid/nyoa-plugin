---
name: nyoa-social-content
description: Generate a week of social media content for a real estate agent — market commentary, neighborhood spotlights, buyer/seller tips, behind-the-scenes stories, engagement posts, and testimonial features. Not tied to a specific listing. Use this skill when an agent wants ongoing social content, a content calendar, personal brand posts, or asks "what should I post this week?" Triggers on "social content", "content calendar", "what should I post", "social media plan", "help me build my brand on social", or when the agent needs content between listings.
---

# Social Content Engine

Generate a week of social content that builds the agent's personal brand, local expertise, and sphere awareness — independent of any specific listing. The nyoa-listing-copy skill handles per-listing posts; this skill fills the days in between.

## When this skill triggers

- "Social content for this week" / "what should I post?"
- "Content calendar" / "social media plan"
- "Write a market update post" / "neighborhood spotlight" / "buyer tip"
- "I need content but I don't have a listing right now"
- "Help me build my personal brand on social"
- "Give me 5 posts for this week"

### Instagram-specific modes (new in v0.7.0)

The base skill produces a multi-platform weekly mix. These modes go deeper on Instagram specifically — see `references/instagram-playbook.md` for the patterns each mode uses.

- **`monday-planner`** — full week's IG plan (5 feed posts across content pillars + 1 Reel concept + 2 Stories prompts) drawn from the agent's upcoming week. Triggers on "Monday planner", "this week's IG plan", "weekly Instagram plan".
- **`welcome-dms`** — 5 distinct DM variations the agent can rotate when greeting new followers. Triggers on "welcome DMs", "new follower DMs", "greet my new followers".
- **`info-replies`** — for a new listing post collecting "info" comments: 3 brief public-comment-reply variations + a clean DM script that delivers the listing details and a soft qualifying question. Triggers on "info comment replies", "info comments on my listing post".
- **`engagement-reset`** — diagnostic: read the last 30 days of post performance, identify what's dragging reach, output a 7-day reset plan. Triggers on "engagement is down", "reach reset", "algorithm reset", "engagement diagnostic".
- **`hashtag-audit`** — evaluate the agent's current hashtag set, label each tag (branded / location / niche / broad / oversized / undersized / stale), recommend a refreshed mix. Triggers on "hashtag audit", "review my hashtags", "refresh my hashtag set".
- **`just-sold`** — from a single set of sale details, produce four matched outputs: IG caption, 3-frame Stories sequence, 15-30s Reel script, longer Facebook post. Triggers on "just sold post", "just sold multi-output", "we closed — post it".

## Inputs you need

Required:
- **Agent name and market area**
- **Platform(s):** Instagram, X, Facebook, LinkedIn, or "all"

Optional but improves output:
- Agent voice file (critical — personal brand content must sound like the agent, not generic)
- Specific topic or angle the agent wants to cover
- Recent market data or news the agent wants to riff on
- Content the agent has already posted recently (to avoid repetition)
- Agent's specialties or niches (luxury, first-time buyers, investors, etc.)
- `nyoa-context/profile.md` (services, differentiators)
- `nyoa-context/proofs.md` (testimonials for spotlight posts)
- `nyoa-workspace/reviews/` (last week's review — surface a win or learning)
- `nyoa-workspace/listings/*/property.md` (active listings — feed neighborhood spotlight posts)

## Voice modes

Determine voice in this order:

1. **Per-agent voice file** — if present, match that voice exactly. Personal brand content is where voice matters most.
2. **NYOA house style** — fallback. Warm, specific, confident. No clichés. No template-speak. Sounds like a real person with opinions, not a content mill.

## Content types

For a week of content (5 posts default), select from these categories. No more than 2 of the same type per week:

| Type | What it is | Example |
|------|-----------|---------|
| **Market Commentary** | One data point + one opinion. Not a textbook report. | "12 homes closed in Germantown last month. Average DOM: 9 days. If you're thinking about selling in this zip code, you have leverage right now." |
| **Neighborhood Spotlight** | Specific block, street, park, coffee shop, restaurant. Hyper-local. | "Shelby Park at 6am before anyone else is there. This is why people move to East Nashville." |
| **Buyer Education** | One concrete tip the agent actually tells their buyers. Not "get pre-approved." | "The inspection report is not a wish list. Pick 3 things that matter for safety or structure. Let the rest go." |
| **Seller Education** | One concrete tip from actual listing experience. | "The first photo in your listing is the only one most people see. If it's the front of your house on a cloudy day, you've already lost them." |
| **Behind the Scenes** | What happened this week. A showing story, negotiation moment (anonymized), lesson learned. | "Wrote an offer at 9pm last night. Seller countered by 6am. Had it under contract before my coffee. This market doesn't sleep." |
| **Engagement / Question** | A question that invites replies. | "What's the one thing you wish you'd known before buying your first home?" |
| **Testimonial Spotlight** | Turn a client review into a narrative post. | "[Story of the transaction] — then Sarah left this review: '[short quote]'. That's why I do this." |

## Workflow

### Capability requirements

This skill generates copy for social platforms; the agent handles publishing manually. No external capabilities are required — all content generation and workspace writes are local.

- No connectors used — output is always inline text in a content calendar format, ready for the agent to paste into their platform of choice.
- Reading `nyoa-context/connectors.md` is not required for this skill, though the skill may read it if checking for other context.

1. Read voice file and/or `nyoa-context/profile.md` if available. Understand the agent's niche, market, and tone.
2. (Optional) Read `nyoa-workspace/reviews/` for recent wins/learnings to source Behind-the-Scenes posts; read `nyoa-workspace/listings/*/property.md` for an active listing to source a Neighborhood Spotlight.
3. Select the content mix — 5 posts from different categories. No more than 2 of the same type.
4. Draft each post with per-platform formatting (see Platform specs below).
5. Run the compliance pass on every post.
6. Write through to the workspace (see Workspace integration below).
7. Deliver as a content calendar: Day 1–5, each with platform, post type, and the actual copy.

## Platform specs

### Instagram (80–180 words)
- Line-break cadence (short paragraphs, visual breathing room)
- 3–5 hashtags: 2 local (#NashvilleRealEstate, #EastNashville), 2 category (#FirstTimeBuyer, #HomeBuyingTips), 1 brand (#NYOA or agent-specific)
- 0–2 emojis max (unless agent's voice file uses more)
- Hook in first line (this is what shows before "...more")

### X / Twitter (280 chars max)
- Concrete hook + one anchor number or fact + CTA or opinion
- No hashtags unless agent specifically requests them
- No emojis unless agent's voice file uses them

### Facebook (100–250 words)
- More conversational, slightly longer
- 0–1 hashtags
- Can ask questions and invite comments

### LinkedIn (150–300 words)
- Professional but personal
- No hashtags
- Can be slightly longer and more reflective
- Good for market commentary and behind-the-scenes

## Compliance pass (mandatory before delivering)

Scan every post for:

- **Fair Housing red flags** — no neighborhood demographic claims. "Great schools" only with district name and verifiable source. No "family-friendly area", "diverse community", "up-and-coming neighborhood" (gentrification implication).
- **Market data accuracy** — every number must be verifiable or explicitly framed as the agent's observation. "I've seen X" is fine. Invented statistics are not.
- **Anonymization** — behind-the-scenes stories must not include client names, identifying property details (if deal is active), or any information the client hasn't consented to share.
- **Testimonial permission** — testimonial spotlight posts require the agent to confirm they have permission to share. Flag this: "Confirm you have [client name]'s permission to share this publicly."
- **Cliché ban** — same list as nyoa-listing-copy. No "stunning", "nestled", "dream home", "don't miss". Replace with specifics.

## Workspace integration

If `nyoa-workspace/` exists, save the calendar to `nyoa-workspace/social/<YYYY-MM-DD>-week.md` (creating the `social/` folder if absent). Don't overwrite — date-stamp each week's calendar. If a specific post references an active listing, also append a one-liner to that listing's `copy.md` revision history.

If no workspace, skip silently. The inline calendar response is the deliverable.

## Output format

Single Markdown response structured as a content calendar:

```
## Week of [Date Range]

### Day 1 — [Day of Week]
**Platform:** Instagram
**Type:** Market Commentary
**Post:**
[The actual post copy, ready to paste]

### Day 2 — [Day of Week]
**Platform:** X
**Type:** Buyer Education
**Post:**
[The actual post copy]

[Continue for 5 posts]
```

End with: "Voice used: <agent name | NYOA house>." If workspace write-through ran, also confirm: "Saved to nyoa-workspace/social/<YYYY-MM-DD>-week.md."

## Shared context

This skill reads from `nyoa-context/`:
- `profile.md` — agent specialties, market area, differentiators
- `voice.md` — tone and style preferences
- `proofs.md` — testimonials for spotlight posts

And from `nyoa-workspace/` (when present):
- `reviews/` — recent wins/learnings for behind-the-scenes posts
- `listings/*/property.md` — active listings for neighborhood spotlights

## Reference files

- `references/content-types.md` — detailed specs for each content type with examples.
- `references/instagram-playbook.md` — the six Instagram-specific modes (monday-planner, welcome-dms, info-replies, engagement-reset, hashtag-audit, just-sold) with structure, examples, and compliance notes for each.
