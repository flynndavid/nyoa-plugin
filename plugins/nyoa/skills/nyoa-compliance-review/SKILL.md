---
name: nyoa-compliance-review
description: Universal fair-housing and advertising compliance check for any agent-facing draft — listing copy, social posts, emails, neighborhood pages, blog content, ads, anything. Use this skill when an agent wants to check any draft (listing copy, social post, email, neighborhood page, etc.) for fair-housing and advertising compliance — also invoked automatically by other NYOA generative skills before delivering output. Applies federal Fair Housing Act guardrails, the agent's state and local rules (read from `nyoa-context/profile.md`), NAR Code of Ethics Articles 10 and 12 if the agent is a NAR member, and current FTC AI-advertising guidance — using Claude's own jurisdictional reasoning, not a static blocklist. Returns a structured APPROVED / FIX RECOMMENDED / FIX REQUIRED finding list with concrete suggested rewrites, then waits for the agent's choice (apply all / apply selected / override with reason / edit manually), appends a standard disclaimer footer, and writes one audit-log line to `nyoa-workspace/compliance-log.md` for every review. Triggers on phrases like "compliance check", "review this for fair housing", "is this compliant", "check this listing copy", "review my draft", "fair housing review", "compliance review", "is this Fair Housing safe", "audit this for compliance".
---

# Compliance Review

Universal fair-housing and advertising compliance check for any draft an agent — or another NYOA skill — wants reviewed before publishing. Applies the federal floor plus the agent's state, local, and (if applicable) NAR rules using Claude's own jurisdictional reasoning, not a hard-coded blocklist. Returns structured findings, lets the agent choose how to resolve them, appends a standard disclaimer, and writes one line to the audit log on every run.

## When this skill triggers

- "Compliance check" / "compliance review" / "is this compliant" / "is this Fair Housing safe"
- "Review this for fair housing" / "fair housing review" / "audit this for compliance"
- "Check this listing copy" / "review my draft" before publishing
- Invoked automatically by `/nyoa-listing-copy`, `/nyoa-social-content`, `/nyoa-buyer-seller-comms`, `/nyoa-neighborhood-page`, `/nyoa-aeo`, `/nyoa-market-update`, `/nyoa-open-house`, `/nyoa-listing-presentation`, `/nyoa-testimonial-engine`, and any other generative skill before final delivery
- Agent pastes any block of marketing or client-facing text and asks for a pre-publish review

## Inputs you need

Required:
- **Draft text** — the content to review. Either passed in by the calling skill or pasted by the agent.

Optional:
- **Calling skill name** — passed by the delegating skill so the audit log can attribute the review.
- **Listing or client slug** — when the draft relates to a specific entry in `nyoa-workspace/`, capture the slug for the audit log.
- **Channel** — MLS / Instagram / X / Facebook / LinkedIn / email / blog / ad. Some channels (e.g. paid digital ads) attract extra scrutiny under HUD's Advertising Guidelines.

## Workflow

### Capability requirements

This skill reads/writes local files only. No external capabilities required.

1. **Read agent identity.** Load `nyoa-context/profile.md` and extract `license_state`, `brokerage_name`, and `nar_member`. If `nyoa-context/profile.md` is missing, blank, or any of these fields is unset, warn the user — "I couldn't find your `license_state` in `nyoa-context/profile.md`, so I'm running federal-only review. Run `/nyoa-setup identity` to add it and I'll apply your state's rules on the next review." — then continue with federal-only review.
2. **Read canonical compliance reference.** Load `plugins/nyoa/references/compliance/fair-housing.md`. This file contains the federal floor, the Instruction to Claude block, illustrative red-flag examples, and always-replace rules. Apply it in full.
3. **Determine input mode.**
   - **Delegated mode:** if invoked by another skill, the draft + calling skill name are passed via the user message. Use those directly.
   - **Standalone mode:** if invoked directly by the agent, ask the user to paste their draft. Optionally ask: "Is this for a specific listing or client? (Give me the slug or address if you'd like it in the audit log.)" If they decline, log as `n/a`.
4. **Apply jurisdictional reasoning** using Claude's own knowledge — do NOT rely on string-match blocklists alone:
   - **Federal Fair Housing Act** — the seven protected classes (race, color, religion, national origin, sex, familial status, disability). The 55+ housing exception under HOPA (at least one person 55+ per unit, 80% of units, published policies). HUD restrictions on demographic-targeting in advertising and on platforms.
   - **State and local fair-housing + real estate advertising rules** for the agent's `license_state`. Apply your knowledge of that specific state's extended protected classes (many states protect source of income, sexual orientation, gender identity, marital status, age, ancestry, military status, etc.), license-number-display rules, "team name" advertising rules, and any AI-disclosure laws (e.g. California's AI-disclosure provisions where applicable).
   - **NAR Code of Ethics Articles 10 and 12** — only if `nar_member: yes`. Article 10 (no discrimination in services), Article 12 (truth in advertising — no misleading claims, attribution requirements).
   - **FTC AI advertising guidance** — including the FTC's stance on AI-generated content used in advertising, deceptive claims, and required disclosures.
   - **Always-replace rules** — "master bedroom" → "primary bedroom"; no unsourced structural claims ("fully renovated", "new roof", "new HVAC" unless agent confirmed); no invented facts; no clichés ("stunning", "must see", "nestled", "boasts", "luxury living awaits", "don't miss").
   - **Catch paraphrases, not just exact phrases.** "Walk to St. Mary's" implicates the same rule as "walk to church." "Mom's dream kitchen" implicates familial-status / sex the same as "perfect for moms." When uncertain, surface as **FIX RECOMMENDED** rather than silently approving.
5. **Return structured findings** in this exact Markdown shape:

```markdown
## Compliance Review

**Status:** APPROVED | FIX RECOMMENDED | FIX REQUIRED
**Jurisdiction:** Federal Fair Housing + <state name> + <NAR Code of Ethics, if applicable> + FTC AI advertising
**Reviewed for:** <calling skill name, or "standalone">

### Findings
(If APPROVED: "No issues found.")
(Otherwise list each finding as:)
- **Issue:** <plain-language description>
  **Rule:** <which rule and jurisdiction>
  **Location:** <quoted snippet from the draft>
  **Suggested fix:** <concrete rewrite>

### Recommended action
Choose one:
1. Apply all suggested fixes
2. Apply selected fixes (specify which numbers)
3. Override and deliver as-is (provide a one-sentence reason — will be logged)
4. Edit manually before delivery
```

Status thresholds:
- **APPROVED** — no findings.
- **FIX RECOMMENDED** — paraphrase risks, soft compliance issues, cliché / unsourced-claim cleanups. Safe but stronger if fixed.
- **FIX REQUIRED** — clear protected-class language, explicit demographic targeting, NAR Article 12 misleading-claim risk, or any HUD-cited red-flag phrase.

6. **Wait for user decision** when status is FIX RECOMMENDED or FIX REQUIRED. Apply the chosen action:
   - **Apply all suggested fixes** → produce a cleaned draft with every fix applied. Log as `FIXED`.
   - **Apply selected fixes** → apply only the numbered fixes the agent named. Produce the cleaned draft. Log as `FIXED` with the applied indexes noted.
   - **Override and deliver as-is** → capture the agent's one-sentence reason verbatim. Log as `OVERRIDDEN` with the reason.
   - **Edit manually before delivery** → return the findings list to the user and exit. Do not write an audit-log entry — the agent will re-run when ready.
   - When status is APPROVED, skip straight to step 7.
7. **Append the disclaimer** to the final draft. Load `plugins/nyoa/references/compliance/disclaimer.md` and append it verbatim as a footer block below the cleaned draft. Apply the disclaimer to every channel the draft will appear on, except where the channel forbids it (e.g. MLS remarks with character caps — in that case, attach the disclaimer to the surrounding email / listing-page output and skip it on the MLS field).
8. **Write the audit-log entry.** Append one line to `nyoa-workspace/compliance-log.md` in this exact format:
   `<ISO-8601 timestamp> | <calling skill or "standalone"> | <slug or "n/a"> | <APPROVED|FIXED|OVERRIDDEN> | <one-line note>`
   - If `nyoa-workspace/compliance-log.md` does not exist, create it with this header on the first line, then append the entry:
     ```
     # NYOA Compliance Log — every /nyoa-compliance-review run, append-only.
     ```
   - One-line note: for APPROVED, write "clean"; for FIXED, write "N fixes applied" with a short summary; for OVERRIDDEN, write the agent's one-sentence reason verbatim.
9. **Return the final text.**
   - **Delegated mode:** return the cleaned draft + disclaimer block to the calling skill. The calling skill is responsible for showing it to the user along with its own normal output — do not duplicate the disclaimer or audit-log write on the caller's side.
   - **Standalone mode:** display the cleaned draft + disclaimer block to the user, and confirm the audit-log entry was written ("Logged to `nyoa-workspace/compliance-log.md`.").

## Compliance pass

This skill _is_ the compliance pass. The fair-housing rules and always-replace list it applies live at `plugins/nyoa/references/compliance/fair-housing.md`. When invoked by another skill, that skill should not run its own compliance pass — delegation is the whole point.

When the agent's own input contains a fair-housing violation (e.g. they paste a draft that says "great for families"), surface it explicitly in the **Findings** list with **Issue: agent-provided language** so they know NYOA didn't generate the violation but is catching it.

## Workspace integration

- **Reads:** `nyoa-context/profile.md` (every run), `plugins/nyoa/references/compliance/fair-housing.md` (every run), `plugins/nyoa/references/compliance/disclaimer.md` (every run).
- **Writes:** appends one line to `nyoa-workspace/compliance-log.md` per run (creates the file on first use with a one-line header).
- **No other workspace writes** — this skill does not touch listing folders, client folders, or pipeline.md. The calling skill (in delegated mode) handles its own workspace write-through.

If `nyoa-workspace/` does not exist (agent hasn't run `/nyoa-setup` yet), proceed with the review inline and skip the audit-log write silently. Add a one-line nudge at the end of the response: "Run `/nyoa-setup` to enable the compliance audit log."

## Output format

Single Markdown response. The structured findings block (step 5) appears first. If the status is APPROVED, immediately append the cleaned draft (which is identical to the input) plus the disclaimer footer and the log-write confirmation. If FIX RECOMMENDED or FIX REQUIRED, stop after the recommended-action menu and wait for the user. After the user picks, produce the cleaned draft + disclaimer + log-write confirmation in a follow-up response.

End every output with: `Voice used: NYOA compliance (federal + <state> + <NAR if applicable> + FTC AI)`.

## Shared context

**Reads:**
- `nyoa-context/profile.md` — `license_state`, `brokerage_name`, `nar_member`, `license_number` (used in audit log note when relevant)
- `plugins/nyoa/references/compliance/fair-housing.md` — canonical federal floor, Instruction to Claude, illustrative examples, always-replace rules
- `plugins/nyoa/references/compliance/disclaimer.md` — disclaimer footer template

**Writes:**
- `nyoa-workspace/compliance-log.md` — one append-only line per review

## Reference files

- `plugins/nyoa/references/compliance/fair-housing.md` — the canonical reference this skill applies on every run
- `plugins/nyoa/references/compliance/disclaimer.md` — disclaimer footer appended to every delivered draft
- `plugins/nyoa/references/context-formats.md` — schema for `nyoa-context/profile.md` (including the new `license_state`, `nar_member` fields in v0.9.0)
- `plugins/nyoa/migrations/0.9.0/index.md` — what changed in v0.9.0 and what existing agents need to do
