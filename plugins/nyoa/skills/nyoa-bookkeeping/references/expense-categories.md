# Default Expense Categories

The 11 categories `/nyoa-bookkeeping receipts` uses by default. Agents can override this list via `nyoa-context/feedback.md` under a `## Bookkeeping categories` section — any override there wins.

The skill **categorizes**; the agent's CPA **decides deductibility**. None of these notes constitute tax advice.

## Marketing

What goes here:
- Postcards, flyers, yard signs, sign restocks
- Promotional swag (branded merch, closing gifts that double as marketing)
- Paid ads (Facebook, Google, NextDoor, Instagram)
- SEO / website services
- Listing-launch marketing collateral (photography for marketing, drone footage)

Edge case: a "closing gift" can land in either **Marketing** or **Client Gifts** depending on the agent's policy. Default to **Client Gifts** if the gift is for a specific past client; **Marketing** if it's for a target audience.

## Dues & Fees

What goes here:
- NAR membership
- Local board / association dues
- MLS quarterly fees
- E&O insurance
- License renewal fees
- Brokerage desk fee (if itemized separately from split)
- Lockbox key fees

What does NOT go here: brokerage commission splits (those are a deduction at the source, not an expense line).

## Vehicle

What goes here:
- Gas / charging (when not on the mileage log)
- Parking, tolls, valet for business trips
- Vehicle maintenance pro-rated for business use (the CPA decides the ratio)
- Car washes (if vehicle is used for business)

What does NOT go here: mileage. Mileage is its own category, computed via the `mileage` mode of this skill.

## Professional Development

What goes here:
- Industry conferences (registration, materials)
- CE courses
- Coaching, mentorship programs
- Books, training videos
- Designation programs (CRS, ABR, GRI)

## Client Gifts

What goes here:
- Closing gifts for specific past clients
- Anniversary gifts (one-year card-and-token)
- Holiday baskets / drop-by gifts during the touch cadence

Note: many states cap the value of a client gift the agent can give (anti-inducement rules). The skill doesn't enforce caps — that's the agent's compliance officer's job.

## Office

What goes here:
- Office supplies (paper, ink, printer, laminator)
- Postage, shipping for transaction documents
- Office furniture (if pro-rated)
- Co-working / desk rental
- Business cell phone (or pro-rated portion)
- Business cards

## Meals

What goes here:
- Meals with referral partners
- Meals during business travel
- Closing celebration meals
- Vendor / lender lunch meetings

**Flag automatically:** Meals are typically 50% deductible (per IRC §274(n)) — the skill flags this in the categorized output so the bookkeeper applies the right rule. There are exceptions (some travel meals, some entertainment-vs-meal distinctions); the CPA decides.

## Travel

What goes here:
- Hotels for business travel (conferences, brokerage retreats)
- Flights to industry events
- Rental cars on business trips
- Travel-related meals get flagged with the 50% indicator

## Photography & Staging

What goes here:
- Listing photography
- Drone photography
- 3D matterport tours
- Virtual staging software
- Physical staging (rental, decor)

These are typically reimbursable by the seller per the listing agreement; the CPA decides whether each line is an out-of-pocket business expense or a pass-through.

## Software & Subscriptions

What goes here:
- CRM subscription
- Transaction-management software (Dotloop, SkySlope)
- Email service provider
- Canva, Adobe, design tools
- AI tools (Claude, ChatGPT, etc.)
- Cloud storage that the business actually uses

## Other (flag for review)

What goes here: anything that doesn't fit cleanly. The bookkeeper email always lists each "Other" line item separately so the bookkeeper can suggest the right category.

## Common ambiguities (always flag)

- Closing gift → Marketing or Client Gifts (see above).
- A piece of equipment used for both business and personal (printer, monitor, camera) → typically Office at a pro-rated percentage; CPA decides.
- A vendor lunch that doubled as a referral conversation → Meals (with 50% flag) is the default; some agents categorize as Marketing if the lunch was net-new outreach.
- Home-office space costs (rent, utilities pro-rated) → typically NOT a NYOA line. Home-office is a separate IRS calculation that the CPA handles directly.

## Overriding the category list

If the agent's brokerage uses different category names (some brokerages have ~25 categories with sub-codes), the agent files an override in `nyoa-context/feedback.md`:

```markdown
## Bookkeeping categories
- Marketing → "MKT"
- Dues & Fees → split into "Dues" and "Compliance"
- (etc.)
```

The skill reads the override and uses the agent's labels in the output. Surface the applied overrides at the top of the output ("Using agent's brokerage category list").
