# Cadence Playbook

Default 12-month cadence plus four variants. Each row in a cadence has a target date (close date + N months), a touch type, a channel, and a one-sentence draft opener the agent will personalize before sending.

## Default — balanced relationship plan

For most past clients. Front-loaded with relationship touches, one soft referral ask in month 7, ends on the 1-year anniversary.

| Month | Touch type | Channel | Opener draft |
|---|---|---|---|
| 1 | Handwritten note ("two weeks in") | Mailed card | "Wanted to drop a quick note now that the boxes are mostly unpacked." |
| 2 | Drop-by gift, no agenda | In-person | "Was nearby — wanted to leave this on your porch." |
| 3 | Neighborhood market update | Email | "Quick neighborhood note — two homes on your block sold above asking last month." |
| 4 | Phone check-in | Call | "No agenda, just calling to check in." |
| 5 | Seasonal note or birthday | Email or card | (specific to season or birthday month) |
| 6 | Six-month retrospective | Email | "Six months on the new house — how is it feeling?" |
| 7 | Soft referral ask | Email | "A small ask: if you ever think to recommend me to someone, would you?" |
| 8 | Market update — broader market | Email | "City-wide read for the month." |
| 9 | Drop-by + small gift | In-person | "Was nearby — small thing for the kitchen." |
| 10 | Casual text or call | SMS or call | "Drove past your block today, thought of you." |
| 11 | Anniversary lead-up | Email | "Coming up on a year — had to mark it." |
| 12 | 1-year anniversary | Email | (defer to `nyoa-buyer-seller-comms/assets/templates/home-anniversary.md`) |

## Variant: introverted client

The client said "please don't drop by" or the agent's read is that drop-bys would feel intrusive. Swap drop-bys for emails or mailed gifts.

| Month | Touch type | Notes |
|---|---|---|
| 1 | Handwritten note | Same |
| 2 | Mailed gift (skip drop-by) | Local item shipped, no in-person |
| 3 | Neighborhood market update | Same |
| 4 | Email check-in (skip phone) | "No agenda. How's the house treating you?" |
| 5 | Seasonal or birthday email | Same |
| 6 | Six-month retrospective | Same |
| 7 | Soft referral ask | Same |
| 8 | Market update | Same |
| 9 | Mailed gift (skip drop-by) | Same as month 2 variant |
| 10 | Email — casual, no agenda | "Thought of you — saw this and you came to mind." |
| 11 | Anniversary lead-up | Same |
| 12 | 1-year anniversary | Same |

## Variant: cold relationship

The relationship is transactional — the client wasn't warm during the deal, didn't engage post-close. Cut the high-touch in-person months. Lean on useful content. Move the referral ask later (month 9+) or skip it entirely for year one.

| Month | Touch type | Notes |
|---|---|---|
| 1 | Handwritten note | Sets the tone — short, no follow-up question |
| 3 | Neighborhood market update | Useful content, no ask |
| 6 | Six-month retrospective | Same |
| 8 | Market update | Same |
| 9 | Soft referral ask — if relationship has warmed | If still cold, skip |
| 12 | 1-year anniversary | Defer to `nyoa-buyer-seller-comms/assets/templates/home-anniversary.md` — no valuation CTA for cold clients in year one |

Drop months 2, 4, 5, 7, 9-drop-by, 10, 11 from the default cadence. Six total touches in 12 months instead of 12.

## Variant: high-referral client

The client has already given a referral, or signaled they would. Tighten the cadence — they want to hear from the agent more — and front-load a second referral check-in.

| Month | Touch type | Notes |
|---|---|---|
| 1 | Handwritten note | Same |
| 2 | Drop-by gift | Same |
| 3 | Market update + "thanks for the [Smith referral]" | Acknowledge the prior referral |
| 4 | Phone check-in | Same |
| 5 | Seasonal | Same |
| 6 | Six-month retro | Same |
| 7 | Soft referral ask + offer something for past referrers | "If you ever recommend me, I always send a thank-you — wanted to ask first this time" |
| 8 | Market update | Same |
| 9 | Drop-by + gift | Same |
| 10 | Casual call | Same |
| 11 | Anniversary lead-up | Same |
| 12 | 1-year anniversary | Same |

Same 12 touches as default, but month 3 and month 7 explicitly reference the referral relationship.

## Variant: renter / future-buyer past client

The "past client" actually rented or browsed but didn't buy. The cadence anchors to first-tour-date rather than close-date. The anniversary touch in month 12 reframes around market changes, not "year in the house."

| Month | Touch type | Notes |
|---|---|---|
| 1 | Handwritten note — thanks for touring | "Wanted to thank you for the time touring last month." |
| 3 | Neighborhood market update | Same |
| 6 | Six-month market read for their original search criteria | Reminds them of what's changed |
| 9 | Soft check-in — "still looking, or has life moved on?" | Honest reactivation moment |
| 12 | Year-mark email — what's changed in their range | Not a "anniversary in the house" — a "where the market is, where you were, where it might be now" |

Five touches in 12 months. Skip drop-bys (no current address). Lean on market data — that's the value the agent provides to someone who's still maybe-buying.

## How to pick the variant

If the agent doesn't specify, infer from `clients/<slug>/profile.md` and `timeline.md`:

- Multiple touches in the timeline marked "no reply" → cold relationship.
- A line in profile like "introvert" or "prefers email" → introverted.
- A timeline entry "sent referral [name]" → high-referral.
- No closing entry, just showings → renter / future-buyer.
- Otherwise → default.

Always confirm the variant choice with the agent before writing the 12 tasks to the workspace.
