# Workflow: New Buyer Client

Use this recipe when a buyer has expressed interest and you're ready to start managing them as an active relationship in NYOA. Work through these steps in order — each one builds on the last.

---

## Step 1 — Create their workspace folder

```
/nyoa-client-add <full name>
```

Provide: name, buyer type, source (referral / Zillow / open house / etc.), contact info (email, phone), pre-approval status and lender if you have it, target areas and price range if known.

NYOA will scaffold `nyoa-workspace/clients/<slug>/` with profile, timeline, preferences, and documents files, and add them to the pipeline at the correct stage.

**After this step:** you have a permanent folder for everything related to this client.

---

## Step 2 — Confirm your tools are wired up

```
/nyoa-connect
```

Run this once if you haven't already. It detects whether email, calendar, or CRM MCPs are available in your session. If Gmail is wired up, the next step will offer to push the intro email directly. If not, you'll get copy to paste.

Skip this step if `nyoa-context/connectors.md` already exists and is current.

---

## Step 3 — Draft the intro email

```
/nyoa-buyer-seller-comms <buyer name> intro
```

Or just: "draft an intro email to <name>, new buyer."

NYOA will read the client's profile and your voice file, then draft a warm intro email that confirms next steps, sets expectations, and sounds like you. If you have a Gmail MCP, it will offer to push the draft.

**Customize:** tell NYOA anything specific you want to mention (pre-approval deadline, upcoming listing they mentioned, specific neighborhood).

---

## Step 4 — Verify them on the pipeline

```
/nyoa-pipeline
```

Review the pipeline snapshot. Confirm the new client is listed under the correct stage (lead / nurturing / active). Move them if needed. Set or update the "next step" field — this is what you'll see in the weekly review.

---

## Step 5 — Log your first real touchpoint

```
/nyoa-log
```

Example: "Log: called Sarah Chen, she's pre-approved at $550k, wants to see anything in East Nashville under 550. Interested in 3/2 with a yard. Call was warm."

NYOA appends this to `clients/<slug>/timeline.md`, refreshes the pipeline last-activity stamp, and prompts you to confirm any stage change.

---

## Step 6 — Set up a drip (ongoing)

As new listings come to market that match the buyer's criteria, run:

```
/nyoa-buyer-seller-comms <buyer name> new listing <address>
```

NYOA will draft a personalized nudge email or text referencing what you know about their preferences. If they've updated criteria, log it first with `/nyoa-log` so the draft is accurate.

---

**Next workflow:** when an offer is accepted, switch to the `under-contract` workflow.
Run `/nyoa-help workflow under-contract` to load it.

Voice used: NYOA house
