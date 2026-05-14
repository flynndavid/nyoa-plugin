---
name: nyoa-setup
description: >
  Guided onboarding and workspace management for NYOA. Interviews a real estate agent about their
  business, voice, pipeline, and tools, then populates nyoa-context/ and scaffolds nyoa-workspace/
  so every other NYOA skill works immediately. Supports modes for resuming a partial setup,
  migrating from v0.5.x, or updating a single context area. Use this skill when an agent says
  "set me up", "onboard me", "help me get started", "first time using this", "build my profile",
  "build my workspace", or when nyoa-context/ does not yet exist. Triggers on phrases like
  "setup", "onboarding", "get started", "new agent", "update my voice", "update my profile",
  "migrate to v0.6", or "resume setup". Accepts modes via $ARGUMENTS including resume, migrate,
  workspace, identity, voice, proofs, competitors, book, templates, and connectors.
---

# NYOA Setup

Get an agent from zero to a fully-populated NYOA workspace in one session — or pick up exactly where they left off. After this skill runs, every other NYOA skill has the context it needs and the agent has a real operating system on disk. In v0.6, the workspace is anchored by `nyoa-context/_meta.json`, which tracks schema version and setup progress so interrupted sessions can resume and stale workspaces can be upgraded.

## When this skill triggers

- "Set me up" / "onboard me" / "help me get started"
- "First time using NYOA" / "build my profile" / "build my workspace"
- Agent runs any NYOA skill and `nyoa-context/profile.md` does not exist (offer to run setup first)
- "Resume setup" / "continue where I left off"
- "Migrate to v0.6" / "upgrade my workspace" / "update to new version"
- "Update my identity" / "redo my voice" / "add more testimonials" (routes to per-round modes)
- Phrases: "setup", "onboarding", "get started", "new agent", "update my profile"

## Inputs you need

Nothing required up front. The skill conducts an interview. Skip any round the agent doesn't want to answer — partial population is fine; the workspace fills in over time.

**Optional argument:** `/nyoa-setup <mode>` — see the Mode Dispatch table in the Workflow section.

## Workflow

### Mode dispatch (`$ARGUMENTS`)

When invoked as `/nyoa-setup <mode>`, dispatch immediately to the corresponding sub-workflow. When invoked with no arguments, run the default state-detection path below.

| Mode | Action |
|------|--------|
| _(no args)_ | Detect state → full interview or resume prompt |
| `resume` | Read `_meta.json.setup.setup_last_round_completed` → start from that round + 1 |
| `migrate` | Run the v0.5.x → v0.9.0 migration sub-workflow (see below) |
| `workspace` | Run Round 1 only (workspace detection / confirmation) |
| `identity` | Run Round 2 only (business identity → `profile.md`) |
| `voice` | Run Round 3 only (voice preferences → `voice.md`) |
| `proofs` | Run Round 4 only (testimonials / proof → `proofs.md`) |
| `competitors` | Run Round 5 only (competitor research → `competitors.md`) |
| `book` | Run Round 6 only (pipeline snapshot) |
| `templates` | Run Round 7 only (template import → `nyoa-workspace/templates/`) |
| `connectors` | Round 8 — delegate immediately to `/nyoa-connect` |
| `tools` | Alias for `connectors` |

For any single-round mode: run that round, save the result, increment `setup_last_round_completed` only if the round number is higher than the current value (don't regress), then exit. Do not run the full 8-round flow.

### Capability requirements

This skill uses no external capabilities. It writes local files only (no email, calendar, CRM, or MCP connectors required).

### 1. Default state detection (no args)

Before asking anything, check what already exists:

1. **`nyoa-context/_meta.json` exists with `schema_version: "0.9.0"`** → This is a current workspace.
   - If `setup.setup_complete` is `true`: "Your NYOA workspace is fully set up. Use `/nyoa-setup <mode>` to update any section (e.g., `/nyoa-setup voice`). Or say 'go' to review what's there."
   - If `setup.setup_complete` is `false`: "You're partway through setup (last completed: Round N). Say 'resume' or run `/nyoa-setup resume` to continue."

2. **`_meta.json` is missing but `nyoa-context/profile.md` exists** → v0.5.x workspace.
   - "I found an existing v0.5.x workspace. Run `/nyoa-setup migrate` to upgrade it to v0.9.0, or I can do that now — it's non-destructive and takes under a minute. Which would you prefer?"

3. **Neither exists** → First run. Proceed to Round 1 (workspace confirmation).

### 2. Interview — 8 rounds

Ask one round at a time. Keep questions tight. Confirm answers as you go. Auto-save after each round: update `_meta.json` with the incremented `setup_last_round_completed` immediately after the round's files are written, so an interrupted session is never lost.

---

#### Round 1 — Workspace (writes `nyoa-context/_meta.json`)

**Goal:** confirm the workspace location and create `_meta.json` if it doesn't exist.

- Tell the agent: "I'll set up your NYOA workspace in this folder: `[cwd]`. Is that right? (You can say 'change' to pick a different folder, but the local backend always uses your current working directory — the folder you have open when you run NYOA skills.)"
- If the agent says "change": explain that the workspace path is always the current working directory in v0.6. They need to re-open their terminal / editor in the target folder, then run `/nyoa-setup` again. Exit gracefully.
- If confirmed (default): write `nyoa-context/_meta.json`:
  ```json
  {
    "schema_version": "0.9.0",
    "installed_at": "<today YYYY-MM-DD>",
    "setup": {
      "setup_complete": false,
      "setup_last_round_completed": 1,
      "setup_completed_at": null
    },
    "workspace": {
      "backend": "local",
      "root_path": "."
    },
    "agent": {
      "name": null,
      "brokerage": null,
      "license_state": null,
      "nar_member": null
    }
  }
  ```
- Create `nyoa-context/` directory if it doesn't exist. Confirm: "Workspace anchored at `[cwd]/nyoa-context/`."

---

#### Round 2 — Identity (writes `nyoa-context/profile.md`, updates `_meta.json`)

> Quick note before we start: these answers — especially your license state — determine which jurisdiction `/nyoa-compliance-review` applies when reviewing your output.

Ask these in order. Group the licensing questions together at the end so it flows naturally:

- Full name (as it appears in marketing)
- Years in real estate
- Markets you serve (cities, neighborhoods, zip codes)
- Service types (buyer / seller / investor / luxury / first-time / relocation / commercial / leasing)
- Ideal client (1–2 sentences)
- Top 2–3 differentiators (what makes you different from other agents in your market)

**Licensing & affiliation** (ask as one group):
- **License state** (REQUIRED — two-letter US state code, e.g. `TN`, `CA`, `NY`). Tell the agent: "This is the only required field — it tells `/nyoa-compliance-review` which state rules to apply on top of federal fair-housing."
- License number (optional)
- Brokerage / team name
- Brokerage license number (optional)
- NAR member? (yes / no — affects whether NAR Code of Ethics gets applied to compliance review)

Write `nyoa-context/profile.md` with this structure (omit any optional field the agent skipped):

```markdown
# Agent Profile

- Name: <full name>
- Years in real estate: <N>
- Markets served: <cities / neighborhoods / zip codes>
- Service types: <list>
- Ideal client: <1–2 sentences>
- Differentiators:
  - <one>
  - <two>
  - <three>

## Licensing & affiliation

- License state: <two-letter code>
- License number: <number or "—">
- Brokerage: <name>
- Brokerage license: <number or "—">
- NAR member: <yes / no>
```

After saving `profile.md`, update `_meta.json`: set `agent.name`, `agent.brokerage`, `agent.license_state`, and `agent.nar_member` from the answers above, and set `setup.setup_last_round_completed: 2`.

If the agent declines to provide a `license_state`, note it in your save confirmation: "Saved — but no license state on file. `/nyoa-compliance-review` will fall back to federal-only review until you set one. Run `/nyoa-setup identity` later to add it."

---

#### Round 3 — Voice (writes `nyoa-context/voice.md`)

- Pick a tone: warm + conversational / professional + polished / bold + direct / data-driven analyst / luxury concierge / other
- Paste 2–3 examples of your own writing (a past listing description, a recent email, a social post). NYOA will use these to learn your voice.
- Words/phrases you love
- Words/phrases you avoid ("nestled", "boasts", "must-see" are blocked house-wide already)

After saving `voice.md`, update `_meta.json`: set `setup.setup_last_round_completed: 3`.

---

#### Round 4 — Proof (writes `nyoa-context/proofs.md`)

- Top 3 testimonials (paste them; or paste links and we'll fetch)
- Awards / designations / certifications
- Stats you're proud of (e.g., "150 homes sold in East Nashville since 2018")

After saving `proofs.md`, update `_meta.json`: set `setup.setup_last_round_completed: 4`.

---

#### Round 5 — Competitors (writes `nyoa-context/competitors.md`)

- Top 3 agents/teams you compete with by name (so AEO head-to-head content can be sharpened later)
- Optional: their websites

After saving `competitors.md`, update `_meta.json`: set `setup.setup_last_round_completed: 5`.

---

#### Round 6 — Book (pipeline snapshot; writes `nyoa-workspace/pipeline.md` + scaffolds folders)

For each currently-active client or listing, capture:

- Type: buyer / seller / listing / closed (last 12 months)
- Name (or address for listings)
- Stage: lead / active / under-contract / closed
- Last activity (rough date is fine)
- Next step

For every entry: scaffold the matching folder from `plugins/nyoa/assets/workspace-template/clients/_template/` or `listings/_template/`, pre-fill what was just shared, and add a row to `pipeline.md` pointing at the folder. Pipeline rows follow the format: `[Name](clients/<slug>/) — buyer — last activity YYYY-MM-DD — next: <action> by YYYY-MM-DD`.

After saving, update `_meta.json`: set `setup.setup_last_round_completed: 6`.

---

#### Round 7 — Templates (optional; writes `nyoa-workspace/templates/`)

- Do you have go-to email templates you reuse? (intro emails, open-house follow-ups). Paste them; we'll save them under `templates/`.
- Skip if none — the workspace ships with starter templates from `plugins/nyoa/assets/workspace-template/templates/`.

After saving (or skipping), update `_meta.json`: set `setup.setup_last_round_completed: 7`.

---

#### Round 8 — Connectors (delegates to `/nyoa-connect`)

- Briefly: "Which of these do you use day-to-day: Gmail, Google Calendar, Google Drive / Dropbox, DocuSign, Twilio (SMS), a CRM (Follow Up Boss / HubSpot / Salesforce / kvCORE / Sierra), an MLS portal?"
- Tell the agent: "Run `/nyoa-connect` next and I'll detect what's wired up and write `nyoa-context/connectors.md` with your connector state."
- Update `_meta.json`: set `setup.setup_last_round_completed: 8`, `setup.setup_complete: true`, `setup.setup_completed_at: <today YYYY-MM-DD>`.

---

### 3. Scaffold the workspace

If `nyoa-workspace/` does not exist (or is missing top-level files), create it from `plugins/nyoa/assets/workspace-template/`:

- Copy every file/folder except the `_template/` subfolders under `clients/` and `listings/` (those are per-entry templates, copied when a client or listing is created).
- Replace `{{client_name}}`, `{{address}}`, etc. placeholders only when scaffolding a specific client or listing folder.
- Leave the top-level `pipeline.md`, `calendar.md`, `tasks.md` with just their section headings, unless Round 6 produced entries.

### 4. Skill tiers and next steps

After setup completes (or after resuming to Round 8), show this summary:

```
Your NYOA workspace is live. Here's what's available:

WORKSPACE OPERATIONAL
  /nyoa-log              — log a call, showing, or client interaction
  /nyoa-pipeline         — view or update your pipeline board
  /nyoa-weekly-review    — generate your weekly business review
  /nyoa-client-add       — add a new buyer or seller to your book
  /nyoa-listing-add      — add a new listing to your workspace

CONTENT
  /nyoa-listing-copy     — write or rewrite listing descriptions
  /nyoa-listing-audit    — score a live listing against best practices
  /nyoa-buyer-seller-comms — draft emails, texts, and voicemail scripts
  /nyoa-social-content   — create social posts from your listings and proof
  /nyoa-listing-presentation — build a seller presentation deck
  /nyoa-offer-analyzer   — compare and explain competing offers
  /nyoa-aeo              — publish articles that rank for your name
  /nyoa-testimonial-engine — draft review requests and format testimonials

HELP + HYGIENE
  /nyoa-help             — what can NYOA do? (full skill directory)
  /nyoa-doctor           — diagnose workspace issues
  /nyoa-find             — search across your clients, listings, and notes
  /nyoa-archive          — close out completed clients and listings
```

Then show 2–3 highest-leverage next steps, personalized to what the agent filled in:

- If they have any **active listings** with no copy: "You have N active listings. Run `/nyoa-listing-audit <address>` for the weakest one, then `/nyoa-listing-copy` to rewrite it."
- If they have **closed transactions in the last 90 days** without testimonials: "You closed N deals recently and only have X testimonials. Run `/nyoa-testimonial-engine` to draft review requests."
- If they listed **competitors**: "Run `/nyoa-aeo head-to-head` against [Top Competitor] to claim that comparison search query."
- If they skipped Round 7 (templates): "Next time you write a buyer follow-up you're happy with, paste it and I'll save it to `templates/intro-emails.md`."
- Always (if connectors not yet run): "Run `/nyoa-connect` to detect your tools and unlock send-from-Gmail / sync-to-calendar features."

Rank by leverage — highest-impact suggestion first.

### 5. Confirm and exit

Print a short summary:

```
Set up:
- nyoa-context/ — profile, voice, proofs, competitors
- nyoa-workspace/ — N clients, M listings, pipeline initialized
- _meta.json — workspace anchored, schema v0.9.0

Next steps:
1. …
2. …
3. …
```

---

### Migrate sub-workflow (`/nyoa-setup migrate`)

Upgrades a v0.5.x workspace to v0.9.0. Non-destructive: never deletes or overwrites existing context files. Completes in under a minute.

**Step 1 — Backup.** Create `nyoa-workspace/.backups/v0.5-to-v0.6/<YYYY-MM-DD>/` and copy into it:
- `nyoa-context/` (entire directory)
- `nyoa-workspace/pipeline.md` (if present)

Confirm: "Backup created at `nyoa-workspace/.backups/v0.5-to-v0.6/<date>/`."

**Step 2 — Write `_meta.json`.** Create `nyoa-context/_meta.json`:
```json
{
  "schema_version": "0.9.0",
  "installed_at": "<today YYYY-MM-DD>",
  "setup": {
    "setup_complete": true,
    "setup_last_round_completed": 7,
    "setup_completed_at": "<today YYYY-MM-DD>"
  },
  "workspace": {
    "backend": "local",
    "root_path": "."
  },
  "agent": {
    "name": null,
    "brokerage": null,
    "license_state": null,
    "nar_member": null
  }
}
```
Note: `setup_last_round_completed` is set to 7 (all v0.5.x rounds are treated as complete). The agent can run `/nyoa-setup connectors` (Round 8) whenever they're ready.

If `nyoa-context/profile.md` exists, parse and populate `agent.name`, `agent.brokerage`, `agent.license_state`, and `agent.nar_member` in `_meta.json` where present. If `license_state` cannot be found in the existing profile, leave it `null` and warn the agent in the Step 6 confirmation: "Couldn't detect your license state from the existing profile. Run `/nyoa-setup identity` to add it — without it, `/nyoa-compliance-review` falls back to federal-only review."

**Step 3 — Upgrade `connectors.md`.** Read existing `nyoa-context/connectors.md` (if present). Check whether the v0.6.0 sections "## User-stated preferences" and "## NYOA usage" are already there. If not, append them (preserving all existing content verbatim) using the format from `plugins/nyoa/references/context-formats.md`. If `connectors.md` does not exist, create it from the template.

**Step 4 — Ensure `feedback.md` exists.** If `nyoa-context/feedback.md` does not exist, create it with the minimal template from `plugins/nyoa/references/context-formats.md`.

**Step 5 — Upgrade `pipeline.md`.** Read `nyoa-workspace/pipeline.md` (if present). Check whether these two rolling sections exist:
- `## Recent logs (last 7d)`
- `## Stale items needing attention`

If either is absent, append it (with empty content) at the end of the file. Never touch existing pipeline entries.

**Step 6 — Confirm.** Print:
```
Migration complete. Your workspace is now on v0.9.0.
  - Backup: nyoa-workspace/.backups/v0.5-to-v0.6/<date>/
  - Added: nyoa-context/_meta.json (schema v0.9.0)
  - Updated: nyoa-context/connectors.md (v0.6 sections appended)
  - Updated: nyoa-workspace/pipeline.md (rolling sections added)

Try /nyoa-help for the full skill directory, or /nyoa-setup connectors to wire up your tools.
```

**Rollback.** If anything fails after Step 1, delete `nyoa-context/_meta.json` (if it was written) and any appended sections (revert from backup). The plugin then behaves as v0.5.x. Inform the agent: "Migration failed at Step N. Your workspace is unchanged. Backup is at `nyoa-workspace/.backups/v0.5-to-v0.6/<date>/`."

---

## Compliance pass

- If the agent pasted writing samples that contain Fair Housing red-flag language, flag them in `voice.md` under a `## Phrases to avoid (auto-flagged)` section. Do not silently strip them — surface so the agent learns. See the canonical Fair Housing red-flag list in `plugins/nyoa/references/compliance/fair-housing.md`.
- License #, lockbox codes, or other sensitive info pasted by the agent: save only to local files (never to logs, never to outputs shared externally). Remind the agent that `nyoa-workspace/` is a local folder.
- If a competitor is named, record neutral facts only — never disparaging language.
- No invented facts: use `[VERIFY FACT]` for uncertain claims, `[INSERT PROOF]` for needed-but-missing testimonials.

## Output format

Markdown summary at the end of setup (per Step 5 / Confirm and exit). During the interview, plain text questions and short confirmations. After each round, a one-line save confirmation ("Saved to `nyoa-context/profile.md`. Updating `_meta.json`…").

End with: `Voice used: NYOA house` (the agent's own voice isn't calibrated yet on first run; for single-round re-runs, use the agent's calibrated voice if `voice.md` already exists).

## Shared context

This skill is a primary writer for:

- `nyoa-context/_meta.json` — created in Round 1, updated after every round, finalized at Round 8
- `nyoa-context/profile.md` — Round 2
- `nyoa-context/voice.md` — Round 3
- `nyoa-context/proofs.md` — Round 4
- `nyoa-context/competitors.md` — Round 5
- `nyoa-workspace/pipeline.md` — Round 6 (row entries; also adds rolling sections during migrate)
- `nyoa-workspace/templates/` — Round 7

It scaffolds (but does not write content into) `nyoa-workspace/`. It defers `nyoa-context/connectors.md` to `/nyoa-connect`.

Reads during state detection:
- `nyoa-context/_meta.json` — schema version and setup progress
- `nyoa-context/profile.md` — to detect v0.5.x installs and pre-populate migrate

## Reference files

- `plugins/nyoa/references/context-formats.md` — canonical schemas for every file written by this skill
- `plugins/nyoa/references/workspace-io.md` — workspace I/O contract (path resolution, read/write rules)
- `plugins/nyoa/assets/workspace-template/` — the workspace skeleton scaffolded in Step 3
- `plugins/nyoa/migrations/0.6.0/index.md` — what changed in v0.6.0 schema and migration steps
- `plugins/nyoa/migrations/0.9.0/index.md` — what changed in v0.9.0 (new identity fields, /nyoa-compliance-review delegation)
- `plugins/nyoa/references/compliance/fair-housing.md` — Fair Housing red-flag list (referenced in compliance pass)
