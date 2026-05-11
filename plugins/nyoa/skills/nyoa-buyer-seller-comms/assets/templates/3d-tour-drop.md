# 3D Tour Drop — Buyer Notification Template

**Channel:** SMS or email to buyers who saved or showed interest in the listing.
**When:** The day a 3D tour goes live for a listing the buyer has touched (saved on Zillow, asked about, walked already and is on the fence).
**Goal:** Re-engage cooling buyers without being a "hey just checking in" template.

## Channel selection

- **SMS** — buyers who explicitly asked to be texted, or warm leads in active search. Single SMS, ≤160 chars.
- **Email** — buyers in a saved-search drip, sphere, or cooling pipeline. ≤120 words.

If unsure, default to email. Most buyers appreciate the link more than they appreciate a notification.

## SMS variant

```
{{first_name}}, the {{address}} listing now has a 3D walkthrough — photoreal, in your browser. Walk every room: {{tour_url}}. Reply if you want to see it in person.
```

Hard rules:
- ≤160 characters total
- 0 emojis
- Bare URL (no tracking parameters that look spammy)
- 0 "Hi {first_name}!" — first name + comma, no exclamation
- Drop the listing's neighborhood if budget allows; otherwise just the address

## Email variant

### Subject
- "{{address}} now walks in 3D"
- "Walk {{address}} from your couch"
- 0 emojis. 0 all-caps.

### Body

```
Hi {{first_name}} —

Quick note on {{address}} — the listing you {{saved | asked about | walked last week}}. It's now a 3D walkthrough you can open in any browser.

Walk it now: {{tour_url}}

You can stand in the kitchen, look out the upstairs windows, see how the {{specific_feature}} feels when you're standing next to it. No app, no signup.

If you want to see it in person after, reply or use {{scheduling_link}}.

— {{agent_first_name}}
```

Hard rules:
- ≤120 words
- 0 Fair Housing red flags
- 0 hype phrases
- Reference what the buyer actually did with the listing (saved / asked / walked) — not generic "you might be interested"
- The tour link is the primary CTA — don't bury it

## Variables

- {{first_name}} — buyer's first name (read from `clients/<slug>/profile.md`)
- {{address}}
- {{tour_url}} — read from `listings/<slug>/marketing/3d-tour.md`
- {{specific_feature}} — pull from `listings/<slug>/copy.md` (the existing hook)
- {{saved | asked about | walked last week}} — pick based on `clients/<slug>/timeline.md`
- {{scheduling_link}} — read from `nyoa-context/profile.md`
- {{agent_first_name}}

## When NOT to send

- The buyer already declined the listing (in `timeline.md` as "passed").
- The listing already went under contract (check `pipeline.md`).
- The buyer was sent a 3D-tour drop on this listing in the last 14 days (check `clients/<slug>/timeline.md`).

## Workspace integration

- Append a timeline entry to `clients/<slug>/timeline.md`: "YYYY-MM-DD — 3D tour drop sent for [address] — [channel]".
- Refresh `pipeline.md` last-activity stamp for the buyer.
- If `marketing/3d-tour.md` exists, append to its History section: "YYYY-MM-DD — drop sent to [N buyers]".
