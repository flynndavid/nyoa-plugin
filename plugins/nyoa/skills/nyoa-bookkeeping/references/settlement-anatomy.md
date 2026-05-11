# Settlement Statement Anatomy

A reading guide for the three main forms `/nyoa-bookkeeping settlement` extracts from: ALTA settlement statement, HUD-1, and the Closing Disclosure (CD). The extraction logic differs by form because the line numbering and section structure differ.

## ALTA Settlement Statement

The standard form most title companies use now. Section structure:

| Section | What's here | Extract |
|---|---|---|
| Header | Parties, property address, file/closing number, settlement date | Property, transaction date, buyer/seller names |
| Sale price | Section 100 | Sale price |
| Adjustments | Sections 200/300 — prorations, credits | Concessions, seller credits, repair credits |
| Loan information | Section 400 | If you need to compute lender-side data |
| Commission | Section 700 (typically 701 listing, 702 buyer side) | Total commission, your side, brokerage split |
| Title charges | Section 800 | Not typically agent-relevant for bookkeeping |
| Government fees | Section 900 | Not typically agent-relevant |
| Additional charges | Section 1000-1300 | Anything paid by/to the agent specifically |
| Cash to / from | Final section | The bottom-line settlement amount |

**Commission extraction (ALTA section 700):**
- 701 — Listing side gross commission
- 702 — Buyer side gross commission
- 703 — Total
- 704 — Commission paid at settlement (vs. paid outside)

After identifying which side the agent is on, look for the brokerage split. If the statement shows a line like "Paid to [Brokerage Name]" with a partial amount and another line "Paid to [Agent Name]" with the remainder, that IS the split. If only one line exists and the split is not on the statement, the split has to be applied separately — flag it for the agent to confirm.

## HUD-1 (older form, still common in some states)

Same general structure as ALTA but uses fixed line numbers 100-1400. The form is double-column: Borrower's side (left) and Seller's side (right). Read both columns even if you're the agent for only one side — concessions show as a charge on one side and a credit on the other, so cross-referencing catches transposition errors.

**Commission on HUD-1:**
- Line 700 — Total commission paid
- Line 701 — Listing side
- Line 702 — Selling side (which is the buyer side, terminologically confusing)
- Line 703 — Total
- Line 704 — Commission paid outside of closing (rare)

## Closing Disclosure (CD)

The federal TRID form. Buyer-side only — sellers get a Seller's CD or use the ALTA. Five pages. For agent bookkeeping:

- Page 2, Section H — "Other" — sometimes contains the agent's commission line
- Page 2, Section I or J — Total Closing Costs — for the buyer-side agent, this is the cash-to-close context
- Page 2, "Real Estate Commission" line — agent commission, if itemized

The CD doesn't always itemize the agent's commission in the way the ALTA does — listing-side commissions are typically shown on the Seller's CD or the ALTA Settlement Statement, not the buyer's CD. If the agent is buyer-side, ask whether they have the ALTA in addition to the CD; the ALTA has more detail.

## Concessions: the most-mis-extracted line

Concessions show up under different names depending on the form and the state:

- "Seller credit to buyer"
- "Seller-paid closing costs"
- "Repair credit"
- "Inspection credit"
- "Closing cost concession"

All of these are the same thing economically (seller pays a portion of the buyer's closing costs), but they're recorded differently:

- A "credit to buyer" appears as a credit on the buyer's side and a charge on the seller's side.
- A "repair credit" specifically is sometimes recorded outside the commission flow.

**Extraction rule:** when categorizing concessions in the output, always include the dollar amount AND the precise label from the statement. Don't normalize the label — the bookkeeper / CPA needs to see what the document actually said.

## Brokerage split: the agent has to confirm

The settlement statement shows what was PAID, not how the brokerage's internal split works. The agent's net commission depends on:

1. The commission paid at the closing table (visible on the statement).
2. The brokerage's split percentage (in the brokerage agreement, NOT on the settlement statement).
3. Any monthly desk fee, cap status, or transaction-fee deduction (also not on the statement).

The extraction output computes a "net commission" only if the split percentage is filed in `profile.md` or supplied by the agent. Otherwise it shows "Gross commission to agent's side: $X. Net commission depends on your brokerage split — apply your agreement."

## Referral fees

If the agent paid a referral fee out of their side, the statement may show:
- A line for the gross commission to their side
- A separate line for "Paid to [Referring Brokerage]" with the referral amount

Extract the referral fee separately so the agent's books show gross-minus-referral-minus-brokerage-split-equals-net.

## Common ambiguities (flag every time)

- The brokerage split is not on the statement → flag "split applied per agreement, not statement"
- The "concession" is labeled inconsistently between the buyer and seller side of the same document → flag the inconsistency for the bookkeeper
- The statement shows the agent's commission going to one entity but the brokerage's records show a different recipient → flag, don't reconcile
- The transaction has dual agency or designated agency → extraction needs to know which side the agent represented for the commission categorization
- The agent is on a team and the team has its own internal split → not on the statement; the team's accounting rules govern; flag

When in doubt, extract verbatim and flag for the human to interpret. We're a drafter; the bookkeeper and the CPA decide.
