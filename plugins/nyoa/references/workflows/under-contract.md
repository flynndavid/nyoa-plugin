# Workflow: Under Contract — Accepted Offer to Close

Use this recipe the moment an offer is accepted — for either side of the transaction (representing the buyer or the seller). The goal is to keep both parties informed, log every milestone, and set yourself up for a smooth referral at the end.

---

## Step 1 — Log the accepted offer with full terms

```
/nyoa-log
```

Example: "Log: offer accepted on 412 Maple Ave. Buyer: Marcus Webb. Purchase price $487,000. Earnest money $9,000. Inspection contingency 10 days. Financing contingency 21 days. Appraisal contingency yes. Close date June 14."

NYOA appends this to `listings/<slug>/offers.md` (seller side) or `clients/<slug>/timeline.md` (buyer side) and updates the last-activity stamp on the pipeline row.

**After this step:** the full contract terms are in the workspace — every future skill that references this transaction reads from here.

---

## Step 2 — Move to "under-contract" stage

```
/nyoa-pipeline
```

Pull up the pipeline. Move the listing (or buyer client) from "active" to "under-contract." Set the close date. Update the next step to "inspection by <date>." Confirm the change.

---

## Step 3 — Set up the contingency check-in cadence

```
/nyoa-buyer-seller-comms <client name or address> contingency update
```

Or: "draft a check-in cadence for <client> under contract."

NYOA will draft a short sequence of communications timed around your contingency deadlines:
- Inspection period opening check-in
- Inspection results notification (template — you fill in results)
- Appraisal confirmation note
- Clear-to-close announcement
- Closing day message

Customize any of these before saving. If you have a Gmail MCP wired up, NYOA will offer to push each draft on schedule.

---

## Step 4 — Log inspection, appraisal, and lender updates as they happen

```
/nyoa-log
```

Log each milestone as it occurs. Examples:
- "Log: inspection on 412 Maple done. 3 items requested for repair: HVAC filter, downspout extension, caulk around master bath. Seller agreed to credit $800."
- "Log: appraisal came in at $490k. Above purchase price. Lender moving to underwriting."
- "Log: lender issued clear-to-close. Wire instructions sent. Closing confirmed June 14 at 10am."

Each entry is appended to the offers or timeline file. NYOA never overwrites existing log entries.

---

## Step 5 — Log the close and move to "closed"

```
/nyoa-log
```

Example: "Log: closed 412 Maple Ave June 14. Seller net proceeds: $[VERIFY AMOUNT]. Buyer moved in same day. Smooth transaction."

Then:

```
/nyoa-pipeline
```

Move the record to "closed." Set the close date. NYOA updates the pipeline and archives the listing from the active view.

---

## Step 6 — Request testimonials from both sides

```
/nyoa-testimonial-engine <client name or address>
```

Or: "draft a review request for Marcus and the seller on 412 Maple."

Run this within 48 hours of closing while the experience is fresh. NYOA drafts a personalized review request — short, warm, non-pushy — for each party. It reads their timeline and names specific moments from the transaction to make the ask feel genuine.

Responses are saved to `nyoa-context/proofs.md` when the agent pastes them back in.

---

**Next workflow:** if you're ready to onboard a new buyer who came from this referral, start the `new-buyer` workflow.
Run `/nyoa-help workflow new-buyer` to load it.

Voice used: NYOA house
