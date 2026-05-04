# NYOA — Not Your Ordinary Agent

A preconfigured Claude for real estate agents. Install once, get three skills:

- **`/nyoa-listing-audit`** — Score any listing and (optionally) generate a polished HTML demo page with the photos saved locally. Works with a Zillow / Redfin / Realtor.com / MLS URL or pasted MLS remarks.
- **`/nyoa-listing-copy`** — Turn a property fact sheet into a full launch package: MLS remarks, long description, X / Instagram posts, and a buyer email blast. Tunable to your voice.
- **`/nyoa-buyer-seller-comms`** — Draft the recurring messages you send every week: buyer drips, seller updates, offer summaries, follow-ups, referral asks. SMS / email / voicemail variants.

All three enforce Fair Housing compliance automatically (no protected-class language, no unsourced structural claims, "primary bedroom" not "master") and strip the usual real-estate clichés ("stunning", "must see", "nestled", "boasts").

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

That's it. The three slash commands (`/nyoa-listing-audit`, `/nyoa-listing-copy`, `/nyoa-buyer-seller-comms`) are now available in any Claude conversation.

### 3. Turn on auto-update (recommended)

By default, third-party marketplaces don't auto-update. To get future improvements automatically:

1. Open the **Marketplaces** view.
2. Select **NYOA**.
3. Toggle **Enable auto-update** on.

When this is on, Cowork checks the GitHub repo at the start of each session and pulls in any new version published by David. You'll see a notification if anything was updated.

If you'd rather update manually, leave auto-update off and click **Update** on the marketplace card whenever you want the latest version.

---

## Try it (5-minute test)

Open a new Claude conversation and try each one:

**Listing audit:**
> Audit this listing: https://www.zillow.com/homedetails/[any-real-listing]

You should get an 8-dimension scorecard, a list of "kill issues", and a "what I'd do first" 3-bullet action list.

**Listing copy:**
> Write listing copy for 123 Maple St, East Nashville. $625K, 3 bed, 2 bath, 2,400 sqft. Built 1924. Quartz counters, six-burner Wolf range, original white oak floors, walk-up attic already wired for an office, fenced yard with screened back porch. Open house Sunday 1–3.

You should get MLS remarks, a long description, three social variants, and a new-listing email blast — all in one response.

**Buyer/seller comms:**
> Draft a price-drop note to my buyers watching East Nashville. The house is 312 Maple, dropped from $649K to $619K, and four of them walked it last Tuesday.

You should get an SMS variant and an email variant ready to copy/paste.

---

## Use it well

### Make it sound like you, not generic NYOA

The skills look for a per-agent voice file before falling back to the NYOA house style. To install yours:

1. Drop a markdown file at `agents/<your-name>/voice.md` in whatever folder Claude has access to.
2. In it, write a few paragraphs about how you talk: tone, words you use, words you'd never say, signature phrases, sign-off style. Including 2–3 examples of past listing copy you wrote and liked is the fastest way.
3. Tell Claude where it is the first time you use a skill: "Use my voice file at `~/Documents/voice.md`."

After that, every output adapts to your voice automatically.

### What the listing audit can do with photos

If you ask for a "demo page" or "visual rebuild" of a listing, the skill will:
1. Pull the listing photos from the URL (works best with the Firecrawl MCP installed; falls back to WebFetch or asking you to paste image URLs).
2. Save the photos to a local `listings/<address>/images/` folder.
3. Generate a self-contained HTML demo page with those photos, redesigned copy, and the NYOA navy/gold visual style — perfect for showing a seller "here's what your listing could look like."

If photos aren't accessible (some MLS portals block scrapers), the skill will tell you and ask you to paste image URLs or upload the photos.

---

## Updating

If auto-update is on (step 3 above), there's nothing to do — Cowork pulls new versions at session start.

If auto-update is off, click **Update** on the NYOA marketplace card whenever you want the latest version, then click **Update** on the `nyoa` plugin if a new version is available.

---

## Troubleshooting

**"Marketplace sync failed"** — Most often a `marketplace.json` schema validation error after a recent update. Wait a beat and try sync again, or DM David.

**Slash commands not appearing after install** — In Cowork, refresh the page. In Claude Code CLI, run `/reload-plugins`.

**Listing audit can't read a Zillow page** — Zillow blocks most scrapers. Either install the Firecrawl MCP (handles JS rendering) or paste the MLS remarks + photo URLs into chat directly.

**Anything else** — DM David (`david@automatic.so`).

---

## What's inside (for the curious)

```
nyoa-plugin/
├── .claude-plugin/marketplace.json
└── plugins/nyoa/
    ├── .claude-plugin/plugin.json
    └── skills/
        ├── nyoa-listing-audit/
        ├── nyoa-listing-copy/
        └── nyoa-buyer-seller-comms/
```

Each skill has a `SKILL.md` (the instructions Claude follows), an `assets/templates/` folder (output structures), and a `references/` folder (rubrics, voice presets, channel rules).

---

## Author

Built by [Automatic](https://davidflynn.co). Distribution lead: Ann-Riley Caldwell · SimpliHOM, Nashville.

## License

MIT — yours to use, fork, modify.
