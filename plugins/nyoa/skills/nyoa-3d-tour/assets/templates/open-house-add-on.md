# 3D Tour — Open-House Add-On Insert

**Purpose:** A reusable one-paragraph insert that other skills (`/nyoa-open-house`, `/nyoa-buyer-seller-comms`) can drop into their open-house promo when a 3D tour exists.
**Format:** Plain Markdown paragraph — no headings, no horizontal rules. Designed to be inserted between sections, not as its own section.

## When to use

The conditional rule for any skill consuming this insert:

```
IF nyoa-workspace/listings/<slug>/marketing/3d-tour.md exists
AND it has a non-empty Tour URL
THEN render this insert into the open-house promo output (any channel except SMS — too long).
ELSE render nothing (silent fallback).
```

## The insert (canonical wording)

```
Can't make Sunday? Walk it now. The full house is a 3D tour at {{tour_url}} — photoreal, browser-based, no app. Stand in the kitchen, look out the upstairs windows, see the lot from the porch. If you want to walk it in person after, reply or grab a slot at {{scheduling_link}}.
```

## Variants by channel

### Long form (Facebook event, sphere email)
Use the canonical wording above. ~50 words.

### Short form (Instagram caption, story frame)
```
Can't make Sunday? Walk it now in 3D — {{tour_url}}.
```

### SMS — DO NOT INSERT
SMS character budget can't absorb a tour link without breaking the 160-char limit. Skip the tour mention in SMS.

### Yard-sign / sign-in-card variant
```
Walk it now in 3D — scan the QR or visit {{short_url}}.
```

## Hard rules

- 0 Fair Housing red flags
- 0 hype phrases ("amazing", "stunning", "must-see")
- The tour mention complements the open house, never replaces it. Wording must always preserve the in-person CTA.
- The tour URL is bare — no "click here" anchor text.

## Variables

- {{tour_url}} — read from `marketing/3d-tour.md`
- {{short_url}} — short URL if available, else the full one
- {{scheduling_link}} — read from `nyoa-context/profile.md` if present

## How consuming skills should source this

In `/nyoa-open-house` SKILL.md, in the workflow:

```
After drafting the Facebook event description and sphere email, check:
- Does nyoa-workspace/listings/<slug>/marketing/3d-tour.md exist with a Tour URL?
- If yes, append the open-house add-on insert from
  nyoa-3d-tour/assets/templates/open-house-add-on.md (long-form variant)
  before the agent attribution footer.
- If no, skip silently.
```

In `/nyoa-buyer-seller-comms` SKILL.md, when drafting `seller-showing-feedback.md` or `buyer-drip-newlistings.md` for a listing that has a tour:

```
If marketing/3d-tour.md has a Tour URL, include the short-form variant
of the open-house add-on insert.
```
