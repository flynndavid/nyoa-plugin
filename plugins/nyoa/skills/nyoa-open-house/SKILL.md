---
name: nyoa-open-house
description: Generate the full open-house promotion package for a listing — multi-channel copy (Instagram post, Facebook event, sphere email, text blast, Stories sequence, sign-in card copy) plus a day-of run-of-show. Reads the listing's facts from the workspace so the agent doesn't restate them, files the package under the listing folder for re-use, and adds the event to the calendar. Use this skill 5-7 days before an open house, when the agent asks "promote my open house at [address]", or when scheduling a public showing event. Triggers on "open house", "promote my open house", "open house package for [address]", "open house this weekend", "OH copy", "OH event".
---

# Open House Promotion

A complete promo package for a single open house, written for the channels an agent actually uses, filed back into the listing's workspace folder so the package is reusable for the next OH (price drop weekend, second showing).

The nyoa-listing-copy skill handles the listing launch package. This skill handles the recurring event: an open house. Different audience, different urgency, different channel mix.

## When this skill triggers

- "Open house package for [address]"
- "Promote my open house this [Saturday/Sunday]"
- "OH this weekend at [address]"
- "Need open house copy for [address]"
- "Open house event description"
- "Day-of run-of-show for [address] open house"
- Agent provides an address + a date/time and asks for promo material

## Inputs you need

Required:
- **Property address or listing slug**
- **Date and time window** (e.g., "Saturday 1–3pm")
- **List price**

Optional but improves output:
- Standout features (we read `listings/<slug>/property.md` and `copy.md` first — only ask if those are missing)
- Special context — first weekend on market, post-price-drop refresh, sneak-peek for the agent's sphere, broker open vs. public
- Parking instructions, what to do about pets, refreshments
- Buyer-agent commission notes (for the broker-only open variant)
- Whether the open house is co-hosted with another agent

If `property.md` is missing facts the agent typically files there, don't fabricate. Ask one clarifying question, then proceed with what you have.

## Workflow

### Capability requirements

Read `nyoa-context/connectors.md`. If the agent has a stated preference for a capability, use the corresponding connector. If multiple connectors are available for a capability and no preference is set, ask which to use. If none are available, fall back to file-only behavior.

- **email** (`google-workspace` or `outlook`): When available, NYOA offers to push the sphere email as a draft to the agent's email client with the saved recipient list. Always confirm before sending — never auto-send. Falls back to delivering the email inline.
- **calendar** (`google-workspace` or equivalent): When available, NYOA offers to create a calendar event for the open-house window plus a T-minus-90 prep block. Falls back to appending entries to `nyoa-workspace/calendar.md`.
- **sms** (`twilio` or equivalent): When available, NYOA offers to deliver the text blast to a confirmed recipient list. Always confirm the list before sending — never auto-send. Falls back to inline SMS draft only.
- **web-scrape** (`firecrawl` or equivalent): When available and the listing has a public URL in `property.md`, NYOA offers to pull the canonical hero photo URL to use as the Facebook event header. Falls back to letting the agent attach the photo manually.
- **docs** (`google-workspace` or `notion`): When available, NYOA offers to save the full marketing package to cloud storage alongside the workspace write-through.

1. **Resolve the listing.** Slug the address, check `nyoa-workspace/listings/<slug>/property.md` and `copy.md`. If both are missing, ask the agent for the minimum facts (beds/baths/sqft + 3 features) and offer to file them via `/nyoa-listing-add` after.
2. **Resolve voice.** Per-agent voice file → `nyoa-context/voice.md` → NYOA house style. Same order as every other skill.
3. **Pick channels.** Default channel set is: Instagram feed post, Facebook event description, sphere email, text blast, three Stories frames (T-minus-4h / live / wrap), sign-in card copy. The agent can ask for a subset or add channels (LinkedIn, NextDoor, Threads).
4. **Draft each channel** from the templates under `assets/templates/`. Use the same per-channel rules NYOA uses elsewhere (`nyoa-buyer-seller-comms/references/channel-conventions.md`) — SMS ≤ 320 chars, no emojis, no "Hi {first}"; email opens with the why-now not the hello.
5. **Build the day-of run-of-show** (`assets/templates/day-of-runofshow.md`) — what the agent does at T-90, T-30, T-0, T+0–end, T+wrap. A practical checklist, not a script.
6. **Run the compliance pass.**
7. **Write through to the workspace.**
8. **Deliver.**

## Compliance pass (mandatory before delivering)

Standard NYOA Fair Housing rules apply across every channel. Cross-check the package for:

- **No demographic targeting.** Open houses are public events. Promo copy can't say "perfect for families", "great for young couples", "in our [ethnic/religious] community". Speak to the property, not the buyer profile.
- **No safety claims.** Don't say "safe neighborhood", "low crime", or anything implying a comparison.
- **No school quality claims.** District names are OK if neutrally stated; "great schools" / "top-rated district" is not, unless you cite a verifiable, current source.
- **"Primary bedroom"** not "master bedroom".
- **No unsourced renovation claims.** Don't say "fully updated" or "new roof" unless the agent confirmed it (or it's already in `property.md`).
- **No clichés.** Strip "must see", "stunning", "nestled", "boasts", "rare opportunity", "won't last", "luxury living awaits".
- **Specific dates / times only.** Don't say "this weekend" — give the actual date and window.
- **License + brokerage attribution.** Facebook event and email variants must include the agent name, brokerage, and license number footer. SMS and Stories don't (length / format constraints), but the agent should be identifiable from the sender.

If the agent's input includes a Fair Housing violation, call it out: "I flagged 'great for families' in your features list — Fair Housing risk. Rewriting around the floor plan instead."

Footer to include on the email and Facebook event variants:

> Hosted under the Fair Housing Act. This event is open to every prospective buyer regardless of race, color, religion, sex, national origin, familial status, disability, or any other protected class. The promotion describes the property, not the people who might buy it.

## Workspace integration

If `nyoa-workspace/listings/<slug>/` exists:

- **Create `listings/<slug>/marketing/`** if it doesn't exist.
- **Save the full package** to `listings/<slug>/marketing/open-house-YYYY-MM-DD.md` (use the open-house date in the filename so multiple weekends each get their own file).
- **Append a showing entry** to `listings/<slug>/showings.md` — date, type=open-house, hours.
- **Append to `nyoa-workspace/calendar.md`** under the right week section: `- HH:MM — Open house — listings/<slug>/ — <address>` plus a T-minus-90 prep entry.
- **Append to `nyoa-workspace/tasks.md`** — a "deliver sphere email" task dated 5 days before, a "post Stories T-minus-4h" task dated for the morning of.
- **Refresh `pipeline.md`** — bump the listing's last-activity date.

If the workspace doesn't exist, offer to scaffold it (defer to `/nyoa-setup`); otherwise deliver inline-only.

## Output format

Single Markdown response with these sections, each independently copyable:

1. **Header** — address, date, window, list price, voice resolution.
2. **Instagram feed post** — caption + 12–15 hashtags. Caption opens with the why-now, not the hello.
3. **Facebook event description** — 200-300 words. Includes address, window, list price, 3-5 standout features, parking, agent attribution footer.
4. **Sphere email** — subject + body. ≤ 200 words. One light CTA. Agent attribution footer.
5. **Text blast** — single SMS ≤ 160 chars. No emojis.
6. **Stories sequence** — three frames: T-minus-4h ("starting in 4 hours"), live ("come say hi"), wrap ("turnout / one moment to remember").
7. **Sign-in card copy** — one short paragraph the agent prints on the sign-in card so attendees know how their info will be used. Should set expectations: one follow-up, not a marketing list.
8. **Day-of run-of-show** — checklist with timestamps.
9. **Compliance footer** (verbatim, as written above) on the email + Facebook channels only.
10. **Connector offers** — only if applicable.

End with: "Voice used: <agent name | NYOA house>. Saved to nyoa-workspace/listings/<slug>/marketing/open-house-YYYY-MM-DD.md." (Skip the save line if no workspace.)

## Shared context

Reads from `nyoa-context/`:
- `profile.md` — agent name, brokerage, license number for footers.
- `voice.md` — tone resolution.
- `connectors.md` — connector branch.

Reads from `nyoa-workspace/`:
- `listings/<slug>/property.md` — primary fact source.
- `listings/<slug>/copy.md` — feature phrasing already approved for this listing (reuse don't reinvent).
- `listings/<slug>/marketing/` — prior open-house files for the same listing (cross-reference to avoid repeating the same Stories caption two weekends in a row).

Writes to `nyoa-workspace/`:
- `listings/<slug>/marketing/open-house-YYYY-MM-DD.md` — primary writer.
- `listings/<slug>/showings.md` — append.
- `calendar.md` — append.
- `tasks.md` — append (sphere email task, Stories task).
- `pipeline.md` — refresh last-activity stamp.

## Reference files

- `assets/templates/instagram-feed-post.md`
- `assets/templates/facebook-event.md`
- `assets/templates/sphere-email.md`
- `assets/templates/text-blast.md`
- `assets/templates/stories-sequence.md`
- `assets/templates/sign-in-card.md`
- `assets/templates/day-of-runofshow.md`
