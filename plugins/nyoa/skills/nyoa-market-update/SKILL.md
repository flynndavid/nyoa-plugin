---
name: nyoa-market-update
description: Generate the agent's monthly market-update piece in three matched formats — blog post, Instagram caption, and email newsletter — from a small set of MLS numbers the agent provides. Reads the agent's market and voice from context, writes the canonical piece to nyoa-workspace/market-updates/ so next month's piece can reference last month's narrative. Use this skill in the first week of the month, after MLS data publishes, or whenever the agent asks for a market commentary post. Triggers on "monthly market update", "market update post", "monthly stats post", "market commentary for [month]", "blog + IG + email for the market update", "April numbers are out".
---

# Market Update

The recurring piece every serious agent does — a take on this month's local market data, translated into plain English. The skill produces three matched formats (blog, IG, email) from one input so the agent says the same thing across channels without rewriting it three times.

Builds compounding value: each month's piece is filed in `nyoa-workspace/market-updates/`, so the next month's piece can reference the prior narrative ("last month I said speed was winning — here's where that landed").

## When this skill triggers

- "Monthly market update"
- "Market update post for [month]"
- "Numbers are out, draft my market piece"
- "Market commentary"
- "Blog + IG + email for this month's stats"
- "April / May / June numbers are in, write the post"

## Inputs you need

Required (the agent supplies these from their local MLS or association):
- **Month and year** the data covers
- **Market name** (city / metro / neighborhood the agent reports on)
- **Median sale price** + month-over-month and year-over-year change
- **Days on market** + YoY change
- **Months of inventory**
- **List-to-sale ratio**
- **Total closed sales** + YoY change
- **Source citation** — the MLS, association, or report name + URL if there is one

Optional but improves output:
- Any subsegment the agent wants to call out (single-family vs. condo, a specific price band, a specific zip)
- A neighborhood-level data point the agent wants to layer in
- The agent's read — one or two sentences of opinion on what the numbers mean (we'll respect it as their thesis instead of inventing one)
- Last month's saved post in `nyoa-workspace/market-updates/` (we read this automatically for narrative continuity)

If the agent provides only a subset of the required numbers, draft with what's there and flag the missing fields in the output rather than fabricating.

## Workflow

### Capability requirements

Read `nyoa-context/connectors.md`. If the agent has a stated preference for a capability, use the corresponding connector. If multiple connectors are available for a capability and no preference is set, ask which to use. If none are available, fall back to file-only behavior.

- **email** (`google-workspace` or `outlook`): When available, NYOA offers to push the email-newsletter version as a draft to the agent's email client with their saved subscriber audience. Always confirm before sending — never auto-send. Falls back to delivering the email inline.
- **docs** (`google-workspace` or `notion`): When available, NYOA offers to also save the full three-format package to cloud storage alongside the local workspace write-through.
- No other external capabilities required — drafting itself is local.

1. **Resolve market + voice.** Read `nyoa-context/profile.md` for the market name if not given. Resolve voice: per-agent file → `nyoa-context/voice.md` → NYOA house style.
2. **Read prior month** if `nyoa-workspace/market-updates/` has a prior file. Pull the prior month's thesis sentence so this month's piece can reference it ("Last month I said X — here's where the data landed").
3. **Build a small numbers grid** the agent can scan: each stat with its MoM and YoY direction arrows, plus a one-line plain-English translation.
4. **Decide the thesis.** If the agent gave one, honor it. If not, derive one from the numbers — the single sentence that ties the data together. The thesis is the same across all three channels.
5. **Draft the three formats** from the templates:
   - `assets/templates/blog-post.md` — 400-500 words, SEO-shaped headings.
   - `assets/templates/instagram-caption.md` — ≤ 200 words + 12-15 hashtags.
   - `assets/templates/email-newsletter.md` — 300-400 words.
6. **Compliance pass.**
7. **Write to workspace.**
8. **Deliver.**

## Compliance pass (mandatory before delivering)

- **Source every number.** Each stat in the blog and email versions cites the source by name. The IG version cites once at the bottom. Never publish numbers without attribution.
- **No forecasting.** Don't project where prices will be next month / quarter / year. Use language like "if the trend holds" or "the pattern over the last three months has been". Avoid "prices will" / "the market will".
- **No demographic neighborhood claims.** No "this market is great for first-time buyers" — say "homes under $X moved fastest" instead.
- **No school quality claims.** Don't characterize a market by school ranking.
- **Clichés to strip.** "Stunning", "must see", "in today's market", "as we navigate", "balanced market" (without a definition), "now is the time to" (used as a sales nudge).
- **YoY honesty.** If the YoY is meaningfully different from MoM, call that out. Don't cherry-pick the friendlier direction.

Footer to include on the blog and email versions (verbatim):

> All numbers in this post are pulled from {{source_name}} for {{period}}. Real-time reporting may differ — check the source before quoting any figure. Nothing here is a price prediction; the past is description, not promise.

## Workspace integration

If `nyoa-workspace/market-updates/` exists (or scaffold it from `plugins/nyoa/assets/workspace-template/market-updates/`):

- **Save the combined piece** to `nyoa-workspace/market-updates/YYYY-MM.md` (one file per month). The file contains all three formats in order: blog, IG, email — plus a header block with the inputs used.
- **Don't overwrite.** If the file exists (agent re-running with corrected data), back up to `YYYY-MM.bak.md` first, then write the new version.
- **Refresh `pipeline.md`** — bump the agent's "last content shipped" line if it exists; otherwise no-op.
- **Append a one-liner** to the current week's section in `calendar.md`: `- Market update post drafted (YYYY-MM)`.

## Output format

Single Markdown response with these sections, each independently copyable:

1. **Header** — month, market, source. Single thesis sentence.
2. **Numbers grid** — table of each stat + MoM + YoY + one-line plain-English read.
3. **Blog post** — full piece. Title (≤ 60 chars), meta description (≤ 155 chars), H1, 3-4 H2s, body, source citation, takeaways-for-buyers + takeaways-for-sellers, soft CTA. Compliance footer.
4. **Instagram caption** — full caption + 12-15 hashtags.
5. **Email newsletter** — subject, preview text, body, link slot to the blog post, signature block. Compliance footer.
6. **Connector offers** — only if applicable.

End with: "Voice used: <agent name | NYOA house>. Saved to nyoa-workspace/market-updates/YYYY-MM.md." (Skip the save line if no workspace.)

## Shared context

Reads from `nyoa-context/`:
- `profile.md` — market name, agent identity.
- `voice.md` — tone resolution.
- `connectors.md` — connector branch.

Reads from `nyoa-workspace/`:
- `market-updates/<prior-YYYY-MM>.md` — to reference prior thesis.
- `calendar.md` — to slot the drafting entry.

Writes to `nyoa-workspace/`:
- `market-updates/YYYY-MM.md` — primary writer.
- `calendar.md` — append.

## Reference files

- `assets/templates/blog-post.md` — blog version structure.
- `assets/templates/instagram-caption.md` — IG version structure.
- `assets/templates/email-newsletter.md` — email version structure.
