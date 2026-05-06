---
name: nyoa-find
description: Search across all markdown files in nyoa-workspace/ and nyoa-context/ and return matches with file paths and surrounding context. Use this skill when an agent says "find", "search my workspace", "where did I put", "which client mentioned", "find the note about", or wants to locate a specific piece of information across their workspace. Triggers on phrases like "find", "search", "where is", "look for", "which file has", "grep".
---

# Find

Workspace-wide search across every markdown file in `nyoa-context/` and `nyoa-workspace/`. Returns matches grouped by domain with surrounding context lines — so the agent can jump straight to the right file instead of reading through folders manually.

## When this skill triggers

- "Find <term>" / "search my workspace for <term>" / "where did I put <note>"
- "Which client mentioned <topic>" / "find the note about <subject>"
- "Where is the info about <address/name/topic>"
- Phrases: "find", "search", "where is", "look for", "which file has", "grep"

## Inputs you need

**Required:**
- **Search term** — extracted from `$ARGUMENTS`. If empty, ask: "What are you looking for?"

**Optional:**
- None. The search always covers all domains.

## Workflow

### Capability requirements

This skill reads local files only. No external capabilities required.

### 1. Parse the search term

Read `$ARGUMENTS`. If `$ARGUMENTS` is empty or only whitespace, ask the agent: "What are you looking for?" and wait for their reply before proceeding.

Use the full `$ARGUMENTS` string as the search term (case-insensitive, literal substring match). Do not interpret it as a command or filter.

### 2. Search scope

Search across all `.md` files in the following locations:

| Domain | Paths |
|--------|-------|
| Context | `nyoa-context/*.md` |
| Clients | `nyoa-workspace/clients/*/*.md` |
| Listings | `nyoa-workspace/listings/*/*.md` |
| Pipeline | `nyoa-workspace/pipeline.md` |
| Calendar | `nyoa-workspace/calendar.md` |
| Tasks | `nyoa-workspace/tasks.md` |
| Reviews | `nyoa-workspace/reviews/*.md` |
| Templates | `nyoa-workspace/templates/*.md` |

If a path doesn't exist, skip it silently — don't report missing folders as errors.

### 3. Match and collect results

For each file searched:
1. Scan line by line for the search term (case-insensitive).
2. For each matching line, collect:
   - **File path** — relative to cwd (e.g., `nyoa-workspace/clients/jane-doe/timeline.md`)
   - **Line number** — the line where the match was found
   - **Context window** — 2 lines above the match, the match line (highlighted with the term in backticks), and 2 lines below
   - **Domain** — one of: `client`, `listing`, `context`, `pipeline`, `calendar`, `tasks`, `review`, `template`

3. Cap results at 20 total matches across all files. If more than 20 matches exist:
   - Return the first 20.
   - Report: "Showing 20 of N total matches. Try a more specific term to narrow results."

### 4. Group and render

Group results by domain in this display order: Clients, Listings, Pipeline, Calendar, Tasks, Reviews, Templates, Context.

For each group with matches, show the domain heading and the match entries beneath it.

## Compliance pass

This skill produces no real estate copy. No Fair Housing check required. Display content as-is from workspace files — do not edit, summarize, or rewrite what is found.

## Output format

```
Found N matches for "<search term>"

**Clients** (n matches)
- clients/jane-doe/timeline.md:23 — "...inspection on Maple came back with a roof issue..."

**Listings** (n matches)
- listings/123-maple-st/offers.md:45 — "...buyer waived inspection..."

**Context** (n matches)
- nyoa-context/proofs.md:12 — "...Jane said working with me was..."
```

Omit groups with zero matches entirely.

If no matches are found anywhere: "No matches for '<term>' across your workspace. Check spelling or try a broader term."

End with: `Voice used: NYOA house`.

## Shared context

**Reads:**
- `nyoa-context/*.md` — all context files
- `nyoa-workspace/clients/*/*.md` — all client folder files
- `nyoa-workspace/listings/*/*.md` — all listing folder files
- `nyoa-workspace/pipeline.md`, `calendar.md`, `tasks.md`
- `nyoa-workspace/reviews/*.md`
- `nyoa-workspace/templates/*.md`

**Writes:** nothing. This skill is read-only.

## Reference files

- `plugins/nyoa/references/context-formats.md` — workspace and context directory structure
- `plugins/nyoa/references/workspace-io.md` — read contract and path resolution rules
