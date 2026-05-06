# Workflow: Listing Not Selling — 30+ Days, No Offers

Use this recipe when a listing has been active for more than 30 days without an accepted offer. The goal is to systematically diagnose what's wrong, fix what you can control, and have an informed, data-backed conversation with the seller about what you can't.

---

## Step 1 — Surface the listing as stale on the pipeline

```
/nyoa-pipeline
```

Pull up the pipeline. The listing should appear in the active section. Note how many days it has been on market. Update the "next step" field to reflect your current plan. If the listing hasn't been touched in the workspace for more than a week, update the last-activity stamp to reflect today.

This step is about orientation — know exactly where you are before you start diagnosing.

---

## Step 2 — Run a full listing audit

```
/nyoa-listing-audit <listing URL>
```

Provide the live URL for the listing on any major portal (Zillow, Realtor.com, your MLS, your brokerage site). NYOA will evaluate:

- **Copy quality** — is the description specific, benefit-forward, and free of clichés? Does it match the search terms buyers in this price range use?
- **Photo count and order** — primary bedroom photo should not be the hero image; front-of-home or best feature should lead
- **Price positioning** — how does the list price compare to recent solds and pending listings in the same area and size range?
- **Online presence completeness** — are all fields filled in? Virtual tour? Floor plan?
- **Fair Housing compliance** — any inadvertent flags that could suppress algorithmic distribution?

The audit returns a scored report with ranked, specific fixes — not vague "consider updating photos" advice.

**After this step:** you have a prioritized list of what to fix and what to bring to the seller conversation.

---

## Step 3 — Rewrite the MLS remarks if copy was the issue

If the audit flagged copy quality as a primary issue:

```
/nyoa-listing-copy <address> rewrite
```

Or: "rewrite the MLS remarks for <address> — the current copy is too generic."

NYOA reads the existing copy from `listings/<slug>/copy.md`, notes what the audit flagged, and produces a revised version. It will ask you for any updated facts before rewriting — new staging, recent repairs, price reduction context — so the new copy is grounded in specifics, not just repositioned around the same facts.

The rewrite is saved to `listings/<slug>/copy.md` with a dated version note appended.

---

## Step 4 — Draft the price-reduction conversation script

```
/nyoa-buyer-seller-comms <seller name> price reduction conversation
```

Or: "draft a script for the price reduction conversation with the seller at <address>."

NYOA drafts a seller communication that:
- Acknowledges their position and the effort already invested
- Presents the market data (use your comps — provide them or note they're in `listings/<slug>/comps.md`)
- Makes a specific, data-backed price recommendation (the agent fills in the number — NYOA will not invent pricing)
- Ends with a clear ask and two options (price change vs. status change to withdraw/hold)

This is not a script to read verbatim — it's a structure for a real conversation. Adjust the tone before the call.

---

## Step 5 — Refresh the social content

```
/nyoa-social-content <address> refresh
```

Or: "create new social posts for <address> — the listing has been sitting."

Provide any new angle to lead with: price improvement, open house coming up, motivated seller, recent renovation or staging update. NYOA generates 2–3 posts with a different creative approach than the launch content — a before/after angle, a neighborhood highlight, or a lifestyle-focused caption that doesn't repeat the original hero shot.

New posts are saved to `listings/<slug>/copy.md` under `## Social Content — Refresh <date>`.

---

## Step 6 — Log the price change or status update

Once you and the seller agree on a next move:

```
/nyoa-log
```

Examples:
- "Log: price reduced on 412 Maple from $499k to $479k. Effective May 15. Seller agreed. MLS updated."
- "Log: 412 Maple moved to withdrawn by seller request. Will relist in September after kitchen renovation."
- "Log: seller agreed to offer seller concessions — 2% toward buyer closing costs. Updated MLS."

NYOA appends this to `listings/<slug>/property.md` as a status note and updates the pipeline to reflect the new price or status. This entry becomes the baseline for the next audit if the listing relists.

---

**Next workflow:** if a price adjustment brings an offer, switch to the `under-contract` workflow.
Run `/nyoa-help workflow under-contract` to load it.

If you relisted after a withdrawal, restart the `new-listing` workflow.
Run `/nyoa-help workflow new-listing` to load it.

Voice used: NYOA house
