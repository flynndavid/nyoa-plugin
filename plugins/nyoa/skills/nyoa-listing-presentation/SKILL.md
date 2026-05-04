---
name: nyoa-listing-presentation
description: Generate a complete seller listing presentation for a listing appointment — market narrative, comparable sales summary, pricing strategy, marketing plan, agent value proposition, and timeline. Use this skill when an agent is preparing for a listing appointment, needs a seller pitch, wants a pre-listing packet, or needs a CMA narrative. Triggers on "listing presentation", "listing appointment", "seller pitch", "pre-listing packet", "CMA narrative", "pricing strategy for [address]", "help me win this listing", or when the user provides an address and comps and asks for a presentation.
---

# Listing Presentation

Generate a complete, tailored listing presentation for a seller listing appointment. The agent who shows up with a presentation clearly specific to THIS property — backed by real comp data and a concrete marketing plan — wins the listing.

## When this skill triggers

- "Listing presentation for [address]"
- "I have a listing appointment" / "help me win this listing"
- "Seller pitch for [address]"
- "Pre-listing packet"
- "CMA narrative" / "pricing strategy for [address]"
- "Prepare for a listing appointment at [address]"
- User provides an address + comps and asks for a presentation or pricing analysis

## Inputs you need

Required:
- **Property address**
- **Approximate or target list price**
- **Agent name and brokerage**
- **3-5 comparable sales** — for each: address, sale price, days on market, and 1-2 key differences from the subject property (e.g., "smaller lot", "no pool", "updated kitchen")

Optional but improves output:
- Agent voice file (for the narrative tone)
- Agent bio or value proposition bullet points
- Agent's specific marketing plan for this property (or use NYOA defaults)
- Seller's known concerns or priorities (speed vs. price, specific terms, timeline)
- Neighborhood or market context the agent wants to emphasize
- Past seller testimonials (or pull from `nyoa-context/proofs.md`)
- Property features, year built, lot size, recent renovations

If comps are missing, **first check `nyoa-workspace/listings/<slug>/comps.md`** — if it has rows, use them and confirm with the agent. Then ask. Do **not** invent comparable sales data.

## Voice modes

Determine voice in this order:

1. **Per-agent voice file** — Look for `agents/<agent-name>/voice.md` or `voice.md` in the working directory. If present, match that voice for the narrative sections. Read it before drafting.
2. **NYOA house style** — fallback. Professional, confident, data-backed. No fluff or vague claims. Numbers speak; narrative contextualizes.

## Workflow

1. Confirm the inputs. If comps or required fields are missing, ask once and wait. Check `nyoa-workspace/listings/<slug>/comps.md` and `property.md` first to avoid asking for data the agent already filed.
2. Resolve voice mode.
3. Build the **comparable sales summary table** (`assets/templates/comp-table.md`).
4. Write the **market narrative** (`assets/templates/market-narrative.md`) — 2-3 paragraphs interpreting what the comps tell us about this market and this property's position.
5. Draft the **pricing strategy** (`assets/templates/pricing-strategy.md`) — recommended list price, price range, DOM expectation, strategic posture.
6. Generate the **marketing plan** (`assets/templates/marketing-plan.md`) — what the agent will do to market this listing. Reference nyoa-listing-copy as a concrete deliverable.
7. Write the **agent value proposition** (`assets/templates/agent-value-prop.md`) — 3-5 bullets on why this agent, backed by proof from `nyoa-context/proofs.md` if available.
8. Assemble the **full presentation** — structured Markdown with all sections in order.
9. Run the compliance pass.
10. Write through to the workspace (see Workspace integration below).
11. Deliver as a single Markdown response with each section independently copyable into Canva, Google Slides, or direct use.

## Compliance pass (mandatory before delivering)

Scan every output for:

- **Fair Housing red flags** — no neighborhood demographic claims ("family-friendly area", "great schools" without source, "diverse community", "quiet neighborhood"). Describe the neighborhood by amenities, proximity, and infrastructure — not by the people who live there.
- **"Master bedroom"** → replace with "primary bedroom".
- **Unsourced structural claims** — never write "fully renovated", "new roof", "completely updated" unless the agent confirmed it.
- **Pricing guarantees** — never guarantee a sale price or timeline. Use language like "based on recent comp activity, a competitive list price range would be…"
- **Comp accuracy** — never invent comparable sales. All comp data must come from the agent's input or `nyoa-workspace/listings/<slug>/comps.md`.

## Workspace integration

If `nyoa-workspace/listings/<slug>/` exists for the address:

- Save the full presentation Markdown to `nyoa-workspace/listings/<slug>/presentation-<YYYY-MM-DD>.md`. Don't overwrite previous presentations — date-stamp each one.
- Append a one-liner to `nyoa-workspace/listings/<slug>/copy.md` under `## Revision history`: "YYYY-MM-DD — listing presentation generated."
- If new comps were provided in the conversation, append them to `comps.md` (don't overwrite existing rows).
- Refresh `pipeline.md` last-activity date for the listing.

If the folder doesn't exist, ask: "Want me to create `listings/<slug>/` so this presentation, comps, and future copy live together?" Defer to `/nyoa-listing-add` if yes; skip silently if no.

## Output format

Single Markdown response with clear `##` headings for each section. Each section independently copyable. Sections in order:

1. **Cover** — property address, agent name / brokerage, date
2. **Market Narrative** — 2-3 paragraphs interpreting current market conditions for this property's neighborhood and price tier
3. **Comparable Sales** — table with address, sale price, DOM, key differences, and how each comp supports the pricing recommendation
4. **Pricing Strategy** — recommended list price, price range, DOM expectation, strategic rationale
5. **Marketing Plan** — bullet-point outline of what the agent will do (photography, NYOA copy package, social campaigns, email blast, open house, syndication)
6. **Why [Agent Name]** — 3-5 proof-backed reasons to choose this agent (pull from `nyoa-context/proofs.md` if available)
7. **Timeline & Next Steps** — what happens after the seller signs (photography day, listing live date, first open house, first showing feedback report)

End with: "Voice used: <agent name | NYOA house>." If workspace write-through ran, also confirm: "Saved to nyoa-workspace/listings/<slug>/presentation-<YYYY-MM-DD>.md."

## Shared context

This skill reads from `nyoa-context/`:
- `proofs.md` — for the "Why [Agent Name]" section (testimonials, awards, stats)
- `profile.md` — for agent differentiators and service descriptions
- `voice.md` — for tone preferences in narrative sections

And from `nyoa-workspace/` (when present):
- `listings/<slug>/property.md` — property facts to avoid re-asking
- `listings/<slug>/comps.md` — pre-filed comps

## Reference files

- `assets/templates/comp-table.md` — comparable sales table format
- `assets/templates/market-narrative.md` — market narrative structure
- `assets/templates/pricing-strategy.md` — pricing recommendation format
- `assets/templates/marketing-plan.md` — marketing plan outline
- `assets/templates/agent-value-prop.md` — agent value proposition format
