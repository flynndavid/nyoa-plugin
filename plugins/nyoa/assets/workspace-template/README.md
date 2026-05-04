# NYOA Workspace

This is your real estate operating system. Every NYOA skill reads from and writes to this tree, so the more you use it the smarter it gets.

## Layout

```
nyoa-workspace/
├── clients/<slug>/      # one folder per client (profile, timeline, preferences, documents)
├── listings/<slug>/     # one folder per property (property facts, copy, comps, showings, offers, photos)
├── pipeline.md          # leads / active / under-contract / closed — the kanban
├── calendar.md          # showings, follow-ups, deadlines
├── tasks.md             # open todos with owner + due
├── templates/           # your saved snippets (intro emails, follow-up cadences, closing checklists)
└── reviews/             # weekly review write-ups
```

Slugs are lowercase, dash-separated, ASCII only. Examples: `jane-doe`, `123-maple-st-east-nashville`.

## Conventions

- **Append-only logs**: `timeline.md`, `showings.md`, `offers.md`, and `reviews/*.md` are append-only. Never rewrite history.
- **Single source of truth**: when a skill produces customer-facing copy for a listing, the canonical copy lands in `listings/<slug>/copy.md`.
- **Pipeline mirrors reality**: any time a client moves stages (lead → active → under-contract → closed), `pipeline.md` is updated.
- **No code, no DB**: this is a markdown workspace. Edit by hand, or let any NYOA skill do the writes for you.

## How to start

Run `/nyoa-setup` once. It will populate `nyoa-context/` (your business identity) and scaffold this tree.
