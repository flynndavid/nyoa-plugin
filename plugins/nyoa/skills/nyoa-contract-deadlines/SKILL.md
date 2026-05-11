---
name: nyoa-contract-deadlines
description: Extract every dated obligation from an executed purchase contract and turn it into a tracked deadline schedule — earnest money, inspection windows, appraisal, financing contingency, title objection, walk-through, closing. Use this skill the day after a contract is executed (buyer-side or listing-side), when the agent uploads a contract PDF, or when they ask "what dates do I owe on this deal?" Triggers on "contract deadlines", "extract deadlines from this contract", "what dates do I need to track on [address]", "executed contract for [address]", "transaction timeline", "contingency dates", "after the contract is signed what's next".
---

# Contract Deadlines

Read an executed purchase contract and produce a structured deadline schedule the agent can actually act on — every dated obligation, who owns it, what happens if it slips, and when to send reminders. Then write it into the listing's workspace folder so it's available to every other NYOA skill (weekly review, pipeline, buyer/seller comms) for the rest of the deal.

Missed deadlines are how transactions blow up. This is the lowest-glamour, highest-stakes administrative job an agent does — pairing a first-pass extraction with a human's final review is where real hours come back.

## When this skill triggers

- "Extract deadlines from this contract"
- "What dates do I owe on [address]?"
- "Contract is signed, what's next"
- "Transaction timeline for [address]"
- "Set up the deal calendar for [address]"
- Agent uploads an executed contract PDF
- "Pull the contingency dates out of this"
- "Inspection and financing dates for the [address] deal"

## Inputs you need

Required:
- **An executed contract** — PDF upload, pasted text, or the agent's description of the key dates
- **Listing slug or address** — so we know where to file the schedule (we'll check `nyoa-workspace/listings/<slug>/` first)
- **Side** — listing side, buyer side, or dual (changes who "owns" each deadline)

Optional but improves output:
- Contract effective date (binding date) — if not on the cover sheet, we use the latest signature date
- Time zone for deadline cutoffs (defaults to the listing's market time zone if filed in `property.md`)
- Any addenda or riders included in the executed packet
- Known waivers (e.g., "buyer waived inspection contingency") — these change the consequence column

If a date is ambiguous in the contract (e.g., "10 business days from effective date" without an explicit weekend/holiday calendar), flag it for the agent to verify rather than guessing.

## Workflow

### Capability requirements

Read `nyoa-context/connectors.md`. If the agent has a stated preference for a capability, use the corresponding connector. If multiple connectors are available for a capability and no preference is set, ask which to use. If none are available, fall back to file-only behavior.

- **calendar** (`google-workspace` or equivalent): When available, NYOA offers to push every extracted deadline as a calendar event plus its reminder offsets. Always confirm the full list with the agent before pushing — never auto-create. Falls back to inline + `nyoa-workspace/calendar.md` only.
- **docs** (`google-workspace` or `notion`): When available, NYOA offers to also save the schedule to cloud storage alongside the local workspace write-through.
- No other external capabilities required — extraction itself is local.

1. **Resolve the listing.** If the agent named an address, slug it (lowercase, dash-separated). Check `nyoa-workspace/listings/<slug>/property.md` for the address, contract date, and close date — if those are blank, ask the agent to confirm before parsing.
2. **Parse the contract.** Walk through it section by section. Pull every clause that has a deadline, a number-of-days reference, or a "by [date]" trigger. Don't skip riders or addenda.
3. **Resolve relative dates.** For "X days from effective date", compute the calendar date. State business-day vs. calendar-day explicitly (this varies by state — if the contract is silent, flag for the agent).
4. **Build the schedule table.** One row per deadline with: name, date, days from today, owner, consequence-if-missed, suggested reminder offsets (e.g., 7 / 3 / 1 days out).
5. **Write to workspace.** Save the full schedule to `nyoa-workspace/listings/<slug>/deadlines.md`. Append each deadline as a dated entry in `nyoa-workspace/calendar.md` under the right week section. Append the highest-stakes ones (earnest money, financing, closing) to `nyoa-workspace/tasks.md` as todos.
6. **Refresh pipeline.** Bump the listing's last-activity stamp in `pipeline.md` to today and note "contract dates scheduled".
7. **Run the compliance pass.**
8. **Deliver inline as Markdown.**

## Compliance pass (mandatory before delivering)

- **Never assert a date as authoritative.** The contract is the authoritative source; this output is a first-pass reading. The footer says so plainly.
- **Flag ambiguity, don't guess.** If a clause says "ten days" without specifying business vs. calendar days, mark the date as `(verify — business vs. calendar days unclear)`.
- **Never compute past a state-specific holiday rule we don't know.** If a deadline lands on a weekend or recognized holiday and the contract doesn't specify rollover, flag it.
- **Don't invent contingencies.** Only extract what's actually in the document. If the agent says "we waived inspection", honor that and note it; don't infer waivers from absence.
- **Don't drop legal language.** When recording a consequence, paraphrase ("buyer may lose earnest money") rather than quoting boilerplate — but if the contract uses a specific term of art ("time is of the essence", "specific performance"), keep that term in the entry.
- **NYOA terminology in any quoted contract language.** If a clause refers to "master bedroom" / "master bath", substitute "primary bedroom" / "primary bath" in any consumer-facing version of the schedule. Keep the original phrasing in the per-deadline detail if it matters for legal interpretation, but flag the substitution explicitly so the agent knows which doc says what.

Footer to include verbatim on every output:

> The executed contract is the authoritative source. This schedule is a first pass for your eyes — every date here needs to be checked against the contract itself, your state's business-day and holiday rules, and the time-of-day cutoffs imposed by escrow, title, and your lender. Treat anything flagged as "verify" as blocking until a human (you, your TC, your broker, or your closing attorney) signs off.

## Workspace integration

If `nyoa-workspace/listings/<slug>/` exists:

- **Write `deadlines.md`** — full schedule with table + per-deadline detail. If the file already exists (re-extraction after an amendment), don't overwrite. Append a new dated section: `## Updated YYYY-MM-DD — <reason>` and keep the prior version above for audit.
- **Append to `calendar.md`** — each deadline goes under the correct week section (`## This week` / `## Next week` / `## Later`) in the format the calendar template expects: `- HH:MM — <deadline name> — listings/<slug>/ — <link or location>`. For deadlines without a clock time, use `09:00` as the default.
- **Append to `tasks.md`** — the top-3 critical ones only: earnest money, financing commitment, closing. Don't flood tasks with every reminder.
- **Update `pipeline.md`** — bump the listing's last-activity row. If the listing was in `Active`, move it to `Under Contract` (ask the agent to confirm if it's a stage change).

If the workspace doesn't exist or the listing folder hasn't been created yet, ask: "Want me to scaffold `listings/<slug>/` first so this schedule and future deal docs stay together?" Defer to `/nyoa-listing-add` if yes; deliver inline-only if no.

## Output format

Single Markdown response with these sections in order:

1. **Header** — listing address, contract effective date, side (listing/buyer/dual), close date.
2. **Deadline Table** — one row per deadline.

   | Deadline | Date | Days out | Owner | If missed | Reminders |
   |---|---|---|---|---|---|

3. **Per-deadline detail** — for each row in the table, a 2-3 sentence note on what the obligation actually is and any gotchas (e.g., "Buyer must deliver earnest money to escrow by 5pm. Many local escrow companies close at 4pm — confirm cutoff with the title company.").
4. **Calendar export** — flat list in the format the calendar template uses, so the agent can paste into any external calendar manually if needed.
5. **Open items / flags** — anything the agent should clarify before treating the schedule as final (ambiguous business-days language, missing addenda, waived contingencies to confirm).
6. **Connector offer** — if Google Calendar is wired up, the offer to push events; otherwise skip.
7. **Compliance footer** (verbatim, as written above).

End with: "Saved to nyoa-workspace/listings/<slug>/deadlines.md and calendar.md." If write-through didn't run (no workspace), say so instead: "Workspace not detected — schedule delivered inline only."

## Shared context

Reads from `nyoa-context/`:
- `connectors.md` — to know whether Google Calendar offer applies.

Reads from `nyoa-workspace/`:
- `listings/<slug>/property.md` — address, contract date, close date, time zone.
- `listings/<slug>/deadlines.md` — if a prior schedule exists (amendments).
- `pipeline.md` — current stage.

Writes to `nyoa-workspace/`:
- `listings/<slug>/deadlines.md` — primary writer.
- `calendar.md` — append.
- `tasks.md` — append (top-3 critical deadlines only).
- `pipeline.md` — refresh last-activity stamp; offer stage change.

## Reference files

- `references/standard-deadline-taxonomy.md` — the deadline names NYOA uses across markets (earnest money, inspection period, financing contingency, etc.) so other skills (weekly review, pipeline) can parse `deadlines.md` predictably.
