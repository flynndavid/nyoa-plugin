# Standard Deadline Taxonomy

The canonical names NYOA uses when filing deadlines in `nyoa-workspace/listings/<slug>/deadlines.md`. Other skills (`/nyoa-pipeline`, `/nyoa-weekly-review`, `/nyoa-buyer-seller-comms`) parse these names — keep them stable.

If a clause in a contract doesn't fit one of the names below, use a short descriptive title and add `(custom)` so future skills know it's outside the standard set.

## Standard names

| Name | What it is | Typical owner |
|---|---|---|
| Earnest Money Due | Buyer's deposit to escrow | Buyer |
| Inspection Period Ends | Last day for the buyer to object on inspection grounds | Buyer |
| Inspection Response Due | Seller's deadline to respond to a repair request | Seller |
| Appraisal Ordered | Lender orders the appraisal | Buyer / Lender |
| Appraisal Contingency Ends | Last day to object based on appraised value | Buyer |
| Financing Commitment | Lender's written loan commitment due | Buyer / Lender |
| Loan Documents to Title | Lender delivers docs to settlement | Lender |
| Title Commitment Delivered | Title company delivers preliminary title | Title |
| Title Objection Period Ends | Last day for buyer to object on title grounds | Buyer |
| HOA Documents Delivered | Seller / HOA delivers governing docs | Seller / HOA |
| HOA Review Period Ends | Buyer's deadline to object on HOA grounds | Buyer |
| Insurance Binder Required | Hazard insurance bound before close | Buyer |
| Survey Ordered / Delivered | Property survey complete | Buyer or Seller |
| Walk-Through | Final pre-close walk | Buyer |
| Closing Disclosure Delivered | Three-day TRID disclosure clock starts | Lender |
| Closing | Funding and recording | Both |
| Possession | Keys exchange (may differ from closing) | Both |

## When the contract uses different language

Real estate contracts vary by state and brokerage form. The mapping is:

- "Due diligence period" → **Inspection Period Ends**
- "Resolution period" / "Repair amendment due" → **Inspection Response Due**
- "Loan approval" / "Loan denial deadline" → **Financing Commitment**
- "Title commitment" / "Title insurance commitment" → **Title Commitment Delivered**
- "Final walk-through" / "Buyer's final inspection" → **Walk-Through**
- "Settlement" → **Closing**

If the contract uses a name not on this list and not in the mapping, keep the contract's wording and append `(custom)`. Example: `Solar Panel Lease Assumption Deadline (custom)`.

## Owner column

Always one of:
- `Buyer`
- `Seller`
- `Lender`
- `Title`
- `Buyer / Lender` (when the buyer is responsible for delivering something their lender produces)
- `Seller / HOA`
- `Both`

If the executed contract puts the obligation on a specific party not in the list (e.g., a trustee, an attorney-in-fact), use their role title literally.

## Consequence column

Phrase the consequence in agent-readable plain language. Examples:

- "Buyer may lose earnest money"
- "Inspection contingency expires — buyer loses right to object on inspection grounds"
- "Financing contingency expires — buyer is no longer protected by the loan-approval out"
- "Default — possible specific performance or damages"
- "Closing date adjusts; per diem may apply (check contract)"

Never write "contract is void" unless the contract specifically uses that language. Most modern forms say "may terminate" or "may pursue remedies", which is different from automatic voidness.

## Reminder offsets

Default reminder offsets (days before the deadline):

| Deadline type | Reminders |
|---|---|
| Earnest Money Due | 3, 1, day-of |
| Inspection Period Ends | 5, 2, day-of |
| Financing Commitment | 7, 3, day-of |
| Title Objection Period Ends | 5, 2 |
| Walk-Through | 3, 1 |
| Closing | 14, 7, 3, 1 |
| All others | 3, 1 |

Adjust if the agent has a tighter or looser preference filed in `nyoa-context/feedback.md`.
