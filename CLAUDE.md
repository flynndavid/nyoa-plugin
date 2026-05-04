# CLAUDE.md — NYOA Plugin Dev Guide

> Read this before adding, editing, or refactoring skills in this repo.

This is a Claude Code / Cowork plugin marketplace shipping AI skills for real estate agents. It distributes via GitHub: agents add `https://github.com/flynndavid/nyoa-plugin` as a marketplace in Cowork and install the `nyoa` plugin.

The end-user audience is real estate agents — not developers. Skills must be invocable by typing a slash command in plain English; output must be copy-paste ready into MLS systems, social media, email, and CRM tools.

---

## Repo structure

```
nyoa-plugin/
├── .claude-plugin/marketplace.json    # Marketplace metadata (Cowork pulls this first)
├── README.md                           # End-user docs (agent-facing, install + usage)
├── CLAUDE.md                           # This file — dev guide
└── plugins/nyoa/
    ├── .claude-plugin/plugin.json     # Plugin manifest
    ├── references/
    │   └── context-formats.md         # Shared nyoa-context/ format spec
    └── skills/
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
8. **Output format** — what the skill returns and in what format
9. **Shared context** (if applicable) — what `nyoa-context/` files it reads/writes
10. **Reference files** — links to `references/` and `assets/templates/`

End every output with a "Voice used: <agent name | NYOA house>" or equivalent attribution line.

---

## Shared `nyoa-context/` directory

Five of the eight skills share an agent-identity layer:

```
nyoa-context/
├── profile.md      # Business name, services, locations, differentiators
├── voice.md        # Tone and style preferences
├── proofs.md       # Testimonials, awards, stats
├── competitors.md  # Competitor research
└── feedback.md     # Accumulated corrections from the agent
```

**Skills that use it:** `nyoa-aeo`, `nyoa-listing-presentation`, `nyoa-offer-analyzer`, `nyoa-social-content`, `nyoa-testimonial-engine`.
**Skills that don't:** `nyoa-listing-audit`, `nyoa-listing-copy`, `nyoa-buyer-seller-comms` (these are pre-context-layer; can be retrofitted later).

**Rules for skills using nyoa-context:**

1. **Read before asking** — always check if context files exist and use them before asking the agent for info.
2. **Auto-save new info** — when the agent provides a testimonial, voice preference, service, etc., save it without asking. Confirm after saving: "Saved to your [file]. This will be used in future content."
3. **Don't overwrite** — append. Only overwrite when the agent explicitly corrects existing info.
4. **Create on first use** — if `nyoa-context/` doesn't exist, create it.

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
- "Walk to church/synagogue/mosque" → "walk to [main street name]"
- "Christian/Jewish/Muslim community", any ethnic/religious neighborhood claim
- "Bachelor pad", "perfect for newlyweds", "couples retreat"
- "Exclusive" (when paired with protected class)
- "Great schools" (without source — only "in [district] district" if verifiable)
- "Quiet [ethnic] neighborhood"
- "Handicap accessible" → use specific ADA features ("single-level", "step-free entry", "wide doorways")

### Other mandatory rules

- **"Master bedroom"** → always replace with "primary bedroom"
- **No unsourced structural claims** — never assert "fully renovated", "new roof/HVAC/electrical" unless agent confirmed. Soften or remove.
- **No invented facts** — awards, years in business, team size, statistics, testimonials. Use `[VERIFY FACT]` for uncertain claims, `[INSERT PROOF]` for needed-but-missing testimonials.
- **No clichés** — strip "stunning", "must see", "nestled", "boasts", "rare opportunity", "luxury living awaits", "don't miss". Replace with concrete specifics.

If the **agent's own input** contains a Fair Housing violation, surface it explicitly: "I flagged 'great for families' in your input — Fair Housing risk. Rewriting around the lifestyle without the demographic claim."

The canonical Fair Housing red-flag list lives at `nyoa-listing-copy/references/voice-presets.md`. Reference it from new skills rather than duplicating.

---

## Adding a new skill

1. **Create the directory:** `plugins/nyoa/skills/nyoa-<skill>/`
2. **Write SKILL.md** following the section order above. Match the canonical pattern of `nyoa-listing-copy/SKILL.md`.
3. **Add references and templates** as needed under `references/` and `assets/templates/`.
4. **Cross-reference shared infrastructure:**
   - Voice presets → `nyoa-listing-copy/references/voice-presets.md`
   - Channel conventions (SMS/email/voicemail) → `nyoa-buyer-seller-comms/references/channel-conventions.md`
   - Shared context formats → `plugins/nyoa/references/context-formats.md`
5. **Bump version** in `plugins/nyoa/.claude-plugin/plugin.json` AND `.claude-plugin/marketplace.json` (both must match — schema validators enforce this).
6. **Update README.md** to list the new skill. The README is the agent-facing doc; if it's not in the README, agents won't discover it.
7. **Test before commit** — install locally in Cowork, smoke-test the skill with a real scenario.
8. **Commit + push** — descriptive commit message starting with `vX.Y.Z:`.

---

## Versioning + release flow

Semantic versioning. Both `marketplace.json` and `plugin.json` must have the same version.

- **Patch (0.4.0 → 0.4.1):** README updates, doc fixes, prompt tweaks within an existing skill, template wording changes
- **Minor (0.4.x → 0.5.0):** New skill, breaking template change, new reference file structure
- **Major (0.x.x → 1.0.0):** Reserved for first stable release

**Important:** Cowork's auto-update only re-pulls when the version changes. README-only changes still need a version bump or agents won't see them on next sync.

### Release commit message template

```
vX.Y.Z: <one-line summary>

<paragraph explaining what changed and why>

<bullet list of new/changed/removed items if applicable>

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
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

If `marketplace.json` says `0.4.1` but `plugin.json` says `0.4.0`, Cowork sometimes accepts the install but reports the wrong version. Always update both atomically in the same commit.

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
- `.DS_Store`, `Icon*`, `._*` — macOS/Drive metadata
- Real client testimonials with names — agents add these to their own `nyoa-context/proofs.md` locally, never in the public plugin repo
- Real listing addresses or contract details from actual transactions
- Agent-specific voice files (those live in the agent's own working directory)

### Push flow

Always:

1. `git fetch origin` first to check for divergence
2. If diverged, `git pull --rebase origin main` (resolve conflicts on `marketplace.json` / `plugin.json` versions)
3. Then push

The remote has been updated independently in the past (see git log for v0.3.0 / v0.3.1 / README rewrites David committed directly). Don't assume local is authoritative without fetching.

---

## What goes where (decision tree)

| Adding/changing... | Goes in... |
|---------------------|-----------|
| End-user install instructions, skill list, examples | `README.md` |
| Dev conventions, lessons learned, "how to add a skill" | This file (`CLAUDE.md`) |
| Skill behavior / prompts / workflows | `plugins/nyoa/skills/nyoa-<skill>/SKILL.md` |
| Output structure (Markdown, table format) | `plugins/nyoa/skills/nyoa-<skill>/assets/templates/<thing>.md` |
| Reference data the skill reads (rubrics, presets, examples) | `plugins/nyoa/skills/nyoa-<skill>/references/<thing>.md` |
| Shared format spec used by multiple skills | `plugins/nyoa/references/<thing>.md` |
| Marketplace-level metadata (name, description, tags) | `.claude-plugin/marketplace.json` |
| Plugin-level metadata (version, keywords) | `plugins/nyoa/.claude-plugin/plugin.json` |

---

## Out of scope (intentionally not in this plugin)

These were considered and rejected:

- **Daily Briefing / new-listing alerts** — needs MLS API integration. Lives as a standalone SaaS product, not a Claude skill.
- **Transaction checklists** — too state-specific and brokerage-specific. Better served by the agent's TC software (dotloop, SkySlope).
- **Standalone CMA generator** — needs MLS API for real comp pulls. Comp analysis is embedded in `nyoa-listing-presentation` where the agent provides their own comps.
- **Agent branding skill** — absorbed into `nyoa-aeo` (profile.md) and `nyoa-listing-presentation` (Why-Me section). Separate skill would overlap.

If a feature requires real-time external data (MLS feeds, market data APIs, CRM integrations), it belongs in a SaaS product, not a Claude skill. Skills are best for stateless transformations of agent-provided input.
