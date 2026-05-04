# NYOA Shared Context + Workspace

NYOA skills share two persistent locations in the agent's working folder:

1. **`nyoa-context/`** — business identity (who the agent is). Stable, slow-changing.
2. **`nyoa-workspace/`** — daily operating data (what the agent is working on). Active, fast-changing.

Any skill can read from and write to either tree.

## nyoa-context/ — directory structure

```
nyoa-context/
├── profile.md      # Business identity — name, services, locations, differentiators
├── voice.md        # Tone and style preferences for the agent's brand voice
├── proofs.md       # Testimonials, awards, stats, certifications
├── competitors.md  # Competitor research and notes
├── feedback.md     # Accumulated corrections and preferences from the agent
└── connectors.md   # Which MCPs / external tools the agent has wired up (written by /nyoa-connect)
```

The directory starts empty and builds organically. `/nyoa-setup` is the fastest way to populate it.

## nyoa-workspace/ — directory structure

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

The canonical template tree lives at `plugins/nyoa/assets/workspace-template/`. `/nyoa-setup` and the workspace skills scaffold from it on first use.

## Slug rule

Lowercase, dash-separated, ASCII only. Strip punctuation. Examples:

- `Jane Doe` → `jane-doe`
- `O'Connor Family` → `oconnor-family`
- `123 Maple St, East Nashville` → `123-maple-st-east-nashville`

If a slug already exists, append `-2`, `-3`, etc.

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
| clients/<slug>/ | nyoa-buyer-seller-comms, nyoa-pipeline, nyoa-weekly-review, nyoa-log | nyoa-client-add (creates), nyoa-log (timeline append), nyoa-buyer-seller-comms (timeline append) |
| listings/<slug>/ | nyoa-listing-audit, nyoa-listing-copy, nyoa-listing-presentation, nyoa-social-content, nyoa-pipeline | nyoa-listing-new (creates), nyoa-listing-copy (copy.md write-through), nyoa-listing-presentation (copy.md write-through), nyoa-offer-analyzer (offers.md append) |
| pipeline.md | nyoa-pipeline, nyoa-weekly-review | nyoa-client-add, nyoa-listing-new, nyoa-pipeline, nyoa-log (last-activity refresh) |
| calendar.md | nyoa-weekly-review | nyoa-pipeline, nyoa-buyer-seller-comms (when scheduling) |
| tasks.md | nyoa-weekly-review | any skill that surfaces a follow-up |
| templates/ | nyoa-buyer-seller-comms | agent manual + nyoa-setup |
| reviews/ | nyoa-weekly-review (next week reads last week) | nyoa-weekly-review (primary writer) |

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

### connectors.md (new)

```markdown
# Connectors

The MCP servers / external tools this agent has available, captured by `/nyoa-connect`.
Other skills branch on this — e.g., if `gmail: yes`, `nyoa-buyer-seller-comms` can offer to send drafts directly.

## Available
- gmail: [yes / no] — server name: <e.g., mcp__gmail__*>
- google-calendar: [yes / no]
- google-drive: [yes / no]
- docusign: [yes / no]
- twilio (sms): [yes / no]
- crm: [name / no] — e.g., follow-up-boss, hubspot, salesforce
- mls: [name / no]
- firecrawl: [yes / no]

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
