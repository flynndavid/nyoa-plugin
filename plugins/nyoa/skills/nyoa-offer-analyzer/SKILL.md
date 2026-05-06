---
name: nyoa-offer-analyzer
description: Analyze a real estate purchase offer or counter-offer — extract key terms from contract text, translate to plain English, score strengths and weaknesses, compare multiple offers side-by-side, and draft counter-offer talking points. Use this skill when an agent pastes contract text or offer terms, says "analyze this offer", "break down this contract", "compare these offers", "what does this mean", or needs to translate legal contract language into a seller-ready briefing.
---

# Offer Analyzer

Turn raw contract language into a plain-English briefing. Extract key terms, calculate the math, score strengths and weaknesses, and deliver a seller-ready summary — with optional multi-offer comparison and counter-offer talking points.

## When this skill triggers

- User pastes contract text, purchase agreement, or offer terms
- "Analyze this offer" / "break down this contract" / "explain this offer"
- "What does this offer mean?"
- "Compare these two (or three) offers"
- "Draft a counter based on this offer"
- User provides offer details and asks for a summary, comparison, or recommendation

## Inputs you need

Required:
- **The offer** — pasted contract text or structured terms (at minimum: price, financing type, earnest money, closing date, contingencies)
- **Listing address and list price** (for context — offer vs. list price calculation)

Optional but improves output:
- Agent's recommendation posture (lean accept / lean counter / lean reject)
- Seller's priorities (speed, price, certainty, specific terms)
- Additional offers to compare (multi-offer mode)
- Voice file (for the tone of seller-facing summaries)
- Comp data or market context (to contextualize the offer price)

If the offer text is incomplete, ask what's missing. Do **not** invent terms.

## Workflow

### Capability requirements

Read `nyoa-context/connectors.md`. If user has a stated preference for a capability, use the corresponding connector. If multiple connectors are available and no preference is set, ask which to use. If none are available, fall back to file-only behavior.

- **email** (`google-workspace` or `outlook`): When available, NYOA offers to push the plain-English offer summary to the agent's email client for delivery to the seller. Always confirm before sending — never auto-send. Falls back to delivering the draft inline.
- **docs** (`google-workspace` or `notion`): When available, NYOA offers to save the offer analysis to a shared Drive folder or Notion page so the seller can review it. Falls back to inline Markdown for the agent to share manually.
- No other external capabilities required — all term extraction, math, and analysis are local.

### 1. Extract key terms

Parse the offer text and extract:
- **Price** — offer amount
- **Financing** — cash, conventional, FHA, VA, other
- **Earnest money** — amount and deposit timeline
- **Closing date** — target date and days from today
- **Contingencies** — inspection (+ duration), financing, appraisal, sale of buyer's home, other
- **Inclusions / exclusions** — appliances, fixtures, personal property
- **Concessions / credits** — seller-paid closing costs, repair credits
- **Special terms** — escalation clauses, rent-back, as-is, other
- **Response deadline** — when the seller must respond

### 2. Calculate the math

- Offer vs. list price ($ difference and %)
- Earnest money as % of offer (flag if below typical 1–2%)
- Days to close from today
- Estimated net to seller (if enough data — subtract concessions, estimated commissions, known costs)
- Number of contingencies and total contingency days

### 3. Analyze strengths and weaknesses

Identify 2–4 strengths and 2–4 weaknesses of the offer. Use plain language.

**Strength indicators:** strong earnest money, minimal contingencies, quick close, cash or conventional financing, escalation clause, no sale contingency, above-ask price.

**Weakness indicators:** sale contingency, below-market earnest, unusually long inspection period, FHA/VA in competitive market (appraisal risk), excessive concession requests, distant close date, multiple contingencies stacked.

### 4. Generate the plain-English summary

Use `assets/templates/offer-summary.md` — structured for a seller audience:
- Headline numbers (price, earnest, close, financing)
- What's included / excluded / credited
- Contingencies (each with 1-line plain-English explanation)
- Strengths and weaknesses (2–4 bullets each)
- Recommendation paragraph
- Next step and response deadline

### 5. Multi-offer comparison (if applicable)

If the agent provides multiple offers, generate `assets/templates/offer-comparison.md`:
- Side-by-side table: price, financing, earnest, close date, contingency count, concessions, net-to-seller estimate
- Ranked by the seller's stated priorities (or by overall strength if no priorities stated)
- Brief narrative comparing the top 2 offers

### 6. Counter-offer talking points (if requested)

If the agent asks for a counter:
- Draft specific counter terms with rationale for each change
- Reference comp data if provided ("counter at $619K — the 312 Maple comp closed at $612K and our kitchen is stronger")
- Suggest which terms to counter on vs. which to accept
- Output as talking points, not legal language

### 7. Compliance pass

Scan every output for:
- **Legal disclaimer** — always include: "This summary is for informational purposes. It is not legal advice. Consult your attorney before making binding decisions."
- **Fair Housing** — never evaluate offers based on the identity or perceived identity of the buyer. Evaluate only on terms.
- **No invented terms** — never assert contract terms not present in the source text. If something is ambiguous, flag it: "This clause is unclear — verify with your broker."
- **No unauthorized legal advice** — frame as analysis and summary, never as legal counsel. Use "consider" and "may want to" rather than "you should" or "you must."
- **Response deadline** — always state the response deadline prominently if one exists in the offer.

## Output format

Single Markdown response with clear `##` headings:

1. **Offer Summary** — headline numbers + plain-English breakdown
2. **Key Terms Extracted** — structured list of all parsed terms
3. **Strengths** — 2–4 bullets
4. **Weaknesses** — 2–4 bullets
5. **Recommendation** — 1 paragraph, balanced
6. **Multi-Offer Comparison** — table + narrative (only if multiple offers)
7. **Counter-Offer Talking Points** — (only if requested)
8. **Disclaimer** — legal disclaimer

Pair email + voicemail for delivery of offer summaries to sellers (per the channel conventions from nyoa-buyer-seller-comms).

End with: "Voice used: <agent name | NYOA house>."

## How this connects to nyoa-buyer-seller-comms

This skill extends the `offer-summary` and `counter-offer-draft` templates in nyoa-buyer-seller-comms. The difference: nyoa-buyer-seller-comms requires the agent to manually extract all terms first. This skill automates the extraction from raw contract text. The output format is compatible — a seller-facing summary from this skill can be sent directly using the nyoa-buyer-seller-comms email/voicemail templates.

## Shared context

This skill reads from `nyoa-context/`:
- `voice.md` — for tone of seller-facing summaries
- `profile.md` — for agent name and brokerage in headers

## Reference files

- `assets/templates/offer-summary.md` — seller-facing offer summary format
- `assets/templates/offer-comparison.md` — multi-offer comparison table format
