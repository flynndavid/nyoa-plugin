---
name: nyoa-doctor
description: Audit your NYOA workspace for issues — schema version mismatch, missing context files, stale pipeline entries, broken cross-folder references, and incomplete setup. Use this skill when an agent says "audit my workspace", "check my nyoa setup", "what's wrong with my workspace", "run a health check", or "diagnose my pipeline". Triggers on phrases like "doctor", "audit", "health check", "diagnose", "what's missing", "workspace issues".
---

# NYOA Doctor

A read-only workspace audit that surfaces schema mismatches, missing context files, connector gaps, and stale pipeline entries in one pass. The agent gets a ranked issue list and the exact commands to resolve each gap.

## When this skill triggers

- "Audit my workspace" / "check my NYOA setup" / "what's wrong with my workspace"
- "Run a health check" / "diagnose my pipeline" / "what's missing"
- Phrases: "doctor", "audit", "health check", "diagnose", "what's missing", "workspace issues"

## Inputs you need

Nothing required. The skill reads the workspace. The agent may pass a section filter as an argument.

**Optional:**
- **`$ARGUMENTS`** — section filter: `schema`, `setup`, `connectors`, or `stale`

## Workflow

### Capability requirements

This skill reads local files only. No external capabilities required.

### `$ARGUMENTS` dispatch

Inspect `$ARGUMENTS` before doing anything else:

- **No args** → run the full audit (all four sections).
- **`schema`** → run Section 1 only.
- **`setup`** → run Section 2 only.
- **`connectors`** → run Section 3 only.
- **`stale`** → run Section 4 only.

### Section 1 — Schema

1. Look for `nyoa-context/_meta.json`.
   - If missing: report "No `_meta.json` found — workspace predates v0.6.0. Run `/nyoa-setup migrate` to upgrade (non-destructive, under a minute)." Skip the remaining schema checks.
2. If `_meta.json` exists:
   - Read and parse it as JSON.
   - Check `schema_version`. If it is not `"0.9.0"`, report: "Schema version mismatch: found `<value>`, expected `0.9.0`. Run `/nyoa-setup migrate`."
   - Report `workspace.backend` and `workspace.root_path`.
   - Report `setup.setup_complete` (true/false) and `setup.setup_last_round_completed` (0–8).
   - If `setup_complete` is `false`, note which round was last completed and suggest: "Run `/nyoa-setup resume` to continue."

### Section 2 — Setup completeness

1. Check which of the following `nyoa-context/` files exist:
   - `profile.md`, `voice.md`, `proofs.md`, `competitors.md`, `feedback.md`, `connectors.md`, `_meta.json`
2. For each missing file, report it as a gap with the remediation command:
   - `profile.md` missing → "Missing: `nyoa-context/profile.md` — run `/nyoa-setup` to populate."
   - `voice.md` missing → "Missing: `nyoa-context/voice.md` — run `/nyoa-setup voice` to populate."
   - `proofs.md` missing → "Missing: `nyoa-context/proofs.md` — run `/nyoa-setup proofs` to populate."
   - `competitors.md` missing → "Missing: `nyoa-context/competitors.md` — run `/nyoa-setup competitors` to populate."
   - `feedback.md` missing → "Missing: `nyoa-context/feedback.md` — no action required; it populates automatically as you correct NYOA."
   - `connectors.md` missing → "Missing: `nyoa-context/connectors.md` — run `/nyoa-connect` to detect your tools."
3. **License state check.** If `nyoa-context/profile.md` exists, scan it for a `License state:` field (under the `## Licensing & affiliation` section). If the field is blank, set to `—`, or the section/field is absent, report: "`license_state` is not set in your profile. `/nyoa-compliance-review` will fall back to federal-only review. Run `/nyoa-setup identity` to fix."
4. Check that `nyoa-workspace/` exists and contains at minimum:
   - `pipeline.md`, `calendar.md`, `tasks.md`, `compliance-log.md`
5. For each missing workspace file, report: "Missing: `nyoa-workspace/<file>` — run `/nyoa-setup` to scaffold."
6. **Compliance log check.** If `nyoa-workspace/compliance-log.md` is missing, report: "Compliance log is missing. Run `/nyoa-setup workspace` to scaffold it, or it will be auto-created on the next generative skill run."
7. If `nyoa-workspace/` is entirely absent: "No workspace found. Run `/nyoa-setup` to create it."

### Section 3 — Connectors

1. Read `nyoa-context/connectors.md`. If missing, report: "Cannot audit connectors — `nyoa-context/connectors.md` is missing. Run `/nyoa-connect`." Skip the remaining connector checks.
2. Verify the file has all four required sections:
   - `## Detected`
   - `## Built-in tools`
   - `## Stack we tracked but can't verify a public MCP for`
   - `## User-stated preferences`
3. If `## User-stated preferences` section is missing, report: "`connectors.md` predates v0.6 format — run `/nyoa-connect` to update."
4. List every connector found under `## Detected` with its status (`yes` / `no`) and namespace.
5. Note any capability gaps: if `## User-stated preferences` has `not-set` for calendar, email, or docs, flag as: "Preference not set for `<capability>` — run `/nyoa-connect` to record your preferred tool."

### Section 4 — Stale items

1. Read `nyoa-workspace/pipeline.md`. If missing, report: "Cannot check stale items — `nyoa-workspace/pipeline.md` not found. Run `/nyoa-setup`." Skip the remaining stale checks.
2. Parse pipeline entries across all sections. Compute "last activity" from the `last activity YYYY-MM-DD` field on each entry.
3. Flag entries as stale based on the current date:

   | Stage | Stale threshold |
   |-------|----------------|
   | Leads | > 14 days since last activity |
   | Active | > 7 days since last activity |
   | Active (listing on market) | > 30 days since list date |
   | Under contract | > 5 days since last activity |

4. For each stale entry, report the name/address, stage, days since last activity, and a suggested action (same suggestions as `/nyoa-pipeline` Step 3).
5. Orphaned folders — scan `nyoa-workspace/clients/` and `nyoa-workspace/listings/`:
   - For each subfolder found, check whether a matching pipeline entry exists (by slug).
   - If a client folder has no pipeline entry, report: "Orphaned client folder: `clients/<slug>/` — no pipeline entry found. Add via `/nyoa-client-add` or move to `## On hold / nurture` manually."
   - If a listing folder has no pipeline entry, report: "Orphaned listing folder: `listings/<slug>/` — no pipeline entry found. Add via `/nyoa-listing-add` or check if it was archived."
6. Report the total stale item count.

## Compliance pass

This skill produces no user-facing real estate copy. No Fair Housing check is required. Do not echo sensitive client data beyond what is necessary to identify which entry is stale or missing.

## Output format

```
## NYOA Workspace Audit — YYYY-MM-DD

### Schema
[results — one finding per line, or "No issues found."]

### Setup completeness
[results — one gap per line, or "All required files present."]

### Connectors
[results — one finding per line, or "Connectors look good."]

### Stale items
[results — one item per line, or "No stale items found."]

---
N issues found. Run the suggested commands above to resolve them.
Note: /nyoa-doctor is audit-only in v0.6. Automated fixes land in v0.7.
```

If `$ARGUMENTS` targeted a single section, output only that section with the same header format.

End with: `Voice used: NYOA house`.

## Shared context

**Reads:**
- `nyoa-context/_meta.json` — schema version and setup state
- `nyoa-context/profile.md` — presence check + scan for `License state:` field
- `nyoa-context/voice.md`, `proofs.md`, `competitors.md`, `feedback.md`, `connectors.md` — presence check only
- `nyoa-workspace/pipeline.md` — stale entry detection
- `nyoa-workspace/compliance-log.md` — presence check
- `nyoa-workspace/clients/*/` — orphan detection
- `nyoa-workspace/listings/*/` — orphan detection

**Writes:** nothing. This skill is read-only.

## Reference files

- `plugins/nyoa/references/context-formats.md` — `_meta.json` spec, connectors.md format, pipeline entry format
- `plugins/nyoa/references/workspace-io.md` — workspace I/O contract and schema versioning rules
