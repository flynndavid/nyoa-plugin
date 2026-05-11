# DIY Scan Prep Checklist

The day-of and pre-scan checklist NYOA renders for the agent in `capture` mode. Designed to be readable on a phone while standing at the property.

## Before you arrive (24–48 hours ahead)

- [ ] Confirm with the seller: the scan publishes publicly. Ask them to remove anything they don't want a stranger seeing.
- [ ] Tell them: no occupants, no pets, no kids in the house during the scan window.
- [ ] Ask them to **remove personal photos from walls** — frames especially. Splat scans capture faces in framed photos at full resolution.
- [ ] Ask them to clear visible **mail, prescriptions, financial paperwork, calendars, and any whiteboards** with personal info.
- [ ] Ask them to clear counters and tables to "showing" level — same as a professional photo prep.

## Day of the scan

### Lighting
- [ ] Open every blind and curtain.
- [ ] Turn on every light, including range hood, under-cabinet, closet, and lamp lights.
- [ ] Aim for the brightest 2-hour window of the day for the area being scanned (kitchens with east-facing windows scan best in the morning; west-facing living rooms scan best in the afternoon).
- [ ] Cloudy days are actually ideal — soft even light, no harsh shadows.

### Final pre-scan walk-through
- [ ] Toilet seats down, lids down.
- [ ] Trash cans behind doors or out of frame.
- [ ] No license plates visible through driveway windows.
- [ ] Dog beds, water bowls, kid toys removed.
- [ ] Laundry baskets out of sight.
- [ ] No people in the house. Not even you in mirrors — be aware of bathroom and entryway mirror placement.

## App pick (one of these)

- **Polycam** — best general-purpose. Guided UI. Cloud processing in 30–60 min. Free tier sufficient for one scan.
- **Luma AI** — best on iPhone Pro models with LiDAR. Highest visual quality on outdoor + reflective surfaces. Cloud processing 30–90 min.
- **Scaniverse** — Niantic's app, free, great for smaller spaces. Local processing on newer phones.
- **KIRI Engine** — supports Android well. Free tier limited but functional.

If you don't have a preference, default to **Polycam** for indoors and **Luma AI** for exterior + lot.

## Room-by-room route

Move slowly. The optimization that produces the splats needs overlapping angles between frames.

For each room:

1. Stand in the doorway. Capture the full room from there (slow pan).
2. Walk a clockwise loop around the room's perimeter, keeping the phone aimed inward toward the room's center. Hold the phone at eye height.
3. Halfway through the loop, switch to chest height and continue.
4. Capture corners specifically — corners are where most splat scans have geometry holes.
5. End by standing in the room's center and panning 360° at three heights: knee, chest, eye.

**Rooms with reflective surfaces** (bathrooms with mirrors, kitchens with appliances): add a second loop at a different height. Reflections confuse the optimizer; more angles fix it.

**Stairs**: walk up slowly, panning side to side. Then walk back down panning the opposite side. Capture the top and bottom landings as their own mini-rooms.

**Outdoor**: walk the perimeter of the house at a steady pace, phone pointed at the house. Then walk a wider arc at the property edge for landscaping context. Avoid scanning into the sun.

## What to do after the scan

1. Upload to the app's cloud (most apps do this automatically).
2. Wait 30–90 minutes for processing.
3. Review the result on your phone before approving. Look for: floating "junk" splats outside the house, holes in walls, washed-out windows, ghost figures (people who walked through the scan).
4. If you see a major hole: re-scan that room only. Most apps support adding scans to an existing project.
5. If clean: either use the app's hosted URL directly, or download the `.splat` and upload to PlayCanvas Supersplat for polish + a cleaner URL.

## Honest expectations

- **First scan often disappoints.** Walls warp, windows go opaque, the floor plane is wrong. This is normal. Agents get good at this in 2–3 scans.
- **Outdoors and lots are harder than interiors.** Wind moves leaves, sun moves shadows mid-scan. Plan for re-scans.
- **Time on-site:** budget 45–90 min for a typical 2,000 sqft house. Plus 30–90 min for processing. Plus 15 min to review and decide whether to re-scan.

If after the first attempt the agent decides DIY isn't worth their time, the vendor path (`/nyoa-3d-tour vendor`) is always the fallback.
