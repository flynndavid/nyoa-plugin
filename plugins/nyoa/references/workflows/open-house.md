# Workflow: Open House — Before, During, and After

Use this recipe to prepare, run, and follow up on an open house. The goal is to arrive with polished materials, capture every visitor, and turn attendees into warm leads before the week is out.

---

## Before the Open House

### Step 1 — Refresh the listing copy

```
/nyoa-listing-copy <address>
```

Run this 3–5 days before the event if any details have changed since the listing launched (price adjustment, new photos, seller concessions, recent improvements). NYOA re-reads `listings/<slug>/property.md` and regenerates any copy assets that are stale.

If the copy is already current, skip this step. The audit in Step 6 will flag staleness after the fact if needed.

---

### Step 2 — Draft the open-house announcement post

```
/nyoa-social-content <address> open house
```

Or: "write an open house announcement for <address>, this Saturday 1–3pm."

Provide: date, time window, any highlights worth featuring (fresh paint, new appliances, motivated seller, price just reduced). NYOA drafts a platform-specific announcement for Instagram, Facebook, and an optional LinkedIn version. Saved to `listings/<slug>/copy.md` under `## Open House Content`.

Schedule the post to publish 3–4 days before the event for maximum reach.

---

### Step 3 — Invite matching buyer leads

```
/nyoa-buyer-seller-comms <list of buyer names or criteria> open house invite
```

Or: "draft an open house invitation to my active buyers who might like <address>."

Describe the property criteria (bedrooms, price range, neighborhood) and NYOA will identify which buyer profiles in your workspace match, then draft a personalized email or text for each one. If you have buyers without workspace profiles yet, add them first with `/nyoa-client-add`.

Send invitations 3–5 days out to give people time to plan.

---

## During the Open House

### Step 4 — Log each visitor (real-time or batch after)

```
/nyoa-log
```

You can log in real time between visitors, or do a single batch log at the end:

"Log: open house at 412 Maple, Saturday May 10, 1–3pm. 11 visitors. Serious interest: Dana Reyes (couple, pre-approved, liked the yard, concerned about kitchen size — want follow-up Monday). Marcus Brown (investor, cash, wanted to know about comps — send follow-up with price history). 9 casual lookers, no contact info."

NYOA appends to `listings/<slug>/showings.md` and creates new client entries for any leads you want to track.

If you want a new client folder for a promising visitor:

```
/nyoa-client-add <visitor name>
```

---

## After the Open House

### Step 5 — Send personalized follow-ups

```
/nyoa-buyer-seller-comms <visitor name> open house follow-up
```

Run this for each interested visitor within 24 hours. NYOA reads what you logged about them and drafts a follow-up that references the specific things they mentioned — not a generic "thanks for visiting" blast.

Example outputs: a follow-up email that addresses the kitchen concern with a comp remodel cost, a text to the investor with the price history they asked about.

---

### Step 6 — Audit if traffic was low

If fewer than 5 visitors showed up for a listing that's been on market more than 14 days, run:

```
/nyoa-listing-audit <listing URL>
```

Low open-house traffic is a signal — not a diagnosis. The audit will evaluate whether the issue is copy, photos, pricing, online presence gaps, or something else. It returns specific, ranked fixes so you know what to address before the next showing or open house.

---

**Next workflow:** if the listing receives an offer after the open house, switch to the `under-contract` workflow.
Run `/nyoa-help workflow under-contract` to load it.

If the listing stalls and offers aren't coming, switch to the `listing-not-selling` workflow.
Run `/nyoa-help workflow listing-not-selling` to load it.

Voice used: NYOA house
