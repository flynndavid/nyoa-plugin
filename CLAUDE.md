# CLAUDE.md — NYOA Plugin Dev Guide

> Read this before adding, editing, or refactoring skills in this repo.

This is a Claude Code / Cowork plugin marketplace shipping AI skills for real estate agents. It distributes via GitHub: agents add `https://github.com/flynndavid/nyoa-plugin` as a marketplace in Cowork and install the `nyoa` plugin.

The end-user audience is real estate agents — not developers. Skills must be invocable by typing a slash command in plain English; output must be copy-paste ready into MLS systems, social media, email, and CRM tools.

As of v0.5.0, NYOA is a real estate **operating system**, not just a content toolbelt. Skills now read and write a persistent local workspace (`nyoa-workspace/`) and shared business identity (`nyoa-context/`). Past sessions compound; future sessions start with full context.

---

## Repo structure

```
nyoa-plugin/
├── .claude-plugin/marketplace.json    # Marketplace metadata (Cowork pulls this first)
├── README.md                           # End-user docs (agent-facing, install + usage)
├── CLAUDE.md                           # This file — dev guide
└── plugins/nyoa/
    ├── .claude-plugin/plugin.json     # Plugin manifest
    ├── hooks/                         # SessionStart hook
    │   ├── hooks.json
    │   └── session-start.sh
    ├── assets/
    │   └── workspace-template/         # Scaffolded by /nyoa-setup et al
    ├── references/
    │   └── context-formats.md          # nyoa-context/ + nyoa-workspace/ format spec
    └── skills/
        ├── nyoa-setup/                 (v0.5.0)
        ├── nyoa-client-add/            (v0.5.0)
        ├── nyoa-listing-add/           (v0.5.0)
        ├── nyoa-pipeline/              (v0.5.0)
        ├── nyoa-weekly-review/         (v0.5.0)
        ├── nyoa-log/                   (v0.5.0)
        ├── nyoa-connect/               (v0.5.0)
        ├── nyoa-listing-audit/
        ├── nyoa-listing-copy/
        ├── nyoa-buyer-seller-comms/
        ├── nyoa-listing-presentation/
        ├── nyoa-offer-analyzer/
        ├── nyoa-aeo/
        ├── nyoa-social-content/
        └── nyoa-testimonial-engine/
```

Each skill follows the same internal structure:

```
nyoa-<skill>/
├── SKILL.md                  # Required — skill definition
├── references/               # Optional — supporting docs read by the skill
└── assets/templates/         # Optional — output structure templates
```

---

## Skill conventions

### Naming

- **Directory name:** `nyoa-<skill>` (always prefixed)
- **Frontmatter `name:` field:** must match the directory name exactly (`name: nyoa-aeo`, not `name: aeo`)
- **Slash command:** auto-derived from `name:` → `/nyoa-aeo`
- **Verb consistency:** prefer `-add` for skills that create new entries (`nyoa-client-add`, `nyoa-listing-add`). Action skills like `/nyoa-log`, `/nyoa-pipeline`, `/nyoa-setup` use the action as the suffix.
- **Cross-references in prose:** use the `nyoa-` prefix when referring to other skills (e.g., "see `nyoa-listing-copy/references/voice-presets.md`")

### SKILL.md frontmatter

```yaml
---
name: nyoa-<skill>
description: One-paragraph description that BOTH explains what the skill does AND lists trigger phrases. Include "Use this skill when..." and "Triggers on phrases like..." — Cowork uses the description for skill discovery and Claude uses it to decide when to invoke.
---
```

The description is doing two jobs (description + triggers) — keep it dense but scannable. Look at existing skills for the pattern.

### SKILL.md sections (in this order)

1. **Title** (`# Skill Name`)
2. **One-paragraph purpose** statement
3. **When this skill triggers** — bullet list of trigger phrases and scenarios
4. **Inputs you need** — Required (with bold labels) + Optional
5. **Voice modes** (if applicable) — resolution order
6. **Workflow** — numbered steps the skill follows
7. **Compliance pass** — mandatory section, includes the Fair Housing checks
8. **Workspace integration** (if applicable) — how the skill writes through to `nyoa-workspace/`
9. **Output format** — what the skill returns and in what format
10. **Shared context** (if applicable) — what `nyoa-context/` and `nyoa-workspace/` files it reads / writes
11. **Reference files** — links to `references/` and `assets/templates/`

End every output with a "Voice used: <agent name | NYOA house>" or equivalent attribution line.

---

## Two persistent locations

### `nyoa-context/` — stable business identity

```
nyoa-context/
├── profile.md      # Business name, services, locations, differentiators
├── voice.md        # Tone and style preferences
├── proofs.md       # Testimonials, awards, stats
├── competitors.md  # Competitor research
├── feedback.md     # Accumulated corrections from the agent
└── connectors.md   # Which MCPs / external tools the agent has wired up
```

**Skills that use it:** all v0.5.0 skills + every existing skill (the existing ones used a subset before; now all read from it).

### `nyoa-workspace/` — active daily operating data

```
nyoa-workspace/
├── clients/<slug>/         # profile.md, timeline.md, preferences.md, documents.md
├── listings/<slug>/        # property.md, copy.md, comps.md, showings.md, offers.md, photos.md
├── pipeline.md             # leads / active / under-contract / closed kanban
├── calendar.md             # showings, follow-ups, deadlines
├── tasks.md                # open todos
├── templates/              # agent's saved snippets
└── reviews/                # weekly review write-ups (YYYY-MM-DD.md)
```

**Skills that primary-write here:** `/nyoa-setup` (scaffolds from `assets/workspace-template/`), `/nyoa-client-add`, `/nyoa-listing-add`, `/nyoa-log`, `/nyoa-pipeline`, `/nyoa-weekly-review`. Most other skills write through to it when present (e.g., `/nyoa-listing-copy` writes canonical copy to `listings/<slug>/copy.md`).

**Source of truth:** the workspace template lives at `plugins/nyoa/assets/workspace-template/` and is the canonical structure scaffolded into the agent's working directory.

### Rules for skills using either layer

1. **Read before asking** — always check if `nyoa-context/` and `nyoa-workspace/` files exist and use them before asking the agent for info.
2. **Auto-save new info** — when the agent provides info during any skill interaction, save it without asking permission. Confirm afterward ("Saved to clients/jane-doe/profile.md").
3. **Append-only logs** — `timeline.md`, `showings.md`, `offers.md`, `feedback.md`, `proofs.md`, `reviews/*.md`. Never rewrite history.
4. **Don't overwrite** — only overwrite when the agent explicitly corrects existing info. Connectors.md is the lone exception (it's canonical state).
5. **Create on first use** — if `nyoa-context/` or `nyoa-workspace/` doesn't exist when a skill needs it, scaffold it from `plugins/nyoa/assets/workspace-template/`.
6. **Connector branching** — read `nyoa-context/connectors.md`. If a verified MCP is `yes`, offer to use it (always confirm). If `no` or `not-verified-as-of-2025`, fall back to file-only behavior.

The canonical format spec lives at `plugins/nyoa/references/context-formats.md`. Update that file when changing the format.

---

## Voice resolution order (mandatory pattern)

Every skill that produces user-visible copy must resolve voice in this order:

1. **Per-agent voice file** — look for `agents/<agent-name>/voice.md` or `voice.md` in the working directory. If present, match exactly.
2. **`nyoa-context/voice.md`** — if the shared context has voice preferences, use them.
3. **Property-tone preset** (listing-related skills only) — see `nyoa-listing-copy/references/voice-presets.md` for `luxury`, `starter`, `investor`, `fixer`, `land`.
4. **NYOA house style** — fallback. Warm, specific, confident, no clichés.

End every output with: "Voice used: <agent name | preset name | NYOA house>".

---

## Compliance baseline (mandatory in every skill)

Every skill that produces user-visible content must run a compliance pass before delivering:

### Fair Housing red flags (always strip)

- "Great for families", "perfect for kids", "family neighborhood", "growing family"
- "Walk to church / synagogue / mosque" → "walk to [main street name]"
- "Christian / Jewish / Muslim community", any ethnic / religious neighborhood claim
- "Bachelor pad", "perfect for newlyweds", "couples retreat"
- "Exclusive" (when paired with protected class)
- "Great schools" (without source — only "in [district] district" if verifiable)
- "Quiet [ethnic] neighborhood"
- "Handicap accessible" → use specific ADA features ("single-level", "step-free entry", "wide doorways")

### Other mandatory rules

- **"Master bedroom"** → always replace with "primary bedroom"
- **No unsourced structural claims** — never assert "fully renovated", "new roof / HVAC / electrical" unless agent confirmed. Soften or remove.
- **No invented facts** — awards, years in business, team size, statistics, testimonials. Use `[VERIFY FACT]` for uncertain claims, `[INSERT PROOF]` for needed-but-missing testimonials.
- **No invented MCP server names** — `/nyoa-connect` only records connectors we can verify (detected in session, or confirmed publicly via official MCP registry / vendor publications). For categories without a verified public MCP (CRM, e-sign, SMS, MLS), record the gap and use file-only fallback.
- **No clichés** — strip "stunning", "must see", "nestled", "boasts", "rare opportunity", "luxury living awaits", "don't miss". Replace with concrete specifics.

If the **agent's own input** contains a Fair Housing violation, surface it explicitly: "I flagged 'great for families' in your input — Fair Housing risk. Rewriting around the lifestyle without the demographic claim."

The canonical Fair Housing red-flag list lives at `nyoa-listing-copy/references/voice-presets.md`. Reference it from new skills rather than duplicating.

---

## Hooks

The plugin ships one hook today: a SessionStart nudge.

**Location:** `plugins/nyoa/hooks/hooks.json` + `plugins/nyoa/hooks/session-start.sh`.

**Behavior:** if the working directory has `nyoa-context/` or `nyoa-workspace/` but `nyoa-context/profile.md` is missing, print a one-line message telling the agent to run `/nyoa-setup`. Otherwise stay silent so it doesn't pollute non-NYOA sessions.

**Why a separate `.sh` file:** the hook command lives in a real shell script (not inline in `hooks.json`) to avoid JSON-vs-shell quote-escaping pain. Adding more hooks should follow the same pattern — one script per hook, referenced from `hooks.json`.

**Hook contract for adding new ones:**
- Stay silent in non-NYOA directories. Never print unconditionally.
- Don't write files — hooks are nudges, not actions.
- POSIX-shell only. Don't assume bash, zsh, or any specific tool. Cowork's runtime varies.

---

## Adding a new skill

1. **Create the directory:** `plugins/nyoa/skills/nyoa-<skill>/`
2. **Write SKILL.md** following the section order above. Match the canonical pattern of `nyoa-listing-copy/SKILL.md` for content skills, or `nyoa-client-add/SKILL.md` for workspace skills.
3. **Add references and templates** as needed under `references/` and `assets/templates/`.
4. **Cross-reference shared infrastructure:**
   - Voice presets → `nyoa-listing-copy/references/voice-presets.md`
   - Channel conventions (SMS / email / voicemail) → `nyoa-buyer-seller-comms/references/channel-conventions.md`
   - Shared context formats → `plugins/nyoa/references/context-formats.md`
   - Workspace templates → `plugins/nyoa/assets/workspace-template/`
5. **Decide workspace integration.** If the skill produces user-visible content for a listing or client, write through to the relevant workspace folder when present. Always fall back gracefully when the workspace doesn't exist.
6. **Bump version** in `plugins/nyoa/.claude-plugin/plugin.json` AND `.claude-plugin/marketplace.json` (both must match — schema validators enforce this).
7. **Update README.md** to list the new skill. The README is the agent-facing doc; if it's not in the README, agents won't discover it.
8. **Test before commit** — install locally in Cowork, smoke-test the skill with a real scenario.
9. **Commit + push** — descriptive commit message starting with `vX.Y.Z:`.

---

## Versioning + release flow

Semantic versioning. Both `marketplace.json` and `plugin.json` must have the same version.

- **Patch (0.5.0 → 0.5.1):** README updates, doc fixes, prompt tweaks within an existing skill, template wording changes
- **Minor (0.5.x → 0.6.0):** New skill, breaking template change, new reference file structure, new hook
- **Major (0.x.x → 1.0.0):** Reserved for first stable release

**Important:** Cowork's auto-update only re-pulls when the version changes. README-only changes still need a version bump or agents won't see them on next sync.

### Release commit message template

```
vX.Y.Z: <one-line summary>

<paragraph explaining what changed and why>

<bullet list of new / changed / removed items if applicable>

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
```

---

## Cowork distribution gotchas

These are the issues that have actually bitten us in production:

### "Page refresh" ≠ "re-sync"

Refreshing the Cowork browser tab does NOT re-pull from GitHub. To force a re-sync:
1. Open **Marketplaces** view
2. Click **Update** on the **NYOA marketplace card**
3. Wait for that to complete
4. Click **Update** on the **`nyoa` plugin**

If still stale, remove and re-add the marketplace.

### Marketplace `name` must be lowercase

Cowork's schema validator requires lowercase. We tried `"name": "NYOA"` once (v0.3.0) and Cowork sync failed silently. Reverted to `"name": "nyoa"` in v0.3.1. Don't change this without testing the validator.

### Auto-update is OFF by default

Third-party marketplaces don't auto-update unless the agent toggles it on. The README walks them through it. Assume most agents won't have it on, so include the manual update path in any troubleshooting docs.

### Version must match across both manifests

If `marketplace.json` says `0.5.1` but `plugin.json` says `0.5.0`, Cowork sometimes accepts the install but reports the wrong version. Always update both atomically in the same commit.

---

## Git hygiene

### Google Drive `Icon\r` corruption

This repo lives inside a Google Drive folder. Google Drive sprinkles 0-byte `Icon\r` files (filename ends in literal CR character) throughout directories — including `.git/refs/`. When this happens, `git fetch` fails with `fatal: bad object refs/Icon?`.

**Prevention:** the `.gitignore` excludes `Icon`, `Icon?`, `Icon*` patterns.

**Recovery if it happens:**

```bash
find .git/refs -name 'Icon*' -size 0 -delete
git fetch origin
```

Safe to delete because they're 0-byte files inside `.git/refs/` that don't correspond to any real ref.

### What never to commit

- `.env` / `.env.local` — already in `.gitignore`
- `.DS_Store`, `Icon*`, `._*` — macOS / Drive metadata
- Real client testimonials with names — agents add these to their own `nyoa-context/proofs.md` locally, never in the public plugin repo
- Real listing addresses or contract details from actual transactions
- Agent-specific voice files (those live in the agent's own working directory)
- Real `nyoa-workspace/` content from any agent's actual book of business

### Push flow

Always:

1. `git fetch origin` first to check for divergence
2. If diverged, `git pull --rebase origin main` (resolve conflicts on `marketplace.json` / `plugin.json` versions)
3. Then push

The remote has been updated independently in the past (see git log for v0.3.0 / v0.3.1 / README rewrites David committed directly). Don't assume local is authoritative without fetching.

---

## What goes where (decision tree)

| Adding / changing... | Goes in... |
|---------------------|-----------|
| End-user install instructions, skill list, examples | `README.md` |
| Dev conventions, lessons learned, "how to add a skill" | This file (`CLAUDE.md`) |
| Skill behavior / prompts / workflows | `plugins/nyoa/skills/nyoa-<skill>/SKILL.md` |
| Output structure (Markdown, table format) | `plugins/nyoa/skills/nyoa-<skill>/assets/templates/<thing>.md` |
| Reference data the skill reads (rubrics, presets, examples) | `plugins/nyoa/skills/nyoa-<skill>/references/<thing>.md` |
| Shared format spec used by multiple skills | `plugins/nyoa/references/<thing>.md` |
| Workspace template files | `plugins/nyoa/assets/workspace-template/...` |
| Hooks (SessionStart, PreToolUse, etc.) | `plugins/nyoa/hooks/hooks.json` + `hooks/<hook-name>.sh` |
| Marketplace-level metadata (name, description, tags) | `.claude-plugin/marketplace.json` |
| Plugin-level metadata (version, keywords) | `plugins/nyoa/.claude-plugin/plugin.json` |

---

## In scope (what's now considered NYOA's responsibility)

As of v0.5.0, NYOA is a real estate operating system. The following are in scope:

- **Stateful workspace operations** — reading and writing `nyoa-workspace/` files; tracking pipeline state, timelines, calendars, tasks; weekly reviews. Skills can be stateful as long as state lives in markdown files in the agent's working directory.
- **Onboarding and connector detection** — guiding the agent through first run, recording which MCPs they have available, branching skill behavior accordingly.
- **Workspace write-through from content skills** — listing-copy / listing-presentation / social-content / buyer-seller-comms drop their canonical output into `nyoa-workspace/` so the workspace is the source of truth.
- **MCP-aware skills** — skills should read `nyoa-context/connectors.md` and offer to use connectors when available, but never require them.

## Out of scope (intentionally not in this plugin)

These were considered and rejected:

- **Real-time external data fetches without an agent-installed MCP** — NYOA does not ship MCP servers, only consume the ones the agent has wired up. We won't bundle Gmail / Calendar / DocuSign / CRM integrations because their auth is per-agent and the MCP landscape changes.
- **Daily Briefing / new-listing alerts via MLS** — needs MLS API integration, regionally fragmented, gated. Lives as a standalone SaaS product, not a Claude skill.
- **Transaction checklists at state-specific compliance level** — too state-specific and brokerage-specific. The generic checklist in `assets/workspace-template/templates/closing-checklist.md` is intentionally generic.
- **Standalone CMA generator with auto-pulled comps** — needs MLS API for real comp pulls. Comp analysis is embedded in `nyoa-listing-presentation` where the agent provides their own comps (or files them in `listings/<slug>/comps.md`).
- **Naming made-up MCP servers** — see compliance baseline. `/nyoa-connect` records only verified, public MCPs. If we don't know it exists, we don't name it.

If a feature requires real-time external data and there's no verified public MCP for it, NYOA's answer is: keep state in `nyoa-workspace/` markdown, let the agent paste / export into it, and use what's there. When a verified MCP appears, the relevant skill gets a connector branch.
