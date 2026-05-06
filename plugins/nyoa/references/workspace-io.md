# Workspace I/O Contract

NYOA skills read and write a local workspace. This document defines the contract all skills must follow, and the structure that will allow v0.7+ to add non-local backends (Google Drive, Notion) without changing skill code.

## v0.6 backend: local only

In v0.6, the workspace backend is always `local`. The workspace root is the agent's current working directory. Skills locate it by resolving relative paths from `cwd`.

The `nyoa-context/_meta.json` file records the backend and root:

```json
{
  "schema_version": "0.6.0",
  "workspace": {
    "backend": "local",
    "root_path": "."
  }
}
```

`root_path` is always `"."` in v0.6 (relative to `cwd`). In v0.7, non-local backends will use an absolute path or URI here, and a `${CLAUDE_PLUGIN_DATA}/workspace_pointer.json` will redirect skills to the correct location.

## Path resolution rules

All skills must resolve workspace paths as follows:

1. Read `nyoa-context/_meta.json` if it exists. Extract `workspace.root_path`.
2. Resolve `<root_path>/nyoa-workspace/` as the workspace root.
3. Resolve `<root_path>/nyoa-context/` as the context root.
4. If `_meta.json` does not exist, fall back to `./nyoa-workspace/` and `./nyoa-context/` (v0.5.x compatibility).

## Read contract

Before reading any workspace file:

1. Check that the file exists. If it doesn't, check whether the parent folder exists.
2. If neither exists and the skill needs this data to function, offer in-flow capture (see `references/onboarding-prompts.md`) rather than failing.
3. Never invent data that should come from the workspace.

## Write contract

Before writing any workspace file:

1. If writing to a log file (`timeline.md`, `showings.md`, `offers.md`, `feedback.md`, `reviews/*.md`), always **append** — never overwrite.
2. If writing to a state file (`pipeline.md`, `calendar.md`, `tasks.md`, `copy.md`), overwrite the relevant section only — preserve other sections.
3. If writing a new entity folder (`clients/<slug>/`, `listings/<slug>/`), scaffold from `plugins/nyoa/assets/workspace-template/` templates.
4. After any write, confirm to the agent with the file path: "Saved to nyoa-workspace/clients/jane-doe/timeline.md."
5. Never write secrets, tokens, or auth credentials to any workspace file.

## Capability branching

Skills that can use an external connector (email, calendar, CRM, etc.) must:

1. Read `nyoa-context/connectors.md` near the start of the workflow.
2. Identify which **capability** they need (from the declared list in their SKILL.md).
3. If the agent has a stated preference for that capability, use the corresponding connector.
4. If multiple connectors are available for the capability and no preference is set, ask: "You have both X and Y available — which would you like to use for this?"
5. If no connector is available, fall back to file-only behavior: write the output to the workspace and ask the agent to paste/export it to their tool.

Capabilities recognized by NYOA (v0.6):
- `email` — sending or drafting email (Google Workspace Gmail, Outlook via native MCP)
- `calendar` — creating or reading calendar events (Google Workspace Calendar)
- `docs` — reading or writing documents in cloud storage (Google Workspace Drive, Notion)
- `sms` — sending SMS (Twilio or equivalent)
- `crm` — logging contacts or activities (Follow Up Boss, HubSpot, etc.)
- `meeting-notes` — reading or writing meeting transcripts
- `web-scrape` — fetching and parsing external web pages (Firecrawl, Puppeteer)
- `team-comms` — sending messages to internal team channels (Slack)

## Schema versioning

`nyoa-context/_meta.json` is the single source of truth for schema version. No other context file carries a version field.

When a skill detects that `_meta.json` is missing but `nyoa-context/profile.md` exists, the install is v0.5.x. The skill should surface: "Your NYOA workspace predates v0.6.0. Run `/nyoa-setup migrate` to upgrade — takes under a minute and is non-destructive."

When `_meta.json.schema_version` is present but older than the plugin version, the session-start hook and any skill that reads `_meta.json` should nudge to `/nyoa-setup migrate`.

## v0.7 extension points (defined but not implemented)

The following are reserved for v0.7 and must not be implemented in v0.6:

- `${CLAUDE_PLUGIN_DATA}/workspace_pointer.json` — redirect file for non-local backends
- `workspace.backend: "gdrive"` — Google Drive backend
- `workspace.backend: "notion"` — Notion backend
- `--fix` flag on `/nyoa-doctor` — automated remediation
