---
name: nyoa-help
description: The NYOA help system — lists available skills filtered by workspace state, explains individual skills, and displays step-by-step workflow recipes. Use this skill when an agent says "help", "what can I do", "what skills do I have", "how do I...", "what's nyoa-help", or wants to know what to do in a specific situation. Triggers on phrases like "help", "what can I do", "show me my options", "workflow", "how do I handle", "what nyoa skill".
---

# NYOA Help

The NYOA help system. Read workspace state, then surface the most relevant skills and guidance for what the agent is doing right now. Supports three modes: filtered skill list, individual skill explanation, and step-by-step workflow recipes.

## When this skill triggers

- "Help" / "what can I do" / "what skills do I have"
- "How do I handle an open house?" / "what should I do next?"
- "Explain nyoa-listing-copy" / "how does nyoa-log work?"
- "Show me the workflow for a new listing" / "workflow first-month"
- "What's the best skill for writing an email to a buyer?"
- "Show me my options" / "what nyoa skill should I use"

## Inputs you need

Required:
- None for default mode — workspace state is read automatically.

Optional (via `$ARGUMENTS`):
- **Skill name** — any known nyoa-* skill name (e.g., `nyoa-listing-copy`, `listing-copy`)
- **Workflow scenario** — `workflow <scenario>` where scenario is one of: `new-buyer`, `new-listing`, `under-contract`, `open-house`, `listing-not-selling`, `first-month`
- **Free-text query** — any phrase, matched against skill descriptions to surface the most relevant skills

## Workflow

### Mode dispatch

Check `$ARGUMENTS` first — before reading any files:

- **Empty** → run Default mode (filtered skill list)
- **Matches a known skill name** (with or without `nyoa-` prefix) → run Skill-Explain mode
- **Starts with `workflow`** → run Workflow-Recipe mode
- **Anything else** → treat as a free-text query; run Default mode with skills ranked by relevance to the query

### Capability requirements

This skill reads local files only. No external capabilities required.

---

### Default mode — filtered skill list

**Step 1 — Read workspace state.**

Read `nyoa-context/_meta.json`. If the file is missing, or if `schema_version` is less than `0.6.0`, note at the top of the output:

> Workspace predates v0.6 — run `/nyoa-setup migrate` to upgrade.

If the file exists and setup_complete is false, note the incomplete round:

> Setup is at round `<setup_last_round_completed>` of 8 — run `/nyoa-setup resume` to continue.

Read `nyoa-workspace/pipeline.md` to understand what's active. Note counts and stages only — do not surface client names or addresses in help output.

**Step 2 — Build the recommended list.**

Evaluate the following signals against what you read from the workspace, then mark matching skills as **→ recommended**:

| Signal | Recommend |
|--------|-----------|
| Pipeline has active listing entries but `listings/<slug>/copy.md` is missing | `/nyoa-listing-audit`, `/nyoa-listing-copy` |
| Pipeline has leads untouched for > 14 days | `/nyoa-buyer-seller-comms` |
| `nyoa-workspace/reviews/` has no file in the last 7 days | `/nyoa-weekly-review` |
| `nyoa-context/voice.md` does not exist | `/nyoa-setup` (voice round) |
| `_meta.json` setup_complete is false | `/nyoa-setup resume` |
| No `nyoa-context/_meta.json` at all | `/nyoa-setup` |

**Step 3 — Output the grouped skill list.**

Format as a clean, scannable list with four tiers. One line per skill: `/nyoa-<skill>` — brief description. Append **→ recommended** (with a brief reason) on the same line for any recommended skills.

```
## Start here
/nyoa-setup       — onboarding interview: build your business identity and workspace
/nyoa-connect     — detect and document which MCPs / tools you have wired up
/nyoa-help        — this skill: list skills, explain them, or load a workflow recipe
/nyoa-doctor      — audit your workspace for missing or stale content

## Daily workflow
/nyoa-log         — log a call, showing, or update in one sentence
/nyoa-pipeline    — review and update your deal pipeline
/nyoa-weekly-review — run a weekly review of your book of business
/nyoa-client-add  — add a new client and scaffold their workspace folder
/nyoa-listing-add — add a new listing and scaffold its workspace folder

## Content
/nyoa-listing-copy         — generate MLS remarks, long description, social, and email copy
/nyoa-listing-audit        — audit a live listing URL and diagnose performance issues
/nyoa-buyer-seller-comms   — draft emails, texts, and voicemail scripts for clients
/nyoa-social-content       — generate social media posts for listings and market content
/nyoa-listing-presentation — build a listing presentation with pricing strategy and marketing plan
/nyoa-offer-analyzer       — analyze and compare multiple offers on a listing
/nyoa-aeo                  — create answer-engine-optimized articles to own local search queries
/nyoa-testimonial-engine   — draft review requests and format testimonials for reuse

## Compliance
/nyoa-compliance-review — Fair-housing and advertising compliance check. Called automatically by every generative skill; also usable standalone on any pasted draft.

## Hygiene
/nyoa-doctor  — audit workspace completeness and flag stale or missing content
/nyoa-find    — search across workspace for a client, listing, or piece of content
/nyoa-archive — archive closed clients and listings to keep the workspace lean
```

End the default output with:

> Run `/nyoa-help <skill>` to learn more about any skill, or `/nyoa-help workflow <scenario>` to load a step-by-step workflow recipe.
> Available workflows: `new-buyer`, `new-listing`, `under-contract`, `open-house`, `listing-not-selling`, `first-month`.

---

### Skill-Explain mode — explain a specific skill

Normalize the argument: strip the `nyoa-` prefix if present, then re-add it to get the canonical name. Match against the known skill list above.

If no match, say: "I don't recognize `<argument>` as a NYOA skill. Here are all available skills:" and fall back to the Default mode skill list.

For a matched skill, output:

1. **What it does** — 2–3 sentences explaining the skill's purpose and when to reach for it.
2. **Required inputs** — bullet list of what the agent must provide.
3. **Example invocations** — 2–3 plain-language examples the agent could literally type.
4. **Workspace** — does it read from workspace? Write to it? Both?
5. A closing line: "Type `/nyoa-<skill>` to invoke it."

---

### Workflow-Recipe mode — load a scenario recipe

Parse the scenario from `$ARGUMENTS` by removing the leading `workflow` token (and any surrounding whitespace). Normalize: lowercase, replace spaces with hyphens.

Match against these recipes in `plugins/nyoa/references/workflows/`:

| Normalized scenario | File |
|--------------------|------|
| `new-buyer` | `workflows/new-buyer.md` |
| `new-listing` | `workflows/new-listing.md` |
| `under-contract` | `workflows/under-contract.md` |
| `open-house` | `workflows/open-house.md` |
| `listing-not-selling` | `workflows/listing-not-selling.md` |
| `first-month` | `workflows/first-month.md` |

Read the matching file and display its contents directly. Do not summarize — show the full recipe.

If the scenario doesn't match any of the six, say:

> I don't have a recipe for `<scenario>`. Available workflows:
> - `new-buyer` — onboarding a new buyer client
> - `new-listing` — from listing appointment to live
> - `under-contract` — contract to close
> - `open-house` — before / during / after an open house
> - `listing-not-selling` — listing on market 30+ days with no offers
> - `first-month` — getting the most from NYOA in your first 30 days

---

## Compliance pass

This skill produces no user-generated content (no listing copy, emails, or social posts). No Fair Housing check is required.

Do not surface client names, listing addresses, or any PII from the pipeline in help output. Use counts and stage labels only (e.g., "3 active listings" — not the addresses).

## Output format

**Default mode:** grouped Markdown list with recommended markers and a closing prompt.

**Skill-Explain mode:** structured Markdown with labeled sections (What it does / Inputs / Examples / Workspace) and a call-to-action closing line.

**Workflow-Recipe mode:** the recipe file content, displayed verbatim.

All modes end with: `Voice used: NYOA house`

## Shared context

Reads:
- `nyoa-context/_meta.json` — schema version, setup state
- `nyoa-workspace/pipeline.md` — active work for relevance scoring

Does not write to any file.

## Reference files

- `plugins/nyoa/references/context-formats.md` — _meta.json spec and schema_version field
- `plugins/nyoa/references/workflows/new-buyer.md`
- `plugins/nyoa/references/workflows/new-listing.md`
- `plugins/nyoa/references/workflows/under-contract.md`
- `plugins/nyoa/references/workflows/open-house.md`
- `plugins/nyoa/references/workflows/listing-not-selling.md`
- `plugins/nyoa/references/workflows/first-month.md`
