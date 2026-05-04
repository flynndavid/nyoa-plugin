---
name: nyoa-weekly-review
description: End-of-week review for a real estate agent — reads the workspace pipeline, timelines, calendar, and tasks, then writes a one-page review with wins, slipped tasks, next week's top 3, and overdue follow-ups. Use this skill when an agent says "weekly review", "end-of-week wrap-up", "plan next week", "how was my week", or on a recurring weekly basis. Triggers on phrases like "weekly review", "week wrap-up", "plan my week", "how did this week go".
---

# Weekly Review

A Friday wrap-up + Monday plan in one. Reads everything that changed in the workspace this week and produces a one-page review the agent can scan in under two minutes.

## When this skill triggers

- "Weekly review" / "wrap up my week" / "how did this week go"
- "Plan next week" / "what should I focus on next week"
- Friday afternoon / Monday morning recurring usage

## Inputs you need

Nothing. Reads the workspace.

## Workflow

### 1. Define the window

Default: the last 7 days ending today. If the agent specifies otherwise ("review last 2 weeks"), honor it.

### 2. Gather inputs

Read:

- `nyoa-workspace/pipeline.md` — current stages, counts.
- `nyoa-workspace/clients/*/timeline.md` — every entry with a timestamp inside the window.
- `nyoa-workspace/listings/*/showings.md` and `*/offers.md` — every entry inside the window.
- `nyoa-workspace/calendar.md` — events this week (held vs missed) and next week.
- `nyoa-workspace/tasks.md` — completed-this-week and still-open.
- Last week’s review (`nyoa-workspace/reviews/<previous YYYY-MM-DD>.md`) if it exists — used to check whether last week’s "top 3" actually got done.

### 3. Synthesize

Produce these sections, in this order:

#### Wins

- Closed deals this week
- Listings going live
- Offers accepted
- New clients added
- Reviews received
- Anything from feedback.md tagged as a win

#### Slipped

- Last week’s top 3 that didn’t happen — surface them with the original commitment and propose a re-commit.
- Calendar events that were canceled / no-shows.
- Open tasks past their due date.

#### Pipeline movement

- Net new entries (added)
- Stage moves (lead→active, active→UC, UC→closed)
- Stale-but-not-yet-cold (warning list)

#### Overdue follow-ups

Use the same staleness rule as `/nyoa-pipeline` (lead >14d, active >7d, listing >30d, UC >5d). For each, propose one specific follow-up the agent can run next week.

#### Next week — Top 3

Three concrete, time-boxed actions, ranked by leverage. Pull from:

- Highest-value stale entry that just needs a nudge.
- Any closing tasks from `templates/closing-checklist.md` due this week.
- Any "go-live" listing that needs copy or social.
- Recurring asks from `templates/follow-up-cadence.md`.

Format: `1. <action> — by <day> — context: <client/listing folder>`.

#### Numbers

A tiny scoreboard:

```
This week: <new leads> new · <stage moves> moves · <closes> closes · <reviews> reviews
Pipeline: <leads> leads · <active> active · <under-contract> UC
```

### 4. Write the file

Save the review to `nyoa-workspace/reviews/<YYYY-MM-DD>.md` (today’s date, ISO format). Don’t overwrite if the same-day review exists — append a `-2`, `-3` suffix.

Also append any new "Next week top 3" items to `nyoa-workspace/tasks.md` so they’re tracked.

### 5. Capture learnings

If the agent reflects on the week and shares a learning during the conversation (e.g., "open houses on Thursdays don’t work for my market"), append it to `nyoa-context/feedback.md` under `## Preferences`. Don’t ask permission — confirm afterward.

## Compliance pass

- Use first names + last initial when summarizing clients (the review file is local but may be shared).
- Don’t expose lockbox codes, license numbers, or financial details in the summary.
- If a slipped task involves a sensitive client situation, summarize neutrally.

## Output format

The review file is the primary deliverable. Print it to the agent inline, then confirm: `Saved to nyoa-workspace/reviews/<YYYY-MM-DD>.md`.

End with: `Voice used: NYOA house`.

## Shared context

Reads pipeline.md, all timeline/showing/offer logs, calendar.md, tasks.md, last week’s review, `nyoa-context/feedback.md`. Writes today’s review file, appends to tasks.md and feedback.md.

## Reference files

- `plugins/nyoa/assets/workspace-template/templates/follow-up-cadence.md` — source of cadence asks for the top 3
- `plugins/nyoa/assets/workspace-template/templates/closing-checklist.md` — source of closing tasks
- `plugins/nyoa/references/context-formats.md` — timeline / showing / offer entry formats
