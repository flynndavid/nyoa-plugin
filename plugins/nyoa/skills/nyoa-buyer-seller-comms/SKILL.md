---
name: nyoa-buyer-seller-comms
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
- "Birthday note for [past client]"
- "Anniversary email for [client] — they're at year [N]"
- "Closing day note for [client]"
- "Send the 3D tour drop for [address] to my buyer list" / "Notify [client] that 123 Maple now has a 3D tour"

## Workflow

### Capability requirements

Read `nyoa-context/connectors.md`. If user has a stated preference for a capability, use the corresponding connector. If multiple connectors are available and no preference is set, ask which to use. If none are available, fall back to file-only behavior.

- **email** (`google-workspace` or `outlook`): When available, NYOA offers to push email drafts directly to the agent's email client (Gmail / Outlook). Always confirm before sending — never auto-send.
- **calendar** (`google-workspace` or `outlook`): When the message references a showing, follow-up, or appointment time, NYOA offers to create a calendar event. Falls back to appending to `nyoa-workspace/calendar.md`.
- **sms**: When a verified SMS MCP is available, NYOA offers to send SMS drafts via the agent's SMS tool. Falls back to delivering the draft inline for manual send.
- **crm**: When a CRM connector is available, NYOA offers to log the sent message as a note on the contact record. Falls back to appending to `clients/<slug>/timeline.md`.
- If none of the above are available, deliver the draft inline as Markdown — same as today.

## Templates available

Buyer-side:
- `assets/templates/buyer-drip-newlistings.md` — new listings hitting their criteria
- `assets/templates/buyer-drip-pricedrop.md` — price drop on something they viewed
- `assets/templates/buyer-checkin.md` — "still looking?" check-in for the cooling lead
- `assets/templates/3d-tour-drop.md` — re-engagement message when a 3D walkthrough goes live for a listing the buyer has touched. Reads `listings/<slug>/marketing/3d-tour.md` for the URL.

Seller-side:
- `assets/templates/seller-weekly-update.md` — Friday recap (showings, online activity, comp moves)
- `assets/templates/seller-showing-feedback.md` — summarized agent feedback after showings

Transactional:
- `assets/templates/offer-summary.md` — translate an offer into plain English for the seller
- `assets/templates/counter-offer-draft.md` — counter language for the seller to approve

Follow-up:
- `assets/templates/post-showing-thankyou.md` — same-day thank-you after a showing
- `assets/templates/referral-ask.md` — post-close referral request

Past-client relationship maintenance:
- `assets/templates/past-client-birthday.md` — annual birthday note. No CTA — pure relationship.
- `assets/templates/home-anniversary.md` — 1/2/3-year (with soft valuation offer) and 5+ year (with market narrative instead) variants.
- `assets/templates/closing-day-note.md` — handwritten-style card the agent mails the day of closing. No CTA, no signature block, no brokerage logo.

Agent-saved overrides:
- `nyoa-workspace/templates/intro-emails.md` and `templates/follow-up-cadence.md` — if the agent has saved their own opener email or cadence, prefer those over the built-in templates. Always check the workspace first.

## Inputs you need

For every template, ask for what you don't have. The minimum required inputs are listed in each template's header. **Read first, ask second** — check `nyoa-workspace/clients/<slug>/profile.md` and `preferences.md` for any client mentioned by name; check `listings/<slug>/property.md` for any address. Don't invent. If the agent says "I don't have that", say what you can reasonably draft without it.

## Channel selection

Each template includes SMS / email / voicemail variants where applicable. Choose based on the relationship and message type:

- **SMS** — active leads, time-sensitive (price drop, new listing within their criteria, day-of showing logistics). Keep to ≤320 chars (2 SMS segments). No emojis. No "Hi {first}".
- **Email** — sellers (record of communication), past clients (referral asks), longer information (offer summaries, weekly updates).
- **Voicemail script** — high-stakes (offer summary, counter offer, condolence-adjacent moments), or when the agent says "I want to call them about this".

When in doubt, ask the agent which channel, default to email if they don't specify.

See `references/channel-conventions.md` for full per-channel rules.

## Connector-aware delivery

Read `nyoa-context/connectors.md` if it exists.

- If `gmail: yes`, after drafting an email, offer: "Want me to push this to Gmail as a draft to <recipient>?" Always confirm before sending. Never auto-send.
- If `twilio: yes` (or another SMS MCP), offer the same for SMS.
- If `google-calendar: yes` and the message references a showing or follow-up time, offer to create a calendar event.
- If a CRM is wired up, offer to log the message as a note on the contact.
- If none of the above are wired up, deliver the draft inline as Markdown — same as today.

## Voice

Same voice resolution order as `nyoa-listing-copy`:
1. Per-agent voice file if present (`nyoa-context/voice.md` or `agents/<name>/voice.md`)
2. Otherwise NYOA house style (warm, specific, confident, plain)

Avoid template-speak: "I hope this email finds you well", "Just touching base", "Per our last conversation", "Looking forward to hearing from you".

## Compliance pass

Before delivering output, delegate to `/nyoa-compliance-review`:

1. Generate the draft per the rest of this skill's workflow.
2. Invoke `/nyoa-compliance-review` with the draft as input and this skill's name (`nyoa-buyer-seller-comms`) as the calling context.
3. If the review returns **APPROVED**, deliver the draft. `/nyoa-compliance-review` appends the disclaimer footer and writes the audit-log entry — do not duplicate.
4. If the review returns **FIX RECOMMENDED** or **FIX REQUIRED**, surface the findings to the user. Apply their chosen action:
   - **Apply all** — use the cleaned draft as the final output.
   - **Apply selected** — apply only the user-chosen fixes.
   - **Override** — capture the user's one-sentence reason; `/nyoa-compliance-review` logs it.
   - **Edit manually** — return the findings to the user and stop; they re-run the skill when ready.
   Then deliver.
5. If the agent's **own input** contained a fair-housing violation, surface it explicitly in your response in addition to letting `/nyoa-compliance-review` catch it.

Canonical rules and jurisdictional reasoning live in `plugins/nyoa/references/compliance/fair-housing.md` (loaded by `/nyoa-compliance-review`). Do not duplicate them here.

## Workspace integration

When the message targets a known client or listing in the workspace:

- Append a timeline entry to `nyoa-workspace/clients/<slug>/timeline.md` (or `listings/<slug>/showings.md` for post-showing follow-ups). Format per `plugins/nyoa/references/context-formats.md`.
- Refresh the matching `pipeline.md` last-activity stamp.
- If the message proposes a follow-up date, also append to `nyoa-workspace/calendar.md` and `tasks.md`.

If the workspace doesn't exist or the recipient isn't a tracked client, skip silently — the draft is still delivered.

## Output format

Single Markdown response. If the user requested one channel, deliver one variant. If they didn't specify, deliver SMS + email by default (and a voicemail script for offer-summary, counter-offer, and referral-ask). End with a one-line note: "Channel: <SMS | email | voicemail>. Voice: <agent | NYOA house>". If workspace write-through ran or a connector was used, add a confirmation line (e.g., "Logged to clients/jane-doe/timeline.md." or "Drafted in Gmail.").

The disclaimer footer is appended automatically by `/nyoa-compliance-review` — do not include it in this skill's own output template.
