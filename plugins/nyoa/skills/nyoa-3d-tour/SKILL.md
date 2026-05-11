---
name: nyoa-3d-tour
description: Commission, host, embed, and promote a photoreal 3D walkthrough (3D Gaussian Splatting) for a listing. Generates the freelancer brief, the DIY phone-scan checklist, the hosting decision tree, the embed snippets (MLS-safe iframe + link block + QR caption), and the launch-day promotion package (social posts, buyer email, open-house add-on). Files the canonical tour record under listings/<slug>/marketing/3d-tour.md so every other listing skill auto-includes the URL when present. Use this skill when the agent says "3D tour", "virtual tour", "Matterport replacement", "splat scan", "Gaussian splat", "Polycam scan", "scan this house", "I need a 3D walkthrough", "promote my 3D tour", "embed the virtual tour", or when prepping a listing-launch package and the agent wants to add a tour as a marketing line item.
---

# 3D Tour

Stand up a photoreal 3D walkthrough for a listing in one skill. Vendor-default with a DIY phone-scan path. Platform-agnostic hosting (PlayCanvas Supersplat, Polycam, Luma, Matterport, self-host) — the agent picks, NYOA captures the URL and turns it into MLS, web, email, social, and yard-sign deliverables.

The X post hype is real but narrow: 3D Gaussian Splatting (3DGS) won't replace agents. It does replace static photo + Matterport as the default "virtual tour" line item on a marketing plan, for $200–$800 instead of $1,500+. This skill makes adopting it a 30-minute decision instead of a week of research.

## When this skill triggers

- "3D tour for [address]"
- "I want a virtual tour / walkthrough / Matterport for this listing"
- "Splat scan", "Gaussian splat", "Polycam scan", "Luma scan"
- "Find a vendor to scan [address]"
- "I'm going to scan [address] myself — what do I need?"
- "Embed the 3D tour in MLS / my site / the listing page"
- "Promote my 3D tour"
- "Generate social posts for the [address] virtual tour"
- "Add a 3D tour link to the open-house promo / new-listing email"
- Agent gives a tour URL and asks for embed snippets or promo copy

## Inputs you need

Required (varies by mode — see dispatch table):
- **Property address or listing slug** — for every mode.
- **Tour URL** — required for `embed` and `promote` (read from `marketing/3d-tour.md` first, only ask if absent).

Optional but improves output:
- Capture date, vendor name, hosting platform — saved to `marketing/3d-tour.md` for future reference.
- Cost — used for the seller value-framing in `/nyoa-listing-presentation`.
- Agent voice file (for promo copy).
- Open-house date (for the open-house add-on).

If a mode needs an input that isn't there, ask once. Don't fabricate URLs, vendor quotes, or scan dates.

## Voice modes

Promo deliverables (`promote` mode) resolve voice in this order:

1. **Per-agent voice file** — `agents/<agent-name>/voice.md` or `voice.md` in the working directory.
2. **`nyoa-context/voice.md`** — shared business voice.
3. **NYOA house style** — fallback. Specific, plain, anti-cliché.

Vendor briefs (`vendor` mode) and DIY checklists (`capture` mode) use professional/operational tone — these aren't user-facing copy, they're work product. Voice file isn't applied.

## Workflow

### Capability requirements

This skill can use:

- **email** (`google-workspace` or `outlook`): When available, NYOA offers to push the vendor brief or the launch-day promo email to the agent's email client as a draft. Always confirm before sending — never auto-send. Falls back to delivering inline.
- **docs** (`google-workspace` or `notion`): When available, NYOA offers to mirror `marketing/3d-tour.md` to Drive or Notion in addition to the local workspace write-through. Falls back to local file only.
- **web-scrape** (`firecrawl` or equivalent): When available and the agent provided a tour URL, NYOA offers to fetch the OpenGraph preview metadata (image + title) for the social preview-card snippets. Falls back to a placeholder line in the embed snippet.

Read `nyoa-context/connectors.md` and check `User-stated preferences.<capability>`. If set and available, offer to use it — always confirm before sending or syncing. If none available, fall back to file-only behavior silently.

### Dispatch table ($ARGUMENTS)

| Argument | Mode | Purpose |
|----------|------|---------|
| (none) | **Default — guided wizard** | Asks: do you already have a tour URL, are you hiring a vendor, or scanning yourself? Routes to the matching sub-mode. |
| `vendor` | **Vendor brief** | Generates a one-page email the agent sends to a freelance scanner — property facts, access window, deliverable spec, embed-ready output requirement, expected price band. |
| `capture` | **DIY scan guide** | Step-by-step phone-scan instructions for the agent (lighting, room-by-room route, occupancy/staging, app picks). |
| `host` | **Hosting picker** | Walks the agent through `references/hosting-options.md` and helps them pick. Does not create accounts — captures the URL after they upload. |
| `embed` | **Embed snippets** | Given a tour URL, emits MLS virtual-tour-field copy, a `rel="noopener"` iframe for the agent's website, an email-friendly link block, a QR caption for yard signs, and an OpenGraph metadata snippet for social previews. |
| `promote` | **Launch-day promotion package** | Generates 3 social variants (X / IG / FB), a "tour just dropped" buyer email, an open-house add-on insert ("can't make Sunday? walk it now"), and a yard-sign QR caption. Reuses voice resolution from `nyoa-listing-copy`. |

The wizard (default mode) routes as follows:

- "I have a tour URL" → `embed` then `promote`.
- "I'm hiring a vendor" → `vendor`, then come back for `embed` + `promote` after delivery.
- "I'm scanning it myself" → `capture` → `host` → `embed` + `promote` once the URL exists.
- "I don't know yet" → show the cost/value table from `references/vendor-pricing.md`, then ask again.

### Workflow steps (per-mode)

**`vendor` mode:**
1. Resolve the listing — slug the address, read `nyoa-workspace/listings/<slug>/property.md` if present (use the access window, lockbox notes, agent name from there).
2. Render `assets/templates/vendor-brief.md` with property facts.
3. Append a `## Pricing expectation` block from `references/vendor-pricing.md` keyed off square footage tier.
4. Run the compliance pass.
5. Write the brief to `nyoa-workspace/listings/<slug>/marketing/vendor-brief-3d-tour.md` (separate from the canonical `3d-tour.md` because it's a one-time outbound artifact).
6. Offer to push to email if the connector is available.

**`capture` mode:**
1. Resolve the listing.
2. Read `references/scan-prep-checklist.md` and render the per-property version (substitute room-count, has-yard, has-pool from `property.md` when available).
3. Suggest 1–2 apps from `references/hosting-options.md` keyed off the agent's phone (ask if not in `nyoa-context/profile.md`).
4. Deliver inline. No write-through — this is reference material the agent uses on the day of the scan, not a workspace artifact.

**`host` mode:**
1. Read `references/hosting-options.md`.
2. Ask 3 questions: (a) DIY scan or vendor delivery? (b) Want the agent's domain or a third-party URL? (c) Want analytics on tour views?
3. Recommend 1–2 platforms based on answers. Don't pick for them.
4. After they pick and upload, prompt for the URL → route to `embed`.

**`embed` mode:**
1. Resolve the listing.
2. Read tour URL from `nyoa-workspace/listings/<slug>/marketing/3d-tour.md` if present. If missing the URL, ask once.
3. If `web-scrape` connector available and confirmed, fetch OpenGraph image + title from the tour URL.
4. Render `assets/templates/embed-snippets.md` with the URL substituted into:
   - MLS virtual-tour field (just the URL, no formatting — most MLS systems are bare-URL fields)
   - Agent website iframe (`<iframe src="..." loading="lazy" allowfullscreen rel="noopener"></iframe>`)
   - Email link block (HTML-friendly, plain-text fallback)
   - QR caption text ("Scan to walk this house in 3D · [short URL]")
   - OpenGraph meta snippet for social cards
5. Run the compliance pass (URL-only, but check the surrounding caption text).
6. Update `marketing/3d-tour.md` if the URL or hosting platform changed.

**`promote` mode:**
1. Resolve the listing + read `property.md` and `copy.md` for hook phrasing.
2. Resolve voice.
3. Read tour URL from `marketing/3d-tour.md`. If absent, ask once.
4. Draft each promo variant from `assets/templates/promo-*.md`, reusing the listing's existing hook and feature anchors so the tour promo doesn't reinvent the listing voice.
5. Generate the open-house add-on insert keyed off the next open-house date in `nyoa-workspace/listings/<slug>/marketing/` (look for the most recent `open-house-*.md` file).
6. Run the compliance pass.
7. Write the package to `nyoa-workspace/listings/<slug>/marketing/3d-tour-promo-YYYY-MM-DD.md`.
8. Update `marketing/3d-tour.md` with `Last promoted: YYYY-MM-DD`.
9. Offer to push the buyer email to the email connector if available.

## Compliance pass (mandatory before delivering)

Standard NYOA Fair Housing rules apply — see `nyoa-listing-copy/references/voice-presets.md` for the canonical red-flag list. The 3D-tour-specific additions:

- **Occupants in the scan.** Splat scans capture whoever is in frame. Flag any vendor brief or capture checklist output that doesn't include "no occupants in frame; remove personal photos and family photos before scanning". Privacy + Fair Housing both matter — a tour that shows the seller's family on the wall is showing buyers something they shouldn't be seeing.
- **"Walk to church / synagogue / mosque"** captions on tour promo posts — same rule as listing copy.
- **Disability/accessibility claims off the scan** — never assert "wheelchair accessible" or "ADA compliant" because a wheelchair could roll through the splat. Use specific, agent-confirmed features: "step-free entry shown at 0:14 in the tour", "36-inch hallway widths". The scan is evidence, not certification.
- **Address + scan privacy** — for the vendor brief, include the standard scan-prep checklist line: "remove visible mail, prescriptions, financial documents, and visible street numbers from car license plates in the driveway".
- **No invented vendor names** — the skill does not maintain a verified vendor directory. The vendor brief is template + send instructions; the agent sources their own vendor (Craigslist, local photographer network, NextDoor, freelance Polycam/Luma operators on social).
- **No invented capability claims** — never say "tour increases offers by X%" without a citation. Use directional language: "out-of-state buyers can pre-walk before flying in", "serious buyers self-qualify before requesting a showing".
- **"Primary bedroom"** not "master bedroom" in any promo copy.
- **Cliché ban** — strip "stunning", "must see", "nestled", "boasts", "rare opportunity" from promo copy.

If the agent's input contains a Fair Housing red flag, surface it: "I flagged 'great for families to walk through together' in your input — Fair Housing risk. Rewriting around the property tour itself."

## Workspace integration

Primary write target: `nyoa-workspace/listings/<slug>/marketing/3d-tour.md`. One file per listing version (refresh on price drop, re-stage, re-scan; date-stamp the entry in the file's history section but keep the file itself canonical).

If `nyoa-workspace/listings/<slug>/` exists:

- **Create** `marketing/3d-tour.md` from the template if it doesn't exist (modes `vendor`, `capture`, `host`, `embed`, `promote` all write to it).
- **Update** the canonical fields (Tour URL, Capture date, Captured by, Hosting platform, Cost, Last promoted) when those values become known.
- **Append** to a `## History` section in `marketing/3d-tour.md` with one line per touchpoint: `- YYYY-MM-DD — vendor brief sent | scan complete | URL captured | promoted`.
- **Append** a one-liner to `nyoa-workspace/listings/<slug>/copy.md` under `## Revision history`: "YYYY-MM-DD — 3D tour added: [URL]" (only when URL is first captured or changed).
- **Refresh** `pipeline.md` last-activity date for the listing.
- For `vendor` mode specifically, also write `marketing/vendor-brief-3d-tour.md` (the outbound artifact), and append a task to `nyoa-workspace/tasks.md`: "Follow up on 3D tour vendor for [address] — sent YYYY-MM-DD".
- For `promote` mode specifically, also write `marketing/3d-tour-promo-YYYY-MM-DD.md` (one per promo cycle) and append calendar entries for the social drops.

If `nyoa-workspace/listings/<slug>/` does not exist, ask once: "Want me to create `listings/<slug>/` so the tour record and promo packages live with this listing's other marketing?" If yes, defer to `/nyoa-listing-add`. If no (or if `nyoa-workspace/` doesn't exist at all), deliver inline only and skip write-through silently.

## Output format

Single Markdown response. Mode-specific:

- **Wizard / default** — diagnostic Q+A, then routes to the appropriate mode. Don't generate anything yet — confirm the path.
- **`vendor`** — header with property facts, the vendor brief block (copy-pasteable into email), the pricing expectation block, and a "what to ask the vendor for" deliverable-spec checklist.
- **`capture`** — staging checklist, app pick, room-by-room route table, post-scan upload steps. One Markdown response, scannable on a phone.
- **`host`** — recommendation paragraph, side-by-side platform comparison table from `references/hosting-options.md`, "what to do next" CTA.
- **`embed`** — five sections (MLS field / iframe / email link block / QR caption / OG meta), each in its own copy-pasteable code block. End with `marketing/3d-tour.md` write-through confirmation.
- **`promote`** — sections in order: X post · Instagram caption · Facebook post · Buyer email blast · Open-house add-on insert · Yard-sign QR caption. Each independently copyable.

End every output with: "Voice used: <agent | NYOA house | n/a (operational)>. Saved to nyoa-workspace/listings/<slug>/marketing/3d-tour.md." (Skip the save line when no workspace.)

## Shared context

Reads from `nyoa-context/`:
- `profile.md` — agent name, brokerage, license number for footers; phone make/model if present (for `capture` mode app pick).
- `voice.md` — tone resolution for `promote` mode.
- `connectors.md` — capability branching (email, docs, web-scrape).

Reads from `nyoa-workspace/`:
- `listings/<slug>/property.md` — primary fact source.
- `listings/<slug>/copy.md` — feature phrasing already approved for this listing (reuse don't reinvent in `promote` mode).
- `listings/<slug>/marketing/3d-tour.md` — canonical tour record.
- `listings/<slug>/marketing/open-house-*.md` — most recent open-house date for the `promote` mode add-on insert.

Writes to `nyoa-workspace/`:
- `listings/<slug>/marketing/3d-tour.md` — primary writer (all modes update this).
- `listings/<slug>/marketing/vendor-brief-3d-tour.md` — `vendor` mode only.
- `listings/<slug>/marketing/3d-tour-promo-YYYY-MM-DD.md` — `promote` mode only.
- `listings/<slug>/copy.md` — append revision-history line when URL captured/changed.
- `pipeline.md` — refresh last-activity stamp.
- `tasks.md` — `vendor` mode appends a follow-up task.
- `calendar.md` — `promote` mode appends social-drop entries.

## Reference files

- `references/hosting-options.md` — PlayCanvas Supersplat, Polycam, Luma AI, Matterport, self-host on Vercel/Cloudflare Pages — pros/cons/cost/embed support.
- `references/vendor-pricing.md` — $300–$800 norms by sqft tier, deliverable checklist, sample SOW language.
- `references/scan-prep-checklist.md` — staging, lighting, occupancy, route order, what to remove before scanning.
- `assets/templates/vendor-brief.md` — email-ready brief for the freelance scanner.
- `assets/templates/3d-tour.md` — workspace artifact written to `listings/<slug>/marketing/3d-tour.md`.
- `assets/templates/embed-snippets.md` — iframe + link block + QR caption + OpenGraph metadata.
- `assets/templates/promo-social-x.md`
- `assets/templates/promo-social-instagram.md`
- `assets/templates/promo-email-blast.md`
- `assets/templates/open-house-add-on.md` — one-paragraph "even if you can't make it Sunday, walk it now" insert that other skills can read.

Cross-references shared infrastructure:
- Voice presets / Fair Housing red flags → `nyoa-listing-copy/references/voice-presets.md`
- Channel conventions (SMS / email) → `nyoa-buyer-seller-comms/references/channel-conventions.md`
- Workspace I/O contract → `plugins/nyoa/references/workspace-io.md`
- 3D-tour primer for other skills → `plugins/nyoa/references/3d-tours.md`
