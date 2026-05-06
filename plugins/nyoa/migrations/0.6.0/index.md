# Migration: v0.5.x → v0.6.0

This document describes what changed in the NYOA v0.6.0 workspace schema and the exact steps `/nyoa-setup migrate` follows to upgrade an existing v0.5.x workspace. It is referenced by the `nyoa-setup` skill and is the authoritative record for this migration.

## What's new in v0.6.0

### `nyoa-context/_meta.json` (new file)

The single most important addition. `_meta.json` is the workspace manifest — the only file in `nyoa-context/` that carries a `schema_version` field. It enables:

- **Resume-able setup** — `setup.setup_last_round_completed` lets `/nyoa-setup resume` pick up mid-interview.
- **Version-aware session hooks** — the `session-start.sh` hook reads `schema_version` and nudges stale workspaces.
- **Future backend portability** — `workspace.backend` and `workspace.root_path` are reserved for v0.7 (Google Drive, Notion backends).
- **Agent identity shortcut** — `agent.name` and `agent.brokerage` give skills a fast lookup without parsing `profile.md`.

### `connectors.md` v0.6 additions

Two new sections appended to the existing format:

- **`## User-stated preferences`** — records which specific tool the agent uses for each capability (email, calendar, docs, SMS, CRM, team-comms).
- **`## NYOA usage`** — documents what NYOA does when each connector is present, so agents understand the value of wiring up each tool.

### `pipeline.md` rolling sections

Two new append-only sections added to the bottom of `nyoa-workspace/pipeline.md`:

- **`## Recent logs (last 7d)`** — populated by `/nyoa-log`; shows the last 7 days of activity across all clients and listings.
- **`## Stale items needing attention`** — populated by `/nyoa-weekly-review`; surfaces contacts with no activity in 14+ days.

---

## Migration steps (what `/nyoa-setup migrate` does)

All steps are non-destructive. The migration never deletes or overwrites existing context files.

### Step 1 — Backup

Create `nyoa-workspace/.backups/v0.5-to-v0.6/<YYYY-MM-DD>/` and copy into it:
- The entire `nyoa-context/` directory
- `nyoa-workspace/pipeline.md` (if present)

The backup is a snapshot of the pre-migration state. If anything goes wrong, restore from here.

### Step 2 — Write `_meta.json`

Create `nyoa-context/_meta.json` with:

```json
{
  "schema_version": "0.6.0",
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
    "name": "<from profile.md if parseable, else null>",
    "brokerage": "<from profile.md if parseable, else null>"
  }
}
```

`setup_last_round_completed` is set to 7 (all v0.5.x setup rounds are treated as complete). The agent can run `/nyoa-setup connectors` (Round 8) at any time to wire up their tools.

### Step 3 — Upgrade `connectors.md`

Read `nyoa-context/connectors.md` (if present). If the "## User-stated preferences" or "## NYOA usage" sections are absent, append them using the canonical format from `plugins/nyoa/references/context-formats.md`. All existing content is preserved verbatim — only the new sections are appended.

If `connectors.md` does not exist, create it from the template in `context-formats.md`.

### Step 4 — Ensure `feedback.md`

If `nyoa-context/feedback.md` does not exist, create it using the minimal template from `plugins/nyoa/references/context-formats.md`. If it already exists, leave it untouched.

### Step 5 — Upgrade `pipeline.md`

Read `nyoa-workspace/pipeline.md` (if present). If either of the following sections is absent, append it (empty) at the end of the file:
- `## Recent logs (last 7d)`
- `## Stale items needing attention`

Existing pipeline entries are never modified.

### Step 6 — Confirm

Report what was done:
- Backup location
- Files created or updated
- Nudge to run `/nyoa-setup connectors` for Round 8

---

## Rollback instructions

If the migration fails at any step after Step 1:

1. Delete `nyoa-context/_meta.json` (if it was created in Step 2).
2. Restore `nyoa-context/` from `nyoa-workspace/.backups/v0.5-to-v0.6/<date>/nyoa-context/`.
3. Restore `nyoa-workspace/pipeline.md` from the same backup if Step 5 ran.
4. The plugin will behave as v0.5.x — the session-start hook will not nudge to migrate until a fresh attempt.

Inform the agent which step failed so they can report it or retry.

---

## Safety guarantees

- **No data loss** — backup created before any write.
- **No overwrite** — existing content in `connectors.md`, `feedback.md`, and `pipeline.md` is never modified, only appended to.
- **Idempotent** — running `/nyoa-setup migrate` on an already-migrated workspace (where `_meta.json` exists with `schema_version: "0.6.0"`) is a no-op. The skill detects this and exits: "Your workspace is already on v0.6.0."
- **Atomic `_meta.json`** — `_meta.json` is written as valid JSON only. If serialization fails, nothing is written and the rollback path applies.
- **POSIX-safe** — the session-start hook uses `grep` (not `jq`) to detect schema version, so the nudge works on any system.
