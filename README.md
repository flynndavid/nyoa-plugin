# NYOA — Not Your Ordinary Agent

A preconfigured Claude for real estate agents — a real operating system for your day-to-day, not just a content tool. Install once, get **19 skills + a local workspace + an onboarding flow** that handles the work agents do every day.

### Onboarding, daily workflow & workspace hygiene
- **`/nyoa-setup`** — Guided onboarding. 8-round interview that populates your `nyoa-context/` (profile, voice, proofs, competitors) and scaffolds your `nyoa-workspace/`. Supports `$ARGUMENTS` modes: `/nyoa-setup resume`, `/nyoa-setup migrate`, `/nyoa-setup voice`, `/nyoa-setup identity`, and more. Run this first.
- **`/nyoa-client-add`** — Add a buyer / seller / lead. Creates a structured client folder (profile, timeline, preferences, documents) and registers them on the pipeline.
- **`/nyoa-listing-add`** — Add a new listing. Creates a structured property folder (facts, copy, comps, showings, offers, photos) and registers it on the pipeline.
- **`/nyoa-pipeline`** — See and edit your book of business. Stage-by-stage summary, surfaces stale leads, lets you move clients between stages. Writes rolling "Recent logs" and "Stale items" sections to `pipeline.md` on each run.
- **`/nyoa-weekly-review`** — Friday wrap-up + Monday plan. Reads your week and writes a one-pager: wins, slips, top 3 next week, overdue follow-ups.
- **`/nyoa-log`** — "I just talked to Jane about Tuesday's showing." Lowest-friction way to keep timelines current; auto-routes to the right client / listing folder and refreshes the pipeline's recent-activity feed.
- **`/nyoa-connect`** — Detect which MCP integrations you have (Google Workspace, Notion, Slack, Firecrawl, etc.) and document them so other skills can branch on availability. Honest about what we know exists — never names made-up integrations.
- **`/nyoa-help`** — The NYOA help system. Lists skills filtered by your workspace state, explains any skill on demand, and displays step-by-step workflow recipes. Try `/nyoa-help workflow new-buyer` or `/nyoa-help workflow new-listing`.
- **`/nyoa-doctor`** — Workspace health check. Audits schema version, setup completeness, connectors state, and stale pipeline items. Tells you exactly what's missing and what to run to fix it.
- **`/nyoa-find`** — Search your entire workspace. Grep across all markdown in `nyoa-workspace/` and `nyoa-context/` and get matches with file paths and surrounding context.
- **`/nyoa-archive`** — Clean up your pipeline view. Moves Closed entries older than 90 days to an Archive section in `pipeline.md`. Folders are never touched.

### Listing workflow
- **`/nyoa-listing-presentation`** — Win the listing appointment. Generate a complete seller pitch: market narrative from your comps, comp summary table, pricing strategy with rationale, marketing plan, and "Why Me" section. Reads `nyoa-workspace/` for property facts + filed comps.
- **`/nyoa-listing-audit`** — Score any listing and (optionally) generate a polished HTML demo page with the photos saved locally. Works with a Zillow / Redfin / Realtor.com / MLS URL or pasted MLS remarks.
- **`/nyoa-listing-copy`** — Turn a property fact sheet into a full launch package: MLS remarks, long description, X / Instagram posts, and a buyer email blast. Tunable to your voice. Writes through to `nyoa-workspace/listings/<slug>/copy.md` so the canonical copy is always current.

### Client communications
- **`/nyoa-buyer-seller-comms`** — Draft the recurring messages you send every week: buyer drips, seller updates, offer summaries, follow-ups, referral asks. SMS / email / voicemail variants. Logs interactions to client timelines automatically.
- **`/nyoa-offer-analyzer`** — Paste a contract → get a plain-English seller briefing. Auto-extracts price, financing, earnest, contingencies, etc. Compares multiple offers side-by-side. Drafts counter-offer talking points.

### Brand & lead gen
- **`/nyoa-aeo`** — Get recommended by ChatGPT, Perplexity, and Gemini. Generate AI-optimized articles using the four-type framework: Best Choice, Reasons to Choose, Local Service, Head-to-Head.
- **`/nyoa-social-content`** — A week of social content that isn't tied to a specific listing. Market commentary, neighborhood spotlights, buyer / seller tips, behind-the-scenes, engagement posts, testimonial features. Per-platform formatting (Instagram / X / Facebook / LinkedIn).
- **`/nyoa-testimonial-engine`** — Collect, catalog, and repurpose testimonials. Turn a Google review into an AEO proof element, a social post, a listing-presentation pull-quote. Generate review-request emails and SMS for post-close outreach.

All skills enforce **Fair Housing compliance** automatically (no protected-class language, no unsourced structural claims, "primary bedroom" not "master") and strip the usual real-estate clichés ("stunning", "must see", "nestled", "boasts").

---

## What's new in v0.6.0

v0.6 lays the architectural foundation for everything that comes next — workspace abstraction, schema versioning, a help system, and hygiene tools so the workspace stays useful over time.

- **Workspace schema versioning** — `nyoa-context/_meta.json` tracks `schema_version`, `workspace.backend`, and setup state. Future backends (Google Drive, Notion) can be added in v0.7 without changing any skill code.
- **Setup refactor** — `/nyoa-setup` now has 8 rounds (new Round 1 confirms the workspace location) and supports `$ARGUMENTS` dispatch: `/nyoa-setup resume` picks up where you left off; `/nyoa-setup migrate` upgrades a v0.5.x workspace non-destructively; `/nyoa-setup voice`, `/nyoa-setup identity`, and other per-round modes let you update any piece without re-running the full interview.
- **Help system** — `/nyoa-help` lists relevant skills filtered by what's active in your workspace, explains any skill on demand, and serves 6 step-by-step workflow recipes (new-buyer, new-listing, under-contract, open-house, listing-not-selling, first-month).
- **Hygiene tools** — `/nyoa-doctor` audits schema, setup completeness, connectors, and stale items. `/nyoa-find` greps your entire workspace. `/nyoa-archive` retires old closed deals to an archive section in pipeline.md — folders untouched.
- **Rolling pipeline sections** — `/nyoa-pipeline` and `/nyoa-log` now maintain a "Recent logs (last 7d)" and "Stale items" feed at the bottom of `pipeline.md`, so every session starts with full context.
- **Capability requirements** — all 8 content skills now declare which external capabilities they use (email, calendar, docs, sms, crm, web-scrape) and follow a consistent connector-branching rule: stated preference wins; if ambiguous, the skill asks; if nothing available, it falls back to file-only behavior.
- **SessionStart hook enhanced** — the session-start script now also nudges to `/nyoa-setup migrate` if it detects a v0.5.x workspace (no `_meta.json`).

### Upgrading from v0.5.0

Run `/nyoa-setup migrate` in your workspace directory. It takes under a minute and is fully non-destructive — backups land in `nyoa-workspace/.backups/v0.5-to-v0.6/<date>/`.

## What's new in v0.5.0

NYOA grew from a content toolbelt into a real estate operating system. The big shift: every skill now has a **place to put things** (`nyoa-workspace/`) and a **way to find what's already there** (`nyoa-context/`). Past sessions compound; future sessions start with full context.

---

## Install (Cowork — claude.ai)

This is the path most NYOA agents will use.

### 1. Add the NYOA marketplace

1. Open [claude.ai](https://claude.ai) and go to your plugin / marketplace settings.
2. Click **Add marketplace**.
3. Paste this URL: `https://github.com/flynndavid/nyoa-plugin`
4. Click **Sync**.

You should see the **NYOA** marketplace appear in your list.

### 2. Install the `nyoa` plugin

In the marketplace's plugin list, find **nyoa** and click **Install**. Toggle it on if it isn't already.

That's it. All slash commands are now available in any Claude conversation.

### 3. Turn on auto-update (recommended)

By default, third-party marketplaces don't auto-update. To get future improvements automatically:

1. Open the **Marketplaces** view.
2. Select **NYOA**.
3. Toggle **Enable auto-update** on.

When this is on, Cowork checks the GitHub repo at the start of each session and pulls in any new version published by David. You'll see a notification if anything was updated.

If you'd rather update manually, leave auto-update off and click **Update** on the marketplace card whenever you want the latest version.

### Already installed an earlier version? Force a re-sync

If you don't see the new skills after a release:

1. Open the **Marketplaces** view.
2. Click **Update** on the NYOA marketplace card (not just refresh — a page refresh doesn't re-pull from GitHub).
3. Then click **Update** on the `nyoa` plugin itself.
4. After the update completes, the new slash commands should appear in your conversation autocomplete.

If they still don't appear, remove and re-add the marketplace using the same URL — that forces a full re-sync.

---

## First time? Run these three things

1. **`/nyoa-setup`** — 8 short rounds of questions. End state: your `nyoa-context/` and `nyoa-workspace/` are populated with your business identity and any active clients / listings. Interrupted mid-session? Run `/nyoa-setup resume` to pick up where you left off.
2. **`/nyoa-connect`** — records which integrations you have (Google Workspace, Notion, Slack, Firecrawl) so other skills know what they can offer.
3. **`/nyoa-help`** — see what's available and what NYOA recommends based on your workspace state. Or `/nyoa-help workflow first-month` for a 4-week onboarding ramp.

From there, every interaction adds to your workspace. Future you (and future Claude sessions) will thank present you.

---

## Try it (10-minute test)

Open a new Claude conversation and try a few:

**Onboarding:**
> /nyoa-setup

You'll get a 7-round interview. Answer as much or as little as you want — every round saves before the next, so you can quit any time and resume later.

**Listing presentation:**
> I have a listing appointment tomorrow at 312 Maple St in East Nashville. Target list price is $625K. Comps: 405 Maple sold $612K (similar layout, smaller lot), 218 Cedar sold $649K (updated kitchen, 100 sqft larger), 89 Walnut sold $598K (no updates, comparable size). Help me prepare a presentation.

You should get a market narrative, comp table, pricing strategy, marketing plan, and value-prop section — all in one response. If you've added the property via `/nyoa-listing-add` first, the skill will read filed comps automatically.

**Listing audit:**
> Audit this listing: https://www.zillow.com/homedetails/[any-real-listing]

You should get an 8-dimension scorecard, a list of "kill issues", and a "what I'd do first" 3-bullet action list.

**Listing copy:**
> Write listing copy for 123 Maple St, East Nashville. $625K, 3 bed, 2 bath, 2,400 sqft. Built 1924. Quartz counters, six-burner Wolf range, original white oak floors, walk-up attic already wired for an office, fenced yard with screened back porch. Open house Sunday 1-3.

You should get MLS remarks, a long description, three social variants, and a new-listing email blast — and if you have a workspace, the canonical copy lands in `nyoa-workspace/listings/<slug>/copy.md`.

**Buyer / seller comms:**
> Draft a price-drop note to my buyers watching East Nashville. The house is 312 Maple, dropped from $649K to $619K, and four of them walked it last Tuesday.

You should get an SMS variant and an email variant ready to copy / paste. If those buyers exist as clients in your workspace, the message gets logged to each one's timeline automatically.

**Offer analyzer:**
> Analyze this offer: [paste a real offer or summary of terms]. Listing was at $625K.

You should get a plain-English summary, key terms extracted, strengths and weaknesses, and a recommendation — pre-formatted for emailing the seller.

**AEO content:**
> Write a Best Choice article: "Who's the best realtor in East Nashville for first-time buyers?"

The skill will gather context if it doesn't have it (business name, services, locations — or read from `nyoa-context/profile.md` if you've run `/nyoa-setup`), then draft an 800-1,200 word article in third person, AI-optimized for ChatGPT and Perplexity to recommend you.

**Social content:**
> Give me 5 social posts for this week. I'm a Nashville realtor specializing in East Nashville and Germantown. Focus on Instagram and X.

You should get a 5-day content calendar with platform-specific copy.

**Testimonial engine:**
> Add this testimonial — "Working with Ann-Riley was the smoothest closing I've ever had. She caught two issues with the inspection report I would've missed." — from Sarah M., a buyer client. Then turn it into an Instagram post.

The skill saves to your proof bank and generates a narrative social post.

**Daily workflow:**
> /nyoa-log talked to Jane this morning, she's pre-approved at $650k

> /nyoa-pipeline

> /nyoa-weekly-review

These three are the core daily loop. `/nyoa-log` files a one-sentence interaction. `/nyoa-pipeline` shows you everything in flight and surfaces what's gone stale. `/nyoa-weekly-review` produces a Friday wrap-up + Monday plan, saved under `nyoa-workspace/reviews/`.

---

## Use it well

### Make it sound like you, not generic NYOA

The skills look for your voice in this order:

1. A per-agent voice file at `agents/<your-name>/voice.md` (if you point Claude at one).
2. `nyoa-context/voice.md` (auto-populated by `/nyoa-setup`).
3. NYOA house style.

The fastest way to calibrate: paste 2-3 samples of your own writing during `/nyoa-setup` Round 2. NYOA learns from those.

### Shared agent context

NYOA stores two persistent things in your working folder:

```
nyoa-context/                # Business identity — stable, slow-changing
├── profile.md
├── voice.md
├── proofs.md
├── competitors.md
├── feedback.md
└── connectors.md            # Which MCPs you have wired up

nyoa-workspace/              # Daily operating data — active, fast-changing
├── clients/<slug>/          # profile, timeline, preferences, documents
├── listings/<slug>/         # property, copy, comps, showings, offers, photos
├── pipeline.md
├── calendar.md
├── tasks.md
├── templates/
└── reviews/                 # weekly review write-ups
```

Both start empty and fill in as you work. Add a testimonial via `/nyoa-testimonial-engine` and it becomes available in `/nyoa-aeo` articles, `/nyoa-listing-presentation` value-prop sections, and `/nyoa-social-content` spotlight posts. Add a client via `/nyoa-client-add` and `/nyoa-buyer-seller-comms` will read their preferences automatically when drafting messages.

You can also edit any of these files manually. They're plain markdown.

### What the listing audit can do with photos

If you ask for a "demo page" or "visual rebuild" of a listing, the skill will:
1. Pull the listing photos from the URL (works best with the Firecrawl MCP installed; falls back to WebFetch or asking you to paste image URLs).
2. Save the photos to a local `listings/<address>/images/` folder.
3. Generate a self-contained HTML demo page with those photos, redesigned copy, and the NYOA navy / gold visual style — perfect for showing a seller "here's what your listing could look like."

If photos aren't accessible (some MLS portals block scrapers), the skill will tell you and ask you to paste image URLs or upload the photos.

### Connect your tools (optional, not required)

NYOA works fully offline-style as a local markdown system. But if you have any of these MCP integrations wired up in Claude Code, NYOA will offer to use them:

- **Google Workspace** (Gmail / Calendar / Drive) — official Google MCP. Drafts emails to Gmail, syncs deadlines as Calendar events, stores docs in Drive.
- **Slack** — Anthropic reference MCP. Team comms.
- **Notion** — official Notion MCP. Mirror your workspace into Notion if you prefer that as your daily UI.
- **Firecrawl** — official Firecrawl MCP. Used by `/nyoa-listing-audit` for Zillow / Redfin / Realtor.com scrapes.

For anything else (CRM, e-sign, SMS, MLS), the workflow stays markdown-based in `nyoa-workspace/`. NYOA won't recommend an MCP it can't verify exists.

Run `/nyoa-connect` after install to record what you have.

---

## Updating

If auto-update is on (step 3 above), there's nothing to do — Cowork pulls new versions at session start.

If auto-update is off, click **Update** on the NYOA marketplace card whenever you want the latest version, then click **Update** on the `nyoa` plugin if a new version is available.

---

## Troubleshooting

**"Skills missing after update"** — A page refresh doesn't re-pull from GitHub. Click **Update** on the marketplace card (not the plugin), wait for it to complete, then update the plugin itself. If still missing, remove and re-add the marketplace.

**"Marketplace sync failed"** — Most often a `marketplace.json` schema validation error after a recent update. Wait a beat and try sync again, or DM David.

**Slash commands not appearing after install** — In Cowork, refresh the page after the marketplace + plugin updates have both completed. In Claude Code CLI, run `/reload-plugins`.

**Listing audit can't read a Zillow page** — Zillow blocks most scrapers. Either install the Firecrawl MCP (handles JS rendering) or paste the MLS remarks + photo URLs into chat directly.

**SessionStart nudge keeps appearing (profile missing)** — You have a NYOA workspace folder but `nyoa-context/profile.md` doesn't exist. Run `/nyoa-setup` to populate it; the nudge will stop.

**SessionStart nudge about v0.6 migration** — You have a v0.5.x workspace (no `nyoa-context/_meta.json`). Run `/nyoa-setup migrate` to upgrade; it takes under a minute and is non-destructive.

**Anything else** — DM David (`david@automatic.so`).

---

## What's inside (for the curious)

```
nyoa-plugin/
├── .claude-plugin/marketplace.json
└── plugins/nyoa/
    ├── .claude-plugin/plugin.json
    ├── hooks/
    │   ├── hooks.json                     # SessionStart hook
    │   └── session-start.sh
    ├── assets/
    │   └── workspace-template/            # scaffolded by /nyoa-setup
    │       └── nyoa-context/
    │           └── _meta.json             # workspace manifest template (v0.6)
    ├── migrations/
    │   └── 0.6.0/index.md                 # v0.5.x → v0.6.0 migration guide
    ├── references/
    │   ├── context-formats.md             # nyoa-context/ + nyoa-workspace/ schemas
    │   ├── workspace-io.md                # workspace I/O contract (v0.6)
    │   ├── onboarding-prompts.md          # in-flow capture patterns
    │   └── workflows/                     # 6 step-by-step workflow recipes
    └── skills/
        ├── nyoa-setup/                    ← refactored in v0.6.0
        ├── nyoa-client-add/
        ├── nyoa-listing-add/
        ├── nyoa-pipeline/                 ← rolling sections added in v0.6.0
        ├── nyoa-weekly-review/
        ├── nyoa-log/                      ← recent-logs refresh added in v0.6.0
        ├── nyoa-connect/                  ← v0.6 connectors format
        ├── nyoa-help/                     ← new in v0.6.0
        ├── nyoa-doctor/                   ← new in v0.6.0
        ├── nyoa-find/                     ← new in v0.6.0
        ├── nyoa-archive/                  ← new in v0.6.0
        ├── nyoa-listing-audit/
        ├── nyoa-listing-copy/
        ├── nyoa-buyer-seller-comms/
        ├── nyoa-listing-presentation/
        ├── nyoa-offer-analyzer/
        ├── nyoa-aeo/
        ├── nyoa-social-content/
        └── nyoa-testimonial-engine/
```

Each skill has a `SKILL.md` (the instructions Claude follows), and where appropriate an `assets/templates/` folder (output structures) and a `references/` folder (rubrics, voice presets, channel rules, article specs, content type examples).

---

## Author

Built by [Automatic](https://davidflynn.co). Distribution lead: Ann-Riley Caldwell · SimpliHOM, Nashville.

## License

MIT — yours to use, fork, modify.
