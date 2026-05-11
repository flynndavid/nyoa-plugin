# NYOA Shared Context + Workspace

NYOA skills share two persistent locations in the agent's working folder:

1. **`nyoa-context/`** — business identity (who the agent is). Stable, slow-changing.
2. **`nyoa-workspace/`** — daily operating data (what the agent is working on). Active, fast-changing.

Any skill can read from and write to either tree.

## nyoa-context/ — directory structure

```
nyoa-context/
├── _meta.json      # Schema version, workspace backend, setup state (written by /nyoa-setup)
├── profile.md      # Business identity — name, services, locations, differentiators
├── voice.md        # Tone and style preferences for the agent's brand voice
├── proofs.md       # Testimonials, awards, stats, certifications
├── competitors.md  # Competitor research and notes
├── feedback.md     # Accumulated corrections and preferences from the agent
└── connectors.md   # Which MCPs / external tools the agent has wired up (written by /nyoa-connect)
```

The directory starts empty and builds organically. `/nyoa-setup` is the fastest way to populate it. `_meta.json` is created by `/nyoa-setup` and is the sole file that carries `schema_version`.

## nyoa-workspace/ — directory structure

```
nyoa-workspace/
├── clients/<slug>/         # profile.md, timeline.md, preferences.md, documents.md
├── listings/<slug>/        # property.md, copy.md, comps.md, showings.md, offers.md,
│                           # photos.md, deadlines.md (v0.7), marketing/ (v0.7)
├── market-updates/         # YYYY-MM.md per month (v0.7 — blog + IG + email package)
├── web/neighborhoods/      # <slug>.md per neighborhood (v0.7 — landing pages)
├── finance/<YYYY-MM>/      # receipts.md, settlement-<slug>.md, mileage.md (v0.7)
├── pipeline.md             # leads / active / under-contract / closed kanban
├── calendar.md             # showings, follow-ups, deadlines
├── tasks.md                # open todos
├── templates/              # agent's saved snippets
└── reviews/                # weekly review write-ups + audit reports (YYYY-MM-DD.md)
```

The canonical template tree lives at `plugins/nyoa/assets/workspace-template/`. `/nyoa-setup` and the workspace skills scaffold from it on first use.

## Slug rule

Lowercase, dash-separated, ASCII only. Strip punctuation. Examples:

- `Jane Doe` → `jane-doe`
- `O'Connor Family` → `oconnor-family`
- `123 Maple St, East Nashville` → `123-maple-st-east-nashville`

If a slug already exists, append `-2`, `-3`, etc.

## _meta.json format

`nyoa-context/_meta.json` is the workspace manifest. It is the only file in `nyoa-context/` that carries `schema_version`. Other context files are human-edited markdown with no version field.

```json
{
  "schema_version": "0.6.0",
  "installed_at": "YYYY-MM-DD",
  "setup": {
    "setup_complete": false,
    "setup_last_round_completed": 0,
    "setup_completed_at": null
  },
  "workspace": {
    "backend": "local",
    "root_path": "."
  },
  "agent": {
    "name": null,
    "brokerage": null
  }
}
```

Field reference:
- `schema_version` — the NYOA plugin version that wrote this file. Used by the session-start hook and `/nyoa-setup migrate` to detect stale workspaces.
- `installed_at` — ISO date (YYYY-MM-DD) when the workspace was first created.
- `setup.setup_complete` — `true` once all setup rounds are finished.
- `setup.setup_last_round_completed` — integer 0–8; used by `/nyoa-setup resume` to pick up mid-session.
- `setup.setup_completed_at` — ISO date or null.
- `workspace.backend` — always `"local"` in v0.6. Reserved values: `"gdrive"`, `"notion"` (v0.7+).
- `workspace.root_path` — `"."` for local backend (relative to cwd). Non-local backends will use a URI.
- `agent.name` — agent's full marketing name; populated in Setup Round 2.
- `agent.brokerage` — brokerage name; populated in Setup Round 2.

Skills must write `_meta.json` as valid JSON. Never write markdown to this file.

## Which skills read/write each context file

| File | Read by | Written by |
|------|---------|------------|
| profile.md | nyoa-aeo, nyoa-listing-presentation, nyoa-social-content, nyoa-testimonial-engine, nyoa-setup | nyoa-setup, nyoa-aeo (auto-save), agent manual updates |
| voice.md | nyoa-aeo, nyoa-listing-copy, nyoa-listing-presentation, nyoa-social-content, nyoa-buyer-seller-comms, nyoa-setup | nyoa-setup, nyoa-aeo (auto-save), agent manual updates |
| proofs.md | nyoa-aeo, nyoa-listing-presentation, nyoa-social-content, nyoa-testimonial-engine, nyoa-setup | nyoa-setup, nyoa-aeo (auto-save), nyoa-testimonial-engine (primary writer) |
| competitors.md | nyoa-aeo (head-to-head articles), nyoa-setup | nyoa-setup, nyoa-aeo (auto-save), agent manual updates |
| feedback.md | All skills (for tone/style corrections) | All skills (append-only) |
| connectors.md | All skills (to know which MCPs are available) | nyoa-connect (primary writer) |

## Which skills read/write each workspace location

| Location | Read by | Written by |
|----------|---------|------------|
| clients/<slug>/ | nyoa-buyer-seller-comms, nyoa-pipeline, nyoa-weekly-review, nyoa-log, nyoa-touch-cadence, nyoa-database-audit | nyoa-client-add (creates), nyoa-log (timeline append), nyoa-buyer-seller-comms (timeline append), nyoa-touch-cadence (timeline section append), nyoa-database-audit (segment tag append on profile) |
| listings/<slug>/ | nyoa-listing-audit, nyoa-listing-copy, nyoa-listing-presentation, nyoa-social-content, nyoa-pipeline, nyoa-open-house, nyoa-contract-deadlines, nyoa-bookkeeping (settlement) | nyoa-listing-new (creates), nyoa-listing-copy (copy.md write-through), nyoa-listing-presentation (copy.md write-through), nyoa-offer-analyzer (offers.md append), nyoa-open-house (marketing/ folder), nyoa-contract-deadlines (deadlines.md), nyoa-bookkeeping (offers.md cross-link to settlement) |
| listings/<slug>/deadlines.md | nyoa-pipeline, nyoa-weekly-review | nyoa-contract-deadlines (primary writer — appends, never overwrites) |
| listings/<slug>/marketing/ | nyoa-listing-copy (for cross-reference) | nyoa-open-house (primary writer), nyoa-listing-copy (photoshoot-brief.md when requested) |
| market-updates/<YYYY-MM>.md | nyoa-market-update (reads prior months), nyoa-social-content (can reference for narrative continuity), nyoa-neighborhood-page (for FAQ data points) | nyoa-market-update (primary writer — one file per month) |
| web/neighborhoods/<slug>.md | nyoa-aeo (for AEO article cross-linking) | nyoa-neighborhood-page (primary writer) |
| finance/<YYYY-MM>/ | nyoa-bookkeeping (prior months for category consistency) | nyoa-bookkeeping (primary writer — receipts.md, settlement-<slug>.md, mileage.md) |
| pipeline.md | nyoa-pipeline, nyoa-weekly-review | nyoa-client-add, nyoa-listing-new, nyoa-pipeline, nyoa-log (last-activity refresh), nyoa-contract-deadlines, nyoa-open-house, nyoa-database-audit (snapshot section), nyoa-neighborhood-page (content-shipped note), nyoa-bookkeeping (settlement-filed note) |
| calendar.md | nyoa-weekly-review, nyoa-contract-deadlines (reads prior entries), nyoa-bookkeeping (mileage mode) | nyoa-pipeline, nyoa-buyer-seller-comms (when scheduling), nyoa-contract-deadlines, nyoa-open-house, nyoa-market-update |
| tasks.md | nyoa-weekly-review | any skill that surfaces a follow-up (incl. nyoa-contract-deadlines, nyoa-open-house, nyoa-touch-cadence, nyoa-database-audit, nyoa-neighborhood-page) |
| templates/ | nyoa-buyer-seller-comms | agent manual + nyoa-setup |
| reviews/ | nyoa-weekly-review (next week reads last week), nyoa-database-audit (prior audits for year-over-year diffs) | nyoa-weekly-review (primary writer), nyoa-database-audit (database-audit-YYYY-MM-DD.md) |

## Context file formats

### profile.md

```markdown
# Business Profile

## Business Name
[Exact name as it should appear in all content]

## Services
- [Service 1]
- [Service 2]
- [Service 3]

## Locations Served
- [City 1]
- [City 2]

## Ideal Clients
[Description of target customers]

## Key Differentiators
- [What makes this agent/business unique]
- [Specific expertise, process, or credential]
```

### voice.md

```markdown
# Voice & Style Preferences

## Tone
[e.g., Warm and conversational, Professional but approachable]

## Style Notes
- [e.g., Use contractions]
- [e.g., Sound like a knowledgeable friend]

## Words/Phrases to Use
- [Preferred terminology]

## Words/Phrases to Avoid
- [Terms to skip]
```

### proofs.md

```markdown
# Testimonials & Proof Elements

## Testimonials

### [Client Name/Initials] — [Service Type]
"[Quote]"
Source: [Google review, Zillow, video transcription, verbal — agent paraphrase, etc.]
Permission: [yes / pending / paraphrased]
Tags: [service types this testimonial supports]

## Awards & Certifications
- [Award 1]
- [Certification 1]

## Stats
- [Relevant statistic, e.g., "150+ homes sold in Nashville since 2018"]
```

### competitors.md

```markdown
# Competitor Research

## [Competitor Name]
- Website: [URL]
- Years in business: [number]
- Review rating: [stars] ([count] reviews)
- Specialties: [list]
- Notes: [anything notable]
- Source: [web search / user provided]
- Last updated: [date]
```

### feedback.md

```markdown
# Agent Feedback & Corrections

## Style Corrections
- [Date]: [Correction made]

## Factual Corrections
- [Date]: [What was corrected]

## Preferences
- [Date]: [Preference noted]
```

### connectors.md (v0.6 format)

```markdown
# Connectors

The MCP servers / external tools this agent has available, captured by `/nyoa-connect`.
Other skills branch on this — skills declare which **capability** they need; this file records what's wired up and what the agent prefers.

## Detected (verified MCPs available in this session)
- google-workspace: [yes / no] — namespace: <observed prefix, e.g. mcp__google__*>
- firecrawl: [yes / no] — namespace: <observed prefix>
- slack: [yes / no] — namespace: <observed prefix>
- notion: [yes / no] — namespace: <observed prefix>
- github: [yes / no] — namespace: <observed prefix>
- brave-search: [yes / no] — namespace: <observed prefix>
- puppeteer: [yes / no] — namespace: <observed prefix>

## Built-in tools
- WebFetch: [yes / no]
- WebSearch: [yes / no]

## Stack we tracked but can't verify a public MCP for
- crm: <name agent uses or "none"> — mcp: not-verified-as-of-2025
- e-sign: <name or "none"> — mcp: not-verified-as-of-2025
- sms: <name or "none"> — mcp: not-verified-as-of-2025
- mls: <name or "none"> — mcp: not-verified-as-of-2025

## User-stated preferences
- email: <google-workspace | outlook | none | not-set>
- calendar: <google-workspace | outlook | none | not-set>
- docs: <google-workspace | notion | none | not-set>
- sms: <tool name or "none">
- crm: <tool name or "none">
- team-comms: <slack | none | not-set>

## NYOA usage (what NYOA does when each capability is present)
- email: nyoa-buyer-seller-comms and nyoa-listing-copy offer to push drafts directly to the agent's email client
- calendar: nyoa-pipeline and nyoa-weekly-review offer to sync deadlines and showings as calendar events
- docs: nyoa-listing-copy, nyoa-listing-presentation can save canonical copies to cloud storage
- sms: nyoa-buyer-seller-comms offers to send SMS drafts via the agent's SMS tool
- crm: nyoa-log and nyoa-buyer-seller-comms offer to log interactions to the CRM contact record
- web-scrape: nyoa-listing-audit uses Firecrawl or Puppeteer for Zillow/Redfin/Realtor.com scrapes
- team-comms: future — not yet used by any skill

## Notes
- (any agent-specific configuration that other skills should know)

Last updated: YYYY-MM-DD
```

## Workspace file formats

Each workspace file has a template under `plugins/nyoa/assets/workspace-template/` with the canonical structure. Skills reading or writing workspace files should match the template's headers exactly so other skills can parse them.

Key conventions:

- **Append-only logs**: `clients/<slug>/timeline.md`, `listings/<slug>/showings.md`, `listings/<slug>/offers.md`, `feedback.md`, and `reviews/*.md` — never rewrite history.
- **Pipeline entries** point at the canonical folder: `[Jane Doe](clients/jane-doe/) — buyer — last activity 2025-05-04 — next: send pre-approval reminder by 2025-05-06`.
- **Last updated** stamp at the bottom of `pipeline.md` and `calendar.md`.

## Rules for All Skills

1. **Read before writing** — always check if context/workspace files exist and use them before asking the agent for info.
2. **Auto-save new info** — when an agent volunteers new info during any skill interaction, save it without asking permission. Confirm afterward ("Saved to clients/jane-doe/profile.md").
3. **Don't overwrite** — append new info to logs. Only overwrite when the agent explicitly corrects existing info.
4. **Create on first use** — if `nyoa-context/` or `nyoa-workspace/` doesn't exist when a skill needs it, create the directory and the relevant file(s) from `plugins/nyoa/assets/workspace-template/`.
5. **Connector branching** — read `nyoa-context/connectors.md`. If a connector exists, prefer it. If not, fall back to file-only behavior (paste, attach, manual entry).
6. **Voice attribution** — every user-facing output ends with `Voice used: <agent name | preset name | NYOA house>`.
