# {{address}} — 3D Tour

Canonical record for the 3D Gaussian Splat tour of this listing. One file per listing version. Updated by `/nyoa-3d-tour` (all modes) — but plain Markdown, so the agent can edit by hand any time.

Other listing skills (`/nyoa-listing-copy`, `/nyoa-listing-presentation`, `/nyoa-buyer-seller-comms`, `/nyoa-open-house`) read this file and auto-include the Tour URL in their output when present.

## Status

- **Tour URL:** <!-- not yet captured -->
- **Capture date:** <!-- YYYY-MM-DD -->
- **Captured by:** <!-- Vendor name | Self -->
- **Hosting platform:** <!-- PlayCanvas Supersplat | Polycam | Luma | Matterport | Self-hosted (Vercel) | Other -->
- **Cost:** <!-- $XXX | DIY -->
- **File size:** <!-- ~XX MB compressed -->
- **Mobile-tested:** <!-- yes | no -->
- **Last promoted:** <!-- YYYY-MM-DD or never -->

## Embed snippets

### MLS virtual-tour field
<!-- Paste the bare URL into MLS's virtual-tour-link field. Most MLS systems do not support iframe embeds. -->

```
<URL goes here once captured>
```

### Agent website iframe

```html
<iframe
  src="<URL>"
  width="100%"
  height="600"
  loading="lazy"
  allowfullscreen
  rel="noopener"
  title="3D walkthrough — {{address}}"></iframe>
```

### Email link block

> **🏠 Walk this house in 3D**
> Photoreal browser tour. No app, no signup.
> [<URL>](URL)

### Yard-sign QR caption

> Scan to walk this house in 3D · <short URL>

### OpenGraph metadata (for social previews)

```html
<meta property="og:title" content="3D walkthrough — {{address}}" />
<meta property="og:description" content="Photoreal browser tour. {{neighborhood}}, {{price}}." />
<meta property="og:image" content="<hero photo URL>" />
<meta property="og:url" content="<tour URL>" />
```

## Refresh triggers

Re-scan or re-promote the tour when one of these happens:

- Price drop (re-promote)
- Re-stage or major furniture swap (re-scan)
- Major paint, finish, or landscaping change (re-scan)
- Relist after withdrawal (re-promote)
- Seasonal landscape shift if the lot is a key selling feature (re-scan)

## History

<!-- Append one line per touchpoint. Append-only — never rewrite history.
- YYYY-MM-DD — vendor brief sent
- YYYY-MM-DD — scan complete
- YYYY-MM-DD — URL captured
- YYYY-MM-DD — promoted (social + email)
-->

## Vendor / asset ownership

- **Vendor name:** <!-- if hired -->
- **Asset file location:** <!-- path to local copy of .splat / .ply if downloaded -->
- **Re-scan policy:** <!-- what's covered if a room failed -->

---

*This file is auto-managed by `/nyoa-3d-tour`. See `nyoa-3d-tour/SKILL.md` for the modes that update it.*
