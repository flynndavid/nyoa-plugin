# 3D Tours — Shared Reference

Canonical primer on 3D Gaussian Splat (3DGS) tours for NYOA. Every listing skill that mentions a tour should reference this file rather than duplicate the explainer.

## What 3D Gaussian Splatting is, in one paragraph

3D Gaussian Splatting (paper: Kerbl et al., 2023, INRIA) is a graphics technique that replaces traditional polygon meshes with millions of small semi-transparent 3D ellipsoids — "splats" — each storing position, color, opacity, and a small directional color hint. The model is reconstructed from a set of photos (or video frames) by an optimizer that adjusts the splats until rendering them from the original camera angles matches the source photos. Reflections, glass, plants, and fine detail look photoreal because the splats encode actual photographic data rather than approximated geometry. Rendering is fast WebGL/WebGPU rasterization, which is why a phone can play it back in a browser tab.

## Cost framing for sellers (use in `/nyoa-listing-presentation`)

| Item | DIY (agent does it) | Hire a vendor |
|------|---------------------|---------------|
| Capture | $0–$30/mo (Polycam Pro / Luma free tier) | $300–$800 typical |
| Hosting | Free (PlayCanvas Supersplat, Polycam, Luma) | Usually included |
| Time | 1–2 hours per house + 30–90 min processing | 0 (vendor scans, agent unlocks) |
| Refresh after price drop / re-stage | Same again | Same again |

**Anchor for the seller conversation:** "For $200–$800 we add unlimited photoreal showings, 24/7. Out-of-state buyers walk it before they fly in. The buyer who saved your listing on Zillow at 11pm walks it on their couch instead of bouncing because they couldn't see what they wanted to see."

## When to refresh the tour

Re-scan or re-promote when one of these happens. Captured in the workspace under `Refresh triggers` in `marketing/3d-tour.md`.

- **Price drop** — re-promote (don't re-scan).
- **Re-stage or major furniture swap** — re-scan.
- **Major paint, finish, or landscaping change** — re-scan.
- **Relist after withdrawal** — re-promote.
- **Seasonal landscape shift** if the lot is a key selling feature — re-scan.

## Decision rule for other skills

Every listing skill (`/nyoa-listing-copy`, `/nyoa-listing-presentation`, `/nyoa-buyer-seller-comms`, `/nyoa-open-house`) follows this rule:

```
IF nyoa-workspace/listings/<slug>/marketing/3d-tour.md exists
AND it has a non-empty Tour URL field
THEN include the tour URL in the channel-appropriate format:
   - MLS remarks: append " · Walk it now in 3D: [URL]" if room within character limit
   - Long description: append a one-sentence "Walk every room in 3D at [URL]" before the close
   - Social variants: append the tour link to the action block
   - Buyer email: insert the email-link-block snippet before the property block
   - Open-house promo: append the open-house-add-on insert (long form for FB/email, short form for IG, skip for SMS)
   - Listing presentation marketing plan: list the tour as a concrete deliverable with hosted URL
ELSE skip silently. Never invent a URL. Never claim a tour exists if the file is empty.
```

## Compliance highlights (full rules in `nyoa-listing-copy/references/voice-presets.md`)

3D-tour-specific risks, beyond the standard NYOA Fair Housing baseline:

- **Occupants in the scan.** Splat scans capture whoever is in frame. Any vendor brief or DIY checklist must include "no occupants in frame, remove personal photos before scanning". Privacy + Fair Housing both matter.
- **No demographic targeting in tour promo.** "Great for families to walk through together" is the same Fair Housing risk in tour promo as in any other listing copy.
- **No accessibility certification off the scan.** Never claim "wheelchair accessible" because a wheelchair could roll through the splat. Use specific, agent-confirmed measurements.
- **No invented capability claims.** Never assert "3D tours increase offers by X%" without a citation. Use directional language: "out-of-state buyers can pre-walk", "serious buyers self-qualify".

## Why NYOA doesn't ship a 3D-tour MCP

- The capture, processing, and hosting all happen in third-party apps (Polycam, Luma, PlayCanvas Supersplat) that don't expose MCP servers.
- Per the "out of scope" section of `nyoa-plugin/CLAUDE.md`, NYOA doesn't bundle integrations whose auth is per-agent and per-vendor.
- The right NYOA layer is **text generation against an agent-provided URL** — vendor briefs, embed snippets, promo packages, workspace memory. The tour itself is the agent's asset, not NYOA's.

## References

- Original paper (Kerbl et al., 2023): "3D Gaussian Splatting for Real-Time Radiance Field Rendering"
- PlayCanvas open-source viewer + Supersplat editor: github.com/playcanvas
- Capture apps: Polycam, Luma AI, Scaniverse, KIRI Engine

## Skill that owns this

`/nyoa-3d-tour` (added v0.8.0). All modes documented in `plugins/nyoa/skills/nyoa-3d-tour/SKILL.md`.
