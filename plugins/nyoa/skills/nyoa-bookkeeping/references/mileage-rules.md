# Mileage Rules (IRS basics)

A reference for `/nyoa-bookkeeping mileage` to classify trips. NYOA categorizes; the CPA decides whether any specific trip is deductible.

## What the IRS expects

Business mileage requires a **contemporaneous record**. Per Treasury Reg. §1.274-5T, the record should be made at or near the time of the use, and should include:
- Date
- Destination
- Business purpose
- Miles driven

A calendar-derived log is an approximation, not a contemporaneous record. It's a starting point for what the agent should track in real time going forward — and the skill says so in the footer.

## Trip categories (for the log's "Purpose" column)

| Purpose | What counts | What doesn't |
|---|---|---|
| **Showing** | Drive to and from a property showing | Drive from a showing to home if home is not the office |
| **Listing appointment** | Drive to a listing-appointment property | Drive from a listing appointment back to lunch (personal stop breaks the trip) |
| **Closing** | Drive to title company / attorney's office for a closing | Personal errands en route |
| **Open house** | Drive to and from an open house | Stops for coffee outside the trip |
| **Vendor meeting** | Drive to meet a lender, title rep, photographer, contractor for a specific deal | Drive to a general networking event with no specific business deliverable |
| **Property inspection** | Drive to attend the inspection on behalf of a buyer or seller | n/a |
| **Marketing trip** | Drive to a property specifically to shoot content, drop a sign, etc. | n/a |
| **Office trip** | Drive to the brokerage office | Drive to brokerage office on a non-business day for an event |
| **Training / CE** | Drive to a CE class or industry conference | Drive to a personal-development event with no business connection |
| **Other (flag)** | Anything that has a business purpose but doesn't fit the above | Anything where the business purpose is unclear |

## The home-office interaction

If the agent has a qualified home office (per IRS rules — exclusive and regular business use, principal place of business), every business trip from home is generally deductible.

If the agent does NOT have a qualified home office, trips from home to the first business stop of the day (and from the last business stop back to home) are typically considered commuting, which is NOT deductible.

The skill doesn't make the home-office determination — the CPA does. But the skill DOES surface this in the output: "If you don't have a qualified home office, the first and last legs of each day may be commute mileage. Verify with your CPA."

## Standard mileage rate vs. actual expense method

The IRS standard mileage rate for 2026 is published by the IRS each year (no date-specific number written here — it changes annually, and a hardcoded number rots). The skill records miles only; the rate is applied by the bookkeeper or accounting system.

If the agent uses the actual expense method instead of standard mileage, they're recording gas, maintenance, insurance, depreciation separately under the `Vehicle` expense category. The skill doesn't double-count — if `Vehicle` already has gas line items for the month, surface that as a note: "You have gas in Vehicle expenses this month. If you're claiming standard mileage, that may be a double-deduction. Verify with your CPA which method you're on."

## Distance estimation

When no specific distance is supplied:
- **In-market trip** (within the agent's market area per `profile.md`): default 12 miles round-trip.
- **Cross-market trip** (different market or out of metro): ask the agent for the distance. Don't estimate beyond 25 miles without confirmation.
- **Office trip**: if the agent's office address is in `profile.md`, compute from office; otherwise default to 8 miles round-trip from a generic in-market base.

These are placeholder estimates that get the log started. The log's accuracy depends on the agent supplying real distances for trips that matter. The output always says "estimated" on a line that used a default vs. "supplied" on a line where the agent provided the distance.

## What NEVER counts as business mileage

- Commuting from home to the office (if no qualified home office)
- Personal trips even if they passed near a property
- Mixed-purpose trips where the business purpose was incidental (a drive to a vacation that briefly stopped at a property)
- A trip to drop off a personal item with a client (a wedding gift to a past client, etc.)
- A trip the agent took in a vehicle they don't claim — only the vehicle the agent uses for business gets mileage logged

If a trip in the calendar matches one of these, flag it and exclude it from the log's totals.

## Output flagging

Every entry in the output table has one of three confidence levels:

- **Confirmed** — agent supplied date, destination, purpose, and miles.
- **Estimated** — date/destination/purpose are from the calendar; miles defaulted from the rules above.
- **Flagged** — date/destination clear, but business purpose is ambiguous OR miles are uncertain (out-of-market without a supplied distance).

The bookkeeper email summary always shows the confirmed/estimated/flagged counts so the human knows how much of the log they need to sanity-check.

## Real-time tracking apps (recommended)

In the footer of the mileage output, NYOA recommends the agent use a real-time mileage app (MileIQ, Everlance, Stride, etc.) to capture contemporaneous records. A calendar-derived log reconciled monthly against an app is the gold standard. The app catches the trips that didn't make it to the calendar; the calendar catches the trips the app misclassified.
