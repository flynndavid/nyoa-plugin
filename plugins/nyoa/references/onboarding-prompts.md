# In-Flow Onboarding Prompts

When a skill encounters missing context — a voice file that doesn't exist, a pipeline with no entries, a profile that's empty — it shouldn't fail silently or demand a separate setup run. It should offer to capture that information right now, in context.

This document defines the standard re-prompting patterns for each missing context type.

## When to use in-flow capture

Use in-flow capture when:
- A skill needs data from `nyoa-context/` or `nyoa-workspace/` that doesn't exist yet.
- The missing data is small enough to capture in 1–3 questions without derailing the current task.
- The agent is already in a productive context (drafting copy, logging an interaction, checking the pipeline).

Don't interrupt for in-flow capture if:
- The missing data would require a full interview (suggest `/nyoa-setup` instead).
- The skill can produce a useful default output without the data (just do it, note the assumption).

## Pattern: missing voice.md

**Context:** A content skill (listing-copy, buyer-seller-comms, social-content, etc.) is about to generate copy but `nyoa-context/voice.md` doesn't exist.

**Prompt template:**
> "I don't have your voice preferences on file yet — takes 60 seconds to set. Quick version: pick a tone:
> (a) Warm + conversational — approachable, contractions, like a knowledgeable friend
> (b) Professional + polished — confident, minimal contractions, formal closer
> (c) Bold + direct — short sentences, action verbs, no hedging
> (d) Data-driven analyst — numbers-first, cite sources, measured
> (e) Luxury concierge — elevated diction, understated confidence, selective details
> (f) Other — paste 2–3 sentences in your own voice
>
> I'll proceed with NYOA house style in the meantime and update your voice file once you choose."

**On response:** Write the choice to `nyoa-context/voice.md` immediately. Confirm: "Saved to nyoa-context/voice.md — I'll use this in all future sessions." Then resume the original task with the correct voice.

## Pattern: missing profile.md

**Context:** A skill needs the agent's business name, market, or differentiators but `nyoa-context/profile.md` is empty or missing.

**Prompt template:**
> "I don't have your business profile yet. Two quick questions:
> 1. What's your business name as it should appear in marketing?
> 2. What market(s) do you serve?
>
> If you want to fill in your full profile — differentiators, ideal client, services — run `/nyoa-setup identity` when you have a few minutes. For now I'll use what you give me."

**On response:** Write the provided details to `nyoa-context/profile.md`. Confirm: "Saved to nyoa-context/profile.md." Resume the task.

## Pattern: missing nyoa-workspace/

**Context:** A skill tries to write to or read from `nyoa-workspace/` but the directory doesn't exist.

**Prompt template:**
> "You don't have a NYOA workspace set up yet. I can scaffold one now — it takes about 10 seconds and creates the folder structure for clients, listings, and pipeline. Want me to do that? (If you'd rather do the full onboarding interview, run `/nyoa-setup`.)"

**On response (yes):** Scaffold from `plugins/nyoa/assets/workspace-template/`. Write `nyoa-context/_meta.json` with `schema_version: "0.6.0"`. Confirm: "Workspace created at nyoa-workspace/." Resume the task.

**On response (no):** Proceed without writing to workspace. Deliver output inline only.

## Pattern: client not found in workspace

**Context:** The agent references a client by name and no matching folder exists in `nyoa-workspace/clients/`.

**Prompt template:**
> "I don't have [Name] in your workspace yet. Want me to create a quick profile for them? I'll just need:
> 1. Buyer or seller?
> 2. Current stage (lead / active / under-contract)?
> 3. A quick note on where things stand.
>
> Or run `/nyoa-client-add [Name]` for the full intake."

**On response:** Create the folder and files from the client template. Add to `pipeline.md`. Confirm file paths. Resume original task with workspace integration active.

## Pattern: listing not found in workspace

**Context:** The agent references a listing address and no matching folder exists in `nyoa-workspace/listings/`.

**Prompt template:**
> "I don't have [address] in your workspace yet. Want me to create a listing file? I'll need:
> 1. List price
> 2. Beds / baths / sqft (rough is fine)
> 3. Status (active / coming-soon / under-contract)?
>
> Or run `/nyoa-listing-add [address]` for the full intake."

**On response:** Create the folder from the listing template. Add to `pipeline.md`. Confirm file paths. Resume with workspace integration.

## Pattern: schema mismatch (v0.5.x workspace)

**Context:** A skill reads `nyoa-context/` and finds no `_meta.json` but `profile.md` exists — this is a v0.5.x workspace.

**Prompt template (inline, one sentence):**
> "Your NYOA workspace predates v0.6.0 — run `/nyoa-setup migrate` to upgrade (non-destructive, under a minute). Continuing with what's available."

Do **not** block the current task. Deliver the output. Surface the migration nudge at the end of the response.

## General rules

1. **One question at a time.** Don't dump a full intake form when two questions will do.
2. **Always proceed.** In-flow capture should never block delivery. State the assumption, deliver the output, ask for the data after.
3. **Auto-save without asking permission.** When the agent provides data during in-flow capture, save it immediately. Confirm the file path afterward.
4. **Reference `/nyoa-setup` for deep onboarding.** If the missing context suggests the agent is new, end with: "Run `/nyoa-setup` when you have a few minutes for the full onboarding."
