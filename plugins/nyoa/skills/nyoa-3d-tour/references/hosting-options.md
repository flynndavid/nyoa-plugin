# 3D Tour Hosting Options

NYOA does not pick a host for the agent. This file is the recommendation matrix the `host` mode walks through.

## Quick decision matrix

| Platform | Cost | Best for | Embed support | Watch out for |
|----------|------|----------|---------------|---------------|
| **PlayCanvas Supersplat** | Free (paid plans for higher quotas) | Agents who want a clean hosted URL with no app branding; agents doing DIY scans. | Iframe-friendly. Public URL. | Browser-based editor — agent has to upload the splat file from whatever capture app they used. |
| **Polycam** | Free tier with limits; $20/mo Pro | Agents using Polycam to capture in the first place — one tool end-to-end. | Embed widget + public viewer URL. | Free tier shows Polycam branding on the viewer; some agents won't want it. |
| **Luma AI** | Free tier with limits; paid plans for commercial | Best raw quality on iPhones with LiDAR; outdoor + landscaping shots. | Public URL + embed. | Capture and processing both happen in Luma's cloud — slower turnaround during peak hours. |
| **Matterport** | $XX/mo + per-scan capture fees | Agents already paying for Matterport who want to keep one workflow. Matterport has begun adding splat support to its viewer. | Robust iframe. Strong analytics. | Most expensive option. Tour quality may be a step behind native splat hosts on glass / foliage / reflections. |
| **Self-host on Vercel / Cloudflare Pages** | Free for the hosting | Agents who want the URL on their own domain (`tours.youragent.com/123-maple`) for SEO + brand control; agents already comfortable with deploying static sites. | Full control — embed however you want. | Requires uploading the splat file + a viewer (PlayCanvas Engine, Spectacles, gsplat.js). Some setup work the first time. |

## Recommendation logic for the `host` mode

Ask the agent these three questions, in order:

1. **DIY scan or vendor delivery?**
   - DIY → Polycam or Luma is usually the path of least resistance because the capture and host live in the same app. PlayCanvas Supersplat is the upgrade path if they want to polish + remove branding.
   - Vendor → ask the vendor what format they'll deliver in. If `.splat` or `.ply`, route to Supersplat. If they offer a hosted URL, use that.

2. **Want the URL on the agent's own domain?**
   - Yes → self-host on Vercel or Cloudflare Pages. Recommend this only when the agent is already comfortable with static site deploys (or has a developer in the loop). If they hesitate, fall back to Supersplat.
   - No → PlayCanvas Supersplat is the default.

3. **Want analytics on tour views?**
   - Yes → Matterport has the most robust analytics. Polycam / Luma have basic view counts. Self-host gives full control via standard web analytics (Plausible, Vercel Analytics).
   - No → analytics not a constraint; pick on the first two questions.

## Common workflows

### "Vendor delivers a hosted URL"
Use the vendor's URL directly. Capture it in `marketing/3d-tour.md`. Done — no hosting decision needed.

### "DIY with Polycam"
- Capture in Polycam → Polycam auto-hosts → use Polycam URL in MLS.
- Optional polish: download the `.splat` from Polycam → upload to PlayCanvas Supersplat → use Supersplat URL instead (no Polycam branding).

### "DIY with Luma AI"
- Capture in Luma → Luma processes → Luma URL is the simplest path.
- Same optional polish path: download → Supersplat → use Supersplat URL.

### "Brand-control mode" (self-host)
- Capture however (Polycam / Luma / Scaniverse) → download `.splat` or `.ply`.
- Compress in PlayCanvas Supersplat.
- Push the compressed file + a viewer page to a Vercel or Cloudflare Pages deploy at `tours.youragent.com/<slug>`.
- Use that URL in MLS, social, email.

## Note on file formats

The de-facto interchange format is `.splat` (or `.ply` for the source). PlayCanvas Supersplat outputs a compressed variant (`.compressed.ply`) that's typically 5–30 MB for a typical home — small enough to load on cellular. Most viewers (PlayCanvas Engine, gsplat.js, Spectacles) support both.

If the vendor delivers `.usdz`, that's photogrammetry mesh — different tech (Apple's RealityCapture pipeline). It works but isn't 3DGS, and the visual quality on reflective / glassy surfaces will be noticeably worse. Ask for `.splat` or `.ply`.

## Note on MLS embed compatibility

Most MLS systems do **not** support iframe embeds in any field. They do support a "virtual tour URL" field where you paste a public URL. The buyer clicks → opens in a new tab → walks the tour. This is fine — the iframe path is for the agent's website, not MLS.

When advising agents in `embed` mode, default to: paste the bare URL into MLS's virtual-tour field, use the iframe on the agent's own listing page, use the link block in emails.
