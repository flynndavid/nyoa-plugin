---
name: buyer-seller-comms
description: Draft the recurring client communications a real estate agent sends every week — buyer drips (new listings, price drops, check-ins), seller updates (weekly activity reports, showing feedback summaries), transactional comms (offer summaries in plain English, counter-offer drafts), and follow-ups (post-showing thank-yous, post-close referral asks). Use this skill whenever the user asks to draft a message to a buyer, seller, lead, or past client; summarize an offer; write a follow-up; or generate a CRM-ready template. Triggers on phrases like "draft a note to my buyers", "send a price-drop alert", "weekly seller update", "summarize this offer", "post-showing follow-up", "ask for a referral".
---

# Buyer / Seller Communications

Generate the messages an agent sends every week. SMS, email, or voicemail script — your call based on the channel that fits the moment. Always personal-sounding, never template-y, always compliant.

## When this skill triggers

- "Draft a note to my buyers watching [neighborhood / price band]"
- "Send a price-drop alert for [address]"
- "Weekly update for [seller name]"
- "Summarize this offer for [seller]"
- "Counter-offer draft"
- "Post-showing thank you to [buyer name]"
- "Ask [past client] for a referral"
- "Follow up on the [property] showing from yesterday"

## Templates available

Buyer-side:
- `assets/templates/buyer-drip-newlistings.md` — new listings hitting their criteria
- `assets/templates/buyer-drip-pricedrop.md` — price drop on something they viewed
- `assets/templates/buyer-checkin.md` — "still looking?" check-in for the cooling lead

Seller-side:
- `assets/templates/seller-weekly-update.md` — Friday recap (showings, online activity, comp moves)
- `assets/templates/seller-showing-feedback.md` — summarized agent feedback after showings

Transactional:
- `assets/templates/offer-summary.md` — translate an offer into plain English for the seller
- `assets/templates/counter-offer-draft.md` — counter language for the seller to approve

Follow-up:
- `assets/templates/post-showing-thankyou.md` — same-day thank-you after a showing
- `assets/templates/referral-ask.md` — post-close referral request

## Inputs you need

For every template, ask for what you don't have. The minimum required inputs are listed in each template's header. Don't invent. If the agent says "I don't have that", say what you can reasonably draft without it.

## Channel selection

Each template includes SMS / email / voicemail variants where applicable. Choose based on the relationship and message type:

- **SMS** — active leads, time-sensitive (price drop, new listing within their criteria, day-of showing logistics). Keep to ≤320 chars (2 SMS segments). No emojis. No "Hi {first}".
- **Email** — sellers (record of communication), past clients (referral asks), longer information (offer summaries, weekly updates).
- **Voicemail script** — high-stakes (offer summary, counter offer, condolence-adjacent moments), or when the agent says "I want to call them about this".

When in doubt, ask the agent which channel, default to email if they don't specify.

See `references/channel-conventions.md` for full per-channel rules.

## Voice

Same voice resolution order as `listing-copy`:
1. Per-agent voice file if present
2. Otherwise NYOA house style (warm, specific, confident, plain)

Avoid template-speak: "I hope this email finds you well", "Just touching base", "Per our last conversation", "Looking forward to hearing from you".

## Compliance

All the same Fair Housing rules as `listing-copy/references/voice-presets.md`. Never:
- Categorize the recipient by protected class ("families like yours", "couples like you")
- Reference religion, ethnicity, national origin, familial status
- Make protected-class assumptions about what a buyer wants

## Output format

Single Markdown response. If the user requested one channel, deliver one variant. If they didn't specify, deliver SMS + email by default (and a voicemail script for offer-summary, counter-offer, and referral-ask). End with a one-line note: "Channel: <SMS | email | voicemail>. Voice: <agent | NYOA house>".
