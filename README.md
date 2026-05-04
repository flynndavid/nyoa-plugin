# NYOA — Not Your Ordinary Agent (Claude Code / Cowork plugin)

A Claude Code / Cowork plugin marketplace that ships a preconfigured Claude for real estate agents. Three skills, one install.

## What's inside

- **`/nyoa-listing-audit`** — Paste any listing URL (Zillow, Realtor, Redfin, MLS) or address. Get a strategic audit report, an optional Markdown rewrite, and (if photos are available) a self-contained HTML demo listing page with images saved locally.
- **`/nyoa-listing-copy`** — Turn property facts into MLS remarks, a long description, social variants (X / Instagram / Facebook), and an email blast. Tunable to the agent's voice and a property-tone preset (luxury, starter-home, investor, fixer, land).
- **`/nyoa-buyer-seller-comms`** — Templates + on-demand generation for the recurring agent comms loop: buyer drips, seller updates, offer summaries, follow-ups, referral asks. SMS / email / voicemail variants.

## Install (Claude Code)

```bash
/plugin marketplace add flynndavid/nyoa-plugin
/plugin install NYOA@NYOA
```

## Install (Cowork)

Paste `https://github.com/flynndavid/nyoa-plugin` into Cowork's **Add marketplace** dialog → sync → install **nyoa**.

## Use

After install, the skills trigger automatically on prompts like:

- "Audit this Zillow listing: <url>"
- "Write listing copy for 123 Maple St — 4bd/3ba/2400sf, renovated kitchen, fenced yard"
- "Draft a price-drop note to my buyers watching East Nashville"
- "Summarize this offer in plain English for my seller"

## Structure

```
nyoa-plugin/
├── .claude-plugin/
│   └── marketplace.json
├── README.md
└── plugins/
    └── nyoa/
        ├── .claude-plugin/
        │   └── plugin.json
        └── skills/
            ├── nyoa-listing-audit/
            ├── nyoa-listing-copy/
            └── nyoa-buyer-seller-comms/
```

Each skill is self-contained with `SKILL.md`, output templates in `assets/templates/`, and reference material in `references/`.

## Per-agent customization

Skills look for a per-agent voice file at `~/Projects/<workspace>/agents/<agent-name>/voice.md` (or any path the agent points Claude to). When present, listing-copy and buyer-seller-comms write in that voice. When absent, they fall back to the NYOA house style.

## Author

Built by [Automatic](https://davidflynn.co). Distribution lead: Ann-Riley Caldwell · SimpliHOM, Nashville.

## License

MIT
