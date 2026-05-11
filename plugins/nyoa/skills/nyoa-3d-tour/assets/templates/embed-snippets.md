# 3D Tour Embed Snippets Template

**Mode:** `embed` output. Five sections, each in its own copy-pasteable block.
**Goal:** One generated response gets the tour into every channel the agent uses.

## Output structure

### 1. MLS virtual-tour field

Most MLS systems accept a bare URL in a "virtual tour link" or "branded virtual tour" field. Paste the URL exactly. Some MLS systems have separate "branded" and "unbranded" fields — if the tour viewer shows the agent's name or brokerage, use the branded field; if not, the unbranded field is safer.

```
{{tour_url}}
```

### 2. Agent website iframe

Drop into the listing page on the agent's site. Width 100%, fixed height for layout stability. `loading="lazy"` so it doesn't slow page-load. `allowfullscreen` because buyers want to expand it.

```html
<iframe
  src="{{tour_url}}"
  width="100%"
  height="600"
  loading="lazy"
  allowfullscreen
  rel="noopener"
  title="3D walkthrough — {{address}}"></iframe>
```

### 3. Email link block

For buyer-list emails. HTML version + plain-text fallback.

**HTML:**
```html
<table cellpadding="0" cellspacing="0" border="0" style="margin: 16px 0;">
  <tr>
    <td style="padding: 12px 20px; background: #1a3a5c; border-radius: 6px;">
      <a href="{{tour_url}}" style="color: #ffffff; text-decoration: none; font-weight: bold; font-family: -apple-system, sans-serif;">
        🏠 Walk this house in 3D →
      </a>
    </td>
  </tr>
</table>
<p style="font-size: 13px; color: #555; margin-top: 4px;">
  Photoreal browser tour. No app, no signup.
</p>
```

**Plain text:**
```
Walk this house in 3D — photoreal browser tour, no app needed: {{tour_url}}
```

### 4. Yard-sign QR caption

For the rider sign or info-tube card. Pair with a QR code generated from the URL (any free generator — qr-code-generator.com, qrcode-monkey.com).

```
Scan to walk this house in 3D
{{short_url_or_tour_url}}
```

If the URL is long (most splat hosting URLs are), generate a short link first (Bitly, agent-domain redirect, or a free service). The long URL still encodes fine in a QR but the printed text is unwieldy.

### 5. OpenGraph metadata

If the agent self-hosts the tour or has a wrapper page, add these meta tags so the URL renders a preview card when shared on social or in iMessage / WhatsApp.

```html
<meta property="og:title" content="3D walkthrough — {{address}}" />
<meta property="og:description" content="Photoreal browser tour. {{neighborhood}} · {{price}} · {{beds}}/{{baths}}." />
<meta property="og:image" content="{{hero_photo_url}}" />
<meta property="og:url" content="{{tour_url}}" />
<meta property="og:type" content="website" />
<meta name="twitter:card" content="summary_large_image" />
```

If the agent is hosting on PlayCanvas Supersplat / Polycam / Luma directly (not their own domain), they can't change the OG metadata. Skip this section in the output and tell the agent: "Heads up — when you share this URL on social, the preview card will be the host's default image, not your hero photo. To control the preview, you'd need a wrapper page on your own domain."

## Hard rules

- 0 invented or shortened URLs that don't actually exist (don't say "tour.youragent.com/123-maple" if the agent didn't say they have that domain).
- 0 protected-class language in any caption surrounding the snippets.
- Iframe always includes `rel="noopener"` for security.
- Email block always has a plain-text fallback.
- QR caption always uses "Scan to walk this house in 3D" (consistent across NYOA — buyers learn the phrase).

## Variables

- {{tour_url}} — the actual hosted tour URL
- {{short_url_or_tour_url}} — short URL if available, else the long one
- {{address}}
- {{neighborhood}}
- {{price}}
- {{beds}} / {{baths}}
- {{hero_photo_url}} — for OG meta only
