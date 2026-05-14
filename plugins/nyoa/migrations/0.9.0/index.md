# Migration: v0.8.x → v0.9.0

This document describes what changed in NYOA v0.9.0 and the steps existing v0.8.x users should take. It is referenced from `CLAUDE.md`'s compliance baseline and from the v0.9.0 release notes.

## What changed

### Compliance moved to a single delegating skill

In v0.8.x and earlier, every generative skill (`/nyoa-listing-copy`, `/nyoa-social-content`, `/nyoa-buyer-seller-comms`, etc.) ran its own compliance pass — duplicating the same Fair Housing red-flag list across nine SKILL.md files. Updating a rule meant editing every skill.

In v0.9.0 the model flips: a new universal skill, **`/nyoa-compliance-review`**, owns all compliance reasoning. Every other generative skill now delegates to it before delivering output. The canonical rules live at `plugins/nyoa/references/compliance/fair-housing.md` — one file, loaded by the review skill on every run.

The review skill applies Claude's own jurisdictional reasoning rather than a static blocklist:
- **Federal** Fair Housing Act + HUD advertising guidance (always).
- **State and local** rules for the agent's `license_state` (read from `nyoa-context/profile.md`) — state-extended protected classes, license-display rules, AI-disclosure laws where applicable.
- **NAR Code of Ethics** Articles 10 and 12 — only when `nyoa-context/profile.md` records `nar_member: yes`.
- **FTC AI advertising** guidance for AI-generated marketing copy.

This catches paraphrases a fixed string-match list would miss and scales to 50 states without per-state files.

### New audit log

`nyoa-workspace/compliance-log.md` is now seeded automatically the first time `/nyoa-compliance-review` runs. Every review appends one line:

```
<ISO-8601 timestamp> | <calling skill or "standalone"> | <slug or "n/a"> | <APPROVED|FIXED|OVERRIDDEN> | <one-line note>
```

This is the defensibility artifact if a complaint ever lands. Overrides record the agent's one-sentence reason verbatim.

### New `nyoa-context/profile.md` fields

To support state-aware review and NAR-conditional logic, four fields are now captured in `nyoa-context/profile.md` (`license_state` is required; the rest are recommended):

- `license_state` — two-letter state code (e.g. `TN`, `CA`).
- `license_number` — the agent's real estate license number (used in audit log notes and in advertising disclosure where the state requires it).
- `brokerage` — the agent's brokerage (most states require it on advertising). Mirrored to `_meta.json` under `agent.brokerage`.
- `nar_member` — `yes` or `no`. Determines whether NAR Code of Ethics Articles 10 and 12 are applied.

If any of these is missing or blank when `/nyoa-compliance-review` runs, the skill warns the user, runs federal-only review, and nudges them to run `/nyoa-setup identity`.

### No breaking changes to skill interfaces

- Slash commands unchanged. `/nyoa-listing-copy`, `/nyoa-social-content`, `/nyoa-buyer-seller-comms`, etc. all invoke identically.
- Output format unchanged from the caller's perspective — drafts still arrive ready to copy-paste.
- The only new visible behavior is the disclaimer footer appended to every delivered draft, and the audit-log line written to `nyoa-workspace/compliance-log.md`.

## What you need to do

### 1. Re-run `/nyoa-setup` (or `/nyoa-setup identity`)

This is the only required step. The identity round now captures `license_state`, `license_number`, `brokerage`, and `nar_member`. Run it once and every future compliance review picks up the new fields automatically.

```
/nyoa-setup identity
```

If you'd rather edit `nyoa-context/profile.md` directly, add the four fields under your existing identity block.

### 2. (Optional) Try a standalone review

To see the new skill in action, paste any draft into a fresh conversation and run:

```
/nyoa-compliance-review
```

You'll get a structured findings list, a recommended-action menu, and — once you choose — a cleaned draft + disclaimer footer + audit log line.

### 3. (Optional) Inspect the audit log

After your first review, open `nyoa-workspace/compliance-log.md` to see the seeded header and your first entry. The file is append-only — every future review adds one line.

## Rollback

If for any reason you need to revert to the v0.8.x compliance model:
- The generative skills still contain their original compliance-pass sections (Agent 2 updated them in v0.9.0 to delegate, but the underlying rules remain in the canonical reference). Re-enabling per-skill compliance is a matter of editing each SKILL.md.
- The legacy red-flag list still exists at `nyoa-listing-copy/references/voice-presets.md` under the bottom heading, marked as legacy.
- Delete `plugins/nyoa/skills/nyoa-compliance-review/` if you want to remove the new skill entirely. Cowork will pick up the removal on the next marketplace update.

The audit log at `nyoa-workspace/compliance-log.md` is your own — it stays where it is.
