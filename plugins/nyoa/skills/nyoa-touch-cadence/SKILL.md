---
name: nyoa-touch-cadence
description: Build a 12-month past-client touch cadence — a mix of handwritten notes, drop-by gifts, market updates, anniversary reminders, and one soft referral ask — and turn it into real workspace state by scheduling each month's touch as a dated task and a timeline entry on the client's profile. Use this skill right after a closing, when an agent says "set up the cadence for [client]", or when reviewing how to stay in touch with a past client. Triggers on "touch cadence", "12-month cadence", "stay-in-touch plan", "past-client cadence", "referral nurture", "cadence for [client name]", "set up follow-up plan after closing".
---

# Touch Cadence

A 12-month relationship plan for a single past client, output as a month-by-month table and then written into `nyoa-workspace/` so the cadence becomes scheduled tasks the agent will actually see — not a markdown table that gets lost in their inbox.

Past-client touches are how repeat business and referrals show up two years later. They get skipped because they're not urgent. NYOA fixes that by putting each touch in the workspace's `tasks.md` with a real date, so weekly review and pipeline both surface them.

## When this skill triggers

- "Set up the cadence for [client name]"
- "12-month plan for [client]"
- "Stay-in-touch plan after closing"
- "Past-client cadence for [client]"
- "Referral nurture for [client]"
- "Follow-up plan for the [property] closing"
- Right after `/nyoa-log` records a closing — natural prompt to ask "want me to schedule the 12-month cadence now?"

## Inputs you need

Required:
- **Client slug or name** — we'll look up `nyoa-workspace/clients/<slug>/` to pull the profile.
- **Close date** — anchor for the cadence. If the client has a closing entry in `timeline.md` or a `closed_at` field in `profile.md`, use that; otherwise ask.

Optional but improves output:
- What they bought (or sold) — pulled from `clients/<slug>/profile.md` and `listings/<slug>/property.md` when available.
- Personal context: jobs, kids, hobbies, anything the agent has logged in the timeline. Lets us pick specific touch types.
- Whether the client is introverted (lower drop-by frequency) or extroverted (more in-person).
- Whether the client has already given a referral (front-load the referral ask earlier or skip it).
- A budget cap for the in-person drop-bys ($/year).

If `clients/<slug>/profile.md` doesn't exist, offer to run `/nyoa-client-add` first; this skill works better with a real client record to write into.

## Workflow

### Capability requirements

Read `nyoa-context/connectors.md`. If the agent has a stated preference for a capability, use the corresponding connector. If multiple connectors are available for a capability and no preference is set, ask which to use. If none are available, fall back to file-only behavior.

- **calendar** (`google-workspace` or equivalent): When available, NYOA offers to push every scheduled touch as a recurring or one-off calendar event on the agent's calendar. Always confirm the full list before pushing — never auto-create. Falls back to `nyoa-workspace/tasks.md` + per-client timeline entries only.
- **crm** (`follow-up-boss`, `hubspot`, `salesforce`, or equivalent): When available, NYOA offers to log the cadence to the CRM as a task series tagged to the contact. Falls back to file-only behavior.
- **email** (`google-workspace` or `outlook`): When available and a specific month's touch is an email type, NYOA offers to draft it as the date approaches via `/nyoa-buyer-seller-comms`. This skill doesn't draft the emails itself — it schedules them.

1. **Resolve the client.** Look up `nyoa-workspace/clients/<slug>/profile.md` and `timeline.md`. If the close date isn't on file, ask.
2. **Read their context.** Pull what's already in the timeline — a few names of family members, what they cared about during the search, anything the agent has logged. Don't invent. If the agent has no personal context filed, the cadence stays one notch more generic.
3. **Pick the cadence shape.** Defaults below — adjust based on the inputs. Use the playbook in `references/cadence-playbook.md`.
4. **Build the 12-month table** with: month number, target date (close date + N months), touch type, channel, opener, 1-sentence draft, why-this-touch-now.
5. **Compliance pass.**
6. **Write to workspace.**
7. **Deliver inline as Markdown** plus a confirmation of what was filed.

## Default cadence shape (adjusts to inputs)

The default mix front-loads relationship touches and saves the soft referral ask for month 7+, after the relationship is solid:

| Month | Touch type | Notes |
|---|---|---|
| 1 | Handwritten note ("two weeks in") | The card the agent should have written closing day, with a delay |
| 2 | Drop-by gift, no agenda | Front-porch delivery |
| 3 | Market update email — neighborhood-specific | First useful piece of value |
| 4 | Phone call check-in | First voice contact post-close |
| 5 | Seasonal note or birthday (whichever lands first) | |
| 6 | Six-month retrospective email | "How is the house feeling?" |
| 7 | Soft referral ask | First ask, never earlier than month 6 |
| 8 | Market update | Useful, on-brand |
| 9 | Drop-by + small gift | Reinforces presence |
| 10 | Casual text or phone | No-agenda hello |
| 11 | Anniversary lead-up | Sets up month 12 |
| 12 | 1-year anniversary email | Defer to `nyoa-buyer-seller-comms/assets/templates/home-anniversary.md`, optionally with soft valuation CTA |

The playbook covers variant cadences for:
- Introverted clients (swap drop-bys for emails)
- Cold relationships (skip months 2, 9; double up on market updates)
- High-referral clients (add a month-3 referral ask, more frequent drop-bys 6-12)
- Renter / future-buyer past clients (different anniversary year framing)

## Compliance pass

Before delivering output, delegate to `/nyoa-compliance-review`:

1. Generate the draft per the rest of this skill's workflow.
2. Invoke `/nyoa-compliance-review` with the draft as input and this skill's name (`nyoa-touch-cadence`) as the calling context.
3. If the review returns **APPROVED**, deliver the draft. `/nyoa-compliance-review` appends the disclaimer footer and writes the audit-log entry — do not duplicate.
4. If the review returns **FIX RECOMMENDED** or **FIX REQUIRED**, surface the findings to the user. Apply their chosen action:
   - **Apply all** — use the cleaned draft as the final output.
   - **Apply selected** — apply only the user-chosen fixes.
   - **Override** — capture the user's one-sentence reason; `/nyoa-compliance-review` logs it.
   - **Edit manually** — return the findings to the user and stop; they re-run the skill when ready.
   Then deliver.
5. If the agent's **own input** contained a fair-housing violation, surface it explicitly in your response in addition to letting `/nyoa-compliance-review` catch it.

Canonical rules and jurisdictional reasoning live in `plugins/nyoa/references/compliance/fair-housing.md` (loaded by `/nyoa-compliance-review`). Do not duplicate them here.

Skill-specific guardrails the reviewer should weigh:

- **No protected-class assumptions in any draft opener.** "Hope you and the family…" is out; "Hope this finds you well" is also out (template-speak). Specific or neutral, never demographic.
- **Soft referral ask once.** Never schedule more than one referral ask in 12 months. Repeat asks are how relationships get burned.
- **Real touches only.** If we schedule a "drop-by" but the agent can't actually drive by (out of state, etc.), swap for a mailed gift instead. Ask the agent if any month's touch isn't realistic for their setup.
- **No marketing automation feel.** The cadence is a friendship plan. If a month's draft reads like a CRM template, rewrite it.

Footer to include on the output (verbatim):

> A cadence is a starting plan, not a contract. The most important touch is the one that responds to something specific in the client's life. Adjust any month when something real comes up — a job change, a referral, a family event, a market shift in their neighborhood.

## Workspace integration

If `nyoa-workspace/clients/<slug>/` exists:

- **Append to `clients/<slug>/timeline.md`** under a new section `## Cadence (scheduled)` — one row per month with the target date and touch type. This is read-only history; the actual tasks live elsewhere.
- **Write to `nyoa-workspace/tasks.md`** — append 12 entries, one per month, dated. Each entry references `clients/<slug>/` and names the touch type so the agent can prep it.
- **Refresh `pipeline.md`** — note "12-month cadence scheduled" in the client's row.
- **If the client moves to "Closed" later** — the cadence keeps running. If the cadence completes (month 12 done), `/nyoa-weekly-review` can surface "Jane's cadence completed — start a renewal cadence?"

If the workspace doesn't exist, offer to scaffold it. If the client folder doesn't exist, run `/nyoa-client-add` first.

## Output format

Single Markdown response with these sections:

1. **Header** — client name, close date, cadence shape (default / introverted / cold-relationship / high-referral / renter).
2. **12-month table** — month, target date, touch type, channel, opener, 1-sentence draft, why.
3. **Notes** — anything the agent should personalize (specific dates, names, family details) before the touches land.
4. **Compliance footer** (verbatim).
5. **Workspace confirmation** — what was filed.

End with: "Cadence saved. 12 tasks scheduled in nyoa-workspace/tasks.md and noted in clients/<slug>/timeline.md."

The disclaimer footer is appended automatically by `/nyoa-compliance-review` — do not include it in this skill's own output template.

## Shared context

Reads from `nyoa-context/`:
- `profile.md` — agent identity for email signatures referenced by future touches.
- `voice.md` — tone resolution.
- `connectors.md` — capability branching.

Reads from `nyoa-workspace/`:
- `clients/<slug>/profile.md` — what they bought, personal context.
- `clients/<slug>/timeline.md` — closing date, anything already filed.
- `listings/<slug>/property.md` — the property they bought (for the anniversary touches).

Writes to `nyoa-workspace/`:
- `clients/<slug>/timeline.md` — appends a `## Cadence (scheduled)` section.
- `tasks.md` — appends 12 dated tasks.
- `pipeline.md` — refreshes the client's row.

## Reference files

- `references/cadence-playbook.md` — default shape, plus variants for introverted, cold, high-referral, and renter clients.
