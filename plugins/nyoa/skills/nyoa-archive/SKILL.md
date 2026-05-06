---
name: nyoa-archive
description: Move Closed pipeline entries older than 90 days to an Archive section in pipeline.md — keeping the pipeline view clean without deleting data or folders. Use this skill when an agent says "archive old pipeline entries", "clean up closed deals", "move old closed to archive", or the pipeline is getting long with old closed entries. Triggers on phrases like "archive", "clean up pipeline", "move old closed", "pipeline cleanup".
---

# Archive

Moves old closed pipeline entries from `## Closed` to `## Archive (>90d)` in `pipeline.md` — trimming visual clutter without touching any client or listing folders. History stays intact; it just moves to a lower section of the same file.

## When this skill triggers

- "Archive old pipeline entries" / "clean up closed deals" / "move old closed to archive"
- "My pipeline is getting too long" / "pipeline cleanup"
- Phrases: "archive", "clean up pipeline", "move old closed", "pipeline cleanup"

## Inputs you need

Nothing required. The skill reads `nyoa-workspace/pipeline.md` and identifies qualifying entries automatically.

**Optional:**
- None in v0.6. A custom threshold (e.g., `--days 60`) is reserved for v0.7.

## Workflow

### Capability requirements

This skill reads and writes `pipeline.md` only. No external capabilities required.

### 1. Read pipeline.md

Read `nyoa-workspace/pipeline.md`. If it doesn't exist, tell the agent: "No pipeline found. Run `/nyoa-setup` to create your workspace, then add clients via `/nyoa-client-add` or listings via `/nyoa-listing-add`."

### 2. Identify qualifying entries

Scan only the `## Closed` section (and `## Closed (last 12 months)` if that heading variant is used). Do not scan any other section.

For each entry in `## Closed`:
1. Extract the close date from the entry. The close date is the `last activity YYYY-MM-DD` field in the pipeline entry format.
2. Compare the close date to today's date.
3. Mark the entry as qualifying if the close date is **more than 90 days ago**.

### 3. Preview and confirm

Before making any changes, show the agent a preview:

```
I found N entries in your Closed section with a close date older than 90 days:

- [Jane Doe](clients/jane-doe/) — last activity 2025-10-12
- [456 Oak Ave](listings/456-oak-ave/) — last activity 2025-09-30
...

I'll move these to an `## Archive (>90d)` section at the bottom of pipeline.md.
The folders stay exactly where they are — this is a pipeline view change only.

Proceed? [Y/n]
```

If the agent declines, stop and confirm: "No changes made."

If no entries qualify, report: "No Closed entries older than 90 days found. Nothing to archive." and stop.

### 4. Rewrite pipeline.md

On confirmation (or if the agent says yes / presses enter):

1. Remove the qualifying entries from the `## Closed` (or `## Closed (last 12 months)`) section. Preserve non-qualifying entries and any section comments.
2. Locate the `## Archive (>90d)` section at the bottom of `pipeline.md`. If it doesn't exist, create it above the `---` footer line and the `Last updated:` stamp.
3. Append each moved entry to `## Archive (>90d)` with an archive note on the line below:
   ```
   - [Jane Doe](clients/jane-doe/) — buyer — last activity 2025-10-12 — next: [archived]
     _Archived on YYYY-MM-DD by /nyoa-archive_
   ```
4. Update the `Last updated:` stamp at the bottom to today's date.

### 5. Confirm

Report: "Archived N entries. They now live in `## Archive (>90d)` in `nyoa-workspace/pipeline.md`. Their folders are untouched."

## Important rules

- **Folders are never touched.** `clients/<slug>/` and `listings/<slug>/` directories are read-only for this skill. This is a `pipeline.md`-only operation.
- **Entries are moved, not deleted.** They go from `## Closed` to `## Archive (>90d)` in the same file. History is preserved.
- **Only Closed entries qualify.** Never archive entries from `## Leads`, `## Active`, `## Under contract`, or `## On hold / nurture`.
- **90-day threshold is based on close date** (the `last activity` field in the pipeline entry), not the date the entry was created or the date the skill runs.
- **Confirmation required.** Never move entries without the agent seeing the preview and confirming.

## Compliance pass

This skill produces no user-facing real estate copy. No Fair Housing check required. Do not edit the content of pipeline entries — move them verbatim.

## Output format

Preview list → confirmation prompt → (on yes) brief confirmation message.

End with: `Voice used: NYOA house`.

## Shared context

**Reads:** `nyoa-workspace/pipeline.md`

**Writes:** `nyoa-workspace/pipeline.md` only — moves entries between sections within the same file. Does not create, delete, or modify any other file or folder.

## Reference files

- `plugins/nyoa/references/context-formats.md` — pipeline entry format
- `plugins/nyoa/references/workspace-io.md` — write contract (state file section-only overwrite rule)
