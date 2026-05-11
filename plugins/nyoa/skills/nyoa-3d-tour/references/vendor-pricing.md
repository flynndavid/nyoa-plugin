# 3D Tour Vendor Pricing

Use this matrix when generating the vendor brief's pricing-expectation block. These ranges are typical for 3D Gaussian Splat scans by freelance operators (often photographers, drone pilots, or independent Polycam / Luma / Matterport operators) in mid-size US metros as of late 2025 / early 2026.

## Pricing by sqft tier

| Sqft tier | Typical price band | Includes | Watch for upsells |
|-----------|--------------------|----------|-------------------|
| Under 1,500 sqft | $250–$450 | On-site capture (30–60 min), cloud processing, hosted URL, downloadable splat file | Drone exterior, twilight shots |
| 1,500–3,000 sqft | $400–$650 | Same as above + larger floor area + outdoor scan | Drone exterior, twilight, multiple revisions |
| 3,000–5,000 sqft | $600–$900 | Same + multi-floor + lot/landscaping | Drone, twilight, custom-domain hosting, branded viewer |
| 5,000+ sqft / luxury | $850–$1,500+ | Same + estate-scale lot + interior + drone exterior | Marketing video edits, social cutdowns, agent-branded landing page |

Drone exterior typically adds $150–$300 (FAA Part 107 license required — confirm the vendor has it).

## Standard deliverables to require

When briefing a vendor, require these in writing before they accept the job:

1. **Public hosted URL** that loads in a browser without login or app install.
2. **Downloadable splat file** (`.splat` or `.ply`) — the agent owns the asset, not just the link.
3. **Mobile-friendly viewer** — must load and run on iPhone / Android (not just desktop).
4. **No vendor branding** baked into the viewer (or branding that's removable in a paid tier).
5. **Re-scan policy** — what happens if a room failed or has holes. Most reputable operators include one re-shoot.
6. **Turnaround SLA** — typical is 24–72 hours from scan to URL.
7. **Privacy practices** — vendor agrees not to publish the tour publicly without agent's go-ahead, deletes raw capture frames after delivery, doesn't post the scan to a vendor portfolio without written permission.

## Sample SOW language (drop into the vendor brief)

> Scope of work: 3D Gaussian Splat capture of [address], [sqft] sqft, [floors] floor(s).
>
> Deliverables: (1) public viewer URL, (2) downloadable `.splat` file, (3) mobile-tested embed link. Output must load on iPhone Safari and Chrome on Android.
>
> Constraints: no vendor branding on the viewer (or removable). No personal information from the scan retained beyond delivery. One re-scan included if a room has visual holes or missing geometry.
>
> Turnaround: 72 hours from on-site capture.
>
> Pricing: $[band] per the agreed sqft tier. Drone exterior, additional revisions, and custom landing-page hosting quoted separately.

## Where to find vendors

NYOA does not maintain a vetted vendor directory. Sources the agent typically uses:

- Local real estate photographer networks (most are adding splat capture to existing service menus in 2025/2026).
- Local Polycam, Luma, or Matterport operator pages on the platforms themselves.
- Real estate Facebook groups in the agent's metro.
- Referrals from listing agents who already have splat tours on their MLS listings.

The vendor brief is designed to be sent to anyone the agent finds — it standardizes the conversation regardless of the vendor's experience level.

## Red flags in vendor responses

- Won't provide a downloadable `.splat` file ("we keep the asset, you license the URL") — agent doesn't own anything.
- Won't quote without seeing the property in person — fine for luxury, overkill for standard.
- Quote at the bottom of the band with no published portfolio — likely first-time operator; ask for one previous tour link before booking.
- Insists on `.usdz` or mesh-only delivery — that's not 3DGS; quality on glass/foliage will be worse. Acceptable for some properties but ask.
