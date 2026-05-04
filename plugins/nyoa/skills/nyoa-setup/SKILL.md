---
name: nyoa-setup
description: Guided onboarding for a real estate agent new to NYOA. Interviews the agent about their business, voice, current pipeline, and tools, then populates nyoa-context/ and scaffolds nyoa-workspace/ so every other NYOA skill works immediately. Use this skill when an agent says "set me up", "onboard me", "help me get started", "first time using this", "build my profile", or runs NYOA for the first time. Triggers on phrases like "setup", "onboarding", "get started", "new agent", "build my workspace", or when nyoa-context/ does not yet exist.
---

# NYOA Setup

Get an agent from zero to a fully-populated NYOA workspace in one session. After this skill runs, every other NYOA skill has the context it needs and the agent has a real operating system on disk.

## When this skill triggers

- "Set me up" / "onboard me" / "help me get started"
- "First time using NYOA" / "build my profile" / "build my workspace"
- Agent runs any NYOA skill and `nyoa-context/profile.md` does not exist (offer to run setup first)
- Phrases: "setup", "onboarding", "get started", "new agent"

## Inputs you need

Nothing required up front. The skill conducts an interview. Skip any section the agent doesn't want to answer — partial population is fine, the workspace can be filled in over time.

## Workflow

### 1. Detect prior state

Before asking anything, check what already exists in the working directory:

- Does `nyoa-context/` exist? Which files? Read each one.
- Does `nyoa-workspace/` exist?

If both exist with content, this is a re-run. Confirm with the agent: "Looks like you've been here before. Want me to (a) fill in just the missing pieces, (b) review and update what's there, or (c) start fresh?" Default to (a).

If neither exists, this is a first run — proceed.

### 2. Interview — 7 short rounds

Ask one round at a time. Keep questions tight. Confirm answers as you go. Auto-save after each round so an interrupted session isn't lost.

#### Round 1 — Identity (writes `nyoa-context/profile.md`)

- Full name (as it appears in marketing)
- Brokerage / team
- License # + state
- Years in real estate
- Markets you serve (cities, neighborhoods, zip codes)
- Service types (buyer / seller / investor / luxury / first-time / relocation / commercial / leasing)
- Ideal client (1–2 sentences)
- Top 2–3 differentiators (what makes you different from other agents in your market)

#### Round 2 — Voice (writes `nyoa-context/voice.md`)

- Pick a tone: warm + conversational / professional + polished / bold + direct / data-driven analyst / luxury concierge / other
- Paste 2–3 examples of your own writing (a past listing description, a recent email, a social post). NYOA will use these to learn your voice.
- Words/phrases you love
- Words/phrases you avoid ("nestled", "boasts", "must-see", etc. are blocked house-wide already)

#### Round 3 — Proof (writes `nyoa-context/proofs.md`)

- Top 3 testimonials (paste them; or paste links and we'll fetch)
- Awards / designations / certifications
- Stats you're proud of (e.g., "150 homes sold in East Nashville since 2018")

#### Round 4 — Competitors (writes `nyoa-context/competitors.md`)

- Top 3 agents/teams you compete with by name (so AEO head-to-head content can be sharpened later)
- Optional: their websites

#### Round 5 — Pipeline snapshot (writes `nyoa-workspace/pipeline.md` + scaffolds folders)

For each currently-active client or listing, capture:

- Type: buyer / seller / listing / closed (last 12 months)
- Name (or address for listings)
- Stage: lead / active / under-contract / closed
- Last activity (rough date is fine)
- Next step

For every entry, scaffold the matching folder from `plugins/nyoa/assets/workspace-template/clients/_template/` or `listings/_template/` and pre-fill what was just shared. Add a row to `pipeline.md` pointing at the folder.

#### Round 6 — Templates (optional, writes `nyoa-workspace/templates/`)

- Do you have go-to email templates you reuse? (intro emails, open-house follow-ups). Paste them; we'll save them under `templates/`.
- Skip if none — the workspace ships with starter templates.

#### Round 7 — Tools (delegates to /nyoa-connect)

- Which of these do you use day-to-day: Gmail, Google Calendar, Google Drive / Dropbox, DocuSign, Twilio (SMS), a CRM (Follow Up Boss / HubSpot / Salesforce / kvCORE / Sierra), an MLS portal?
- Don't probe deeper here — tell the agent: "Run `/nyoa-connect` next and I'll detect what's wired up and write `nyoa-context/connectors.md`."

### 3. Scaffold the workspace

If `nyoa-workspace/` does not exist, create it from `plugins/nyoa/assets/workspace-template/`:

- Copy every file/folder *except* the `_template/` subfolders under `clients/` and `listings/` (those are templates that get copied per-entry).
- Replace `{{client_name}}`, `{{address}}`, etc. placeholders only when scaffolding a specific client or listing folder.
- Leave the workspace's top-level `pipeline.md`, `calendar.md`, `tasks.md` empty-headed (just the section headings) unless Round 5 produced entries.

### 4. Personalized next steps

Based on what the agent filled in, return a tailored “Next 3 things to try” list. Examples:

- If they have any **active listings** with no copy: “You have N active listings. Run `/nyoa-listing-audit <address>` for the weakest one, then `/nyoa-listing-copy` to rewrite it.”
- If they have **any closed transactions in the last 90 days** without testimonials: “You closed N deals recently and only have X testimonials. Run `/nyoa-testimonial-engine` to draft review requests.”
- If they listed **competitors**: “Run `/nyoa-aeo head-to-head` against [Top Competitor] to claim that comparison search query.”
- If they didn’t answer Round 6 (templates): “Next time you write a buyer follow-up you’re happy with, paste it and I’ll save it to `templates/intro-emails.md`.”
- Always: “Run `/nyoa-connect` to detect your tools and unlock send-from-Gmail / sync-to-calendar features.”

Rank by leverage — highest-impact suggestion first.

### 5. Confirm and exit

Print a short summary:

```
Set up:
- nyoa-context/ — profile, voice, proofs, competitors
- nyoa-workspace/ — N clients, M listings, pipeline initialized

Next steps:
1. …
2. …
3. …
```

## Compliance pass

- If the agent pasted writing samples that contain Fair Housing red-flag language ("family-friendly", "walk to church", "safe neighborhood", protected-class implications), flag them in voice.md under a `## Phrases to avoid (auto-flagged)` section. Don’t silently strip them — surface so the agent learns.
- License #, lockbox codes, or any other sensitive info pasted by the agent: save only to local files (never to logs, never to outputs the agent shares externally). Remind the agent that `nyoa-workspace/` is a local folder.
- If a competitor is named, never write disparaging language about them — record neutral facts only.

## Output format

Markdown summary at the end (per Step 5). During the interview, plain text questions and short confirmations.

End with: `Voice used: NYOA house` (the agent’s own voice isn’t calibrated yet on first run).

## Shared context

This skill is a primary writer for **all** of:

- `nyoa-context/profile.md`
- `nyoa-context/voice.md`
- `nyoa-context/proofs.md`
- `nyoa-context/competitors.md`

And it scaffolds (but doesn’t write content into) `nyoa-workspace/`. It defers `nyoa-context/connectors.md` to `/nyoa-connect`.

## Reference files

- `plugins/nyoa/references/context-formats.md` — canonical schemas for every file written by this skill
- `plugins/nyoa/assets/workspace-template/` — the workspace skeleton scaffolded in Step 3
