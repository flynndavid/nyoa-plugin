# Photoshoot Brief

The brief the agent hands the photographer 2-5 days before the shoot. Covers hero shot, must-have angles, lifestyle, twilight, drone, prep checklist, and a priority order if time runs short.

**Required:** property facts (beds/baths/sqft/lot/style), 3-8 standout features, shoot budget (hours), drone yes/no, twilight yes/no.

**Reads from:** `nyoa-workspace/listings/<slug>/property.md` when available — features and facts come from there. Only ask for what's missing.

---

## Brief structure

The brief is one Markdown page the agent can paste into an email or print. Sections in order:

1. **Header** — property address, shoot date, contact info, gate / lockbox / key access.
2. **Hero shot** (1-2 priorities).
3. **Must-have angles** (8-12, one-sentence direction each).
4. **Lifestyle shots** (3-5, with prop and setup notes).
5. **Twilight** (if booked, 2-3 angles).
6. **Drone** (if booked, 2-3 angles).
7. **Pre-shoot prep checklist** (a copy of the staging checklist for the seller / cleaner the day before).
8. **Shot priority order** — what to capture first if the shoot runs short.

## Hero shot guidance

The hero is one image. Most often: front exterior, low angle, twilight (30 minutes after sunset), interior lights on, garage closed, no cars in frame. For unique properties: substitute the strongest interior moment (a soaring entry, a signature kitchen, a defining view).

The agent and photographer should agree on the hero before the shoot. State it in writing.

## Must-have angle list — defaults

Start from this list. Cut or expand based on the property:

1. Front exterior — eye-level, daytime.
2. Foyer or entry, looking through to a primary living space.
3. Kitchen — wide angle from the doorway.
4. Kitchen detail — the counter, the range, a signature finish.
5. Primary living room — from a back corner toward the front windows.
6. Primary bedroom — from the doorway.
7. Primary bath — wide.
8. One secondary bedroom.
9. Backyard or outdoor space — wide.
10. Backyard or outdoor space — detail (a feature, a porch, mature trees).

For a 12+ angle list: add a dining shot, a second bath, a hallway-looking-into-a-room moment, a garage / parking shot, and any specific feature the agent wants to feature (attic, basement, mudroom).

## Lifestyle shots — defaults

Lifestyle shots are the "staged moments" that make a listing feel like a home, not a vacant unit. Keep them honest — props that look right for the house, not aspirational drone-shot magazine clichés.

Default set of 4 lifestyle shots:

1. **Kitchen island** — a coffee mug and an open book or magazine. (Not a styled charcuterie board.)
2. **Dining table** — set for the number of seats the room comfortably holds. Real plates, real glasses, not china the seller doesn't own.
3. **Patio or porch table** — two coffee mugs (morning) or two glasses (evening).
4. **Primary bedroom** — a throw blanket on a reading chair, a book on the nightstand.

Skip: anything that signals the buyer's demographic ("toy basket in the living room", "high chair at the table" — both Fair Housing risks).

## Twilight shots (if booked)

Twilight is the highest-effort, highest-impact slot on the shoot. Two angles minimum if it's in budget:

1. **Front exterior, blue hour** — 30 minutes after sunset. All interior lights on. Garage closed.
2. **Backyard or interior looking out through windows** — if the home has a great backyard, the from-inside-looking-out shot is the one that sells the lifestyle.

Optional third: a signature interior space at dusk (kitchen with pendant lights on, living room with table lamps lit).

## Drone shots (if booked)

Drone shots are most useful when:
- The lot is large enough that aerial reveals scale (>0.25 acre).
- The property has roof / chimney character.
- Neighborhood context matters (waterfront, park-adjacent, lot in a specific block layout).

Skip drone when:
- The lot is small and the aerial just shows neighbors.
- The roof is in poor condition.
- The neighborhood is dense and the aerial reveals power lines or proximity to commercial.

Default 2 drone angles when booked:
1. **Aerial showing the lot boundary** — pulled back to show the full property line.
2. **Mid-altitude over the front of the house** — 40-60 feet up, slight angle, showing rooflines and façade.

## Pre-shoot prep checklist (give to seller 3 days before)

- **Outdoors:**
  - Lawn mowed and edged
  - Driveway clear (no cars, no toys)
  - Trash bins out of view
  - Windows cleaned inside and out
- **Indoors:**
  - All lights replaced and on the day of
  - Counters cleared
  - Beds made
  - Toilet seats down, bath towels rolled or hidden
  - Toiletries off the bath counter
  - Personal photos and family photos removed
  - Pets out for the duration (boarded or with a neighbor)
  - Garage closed
- **Soft staging morning of:**
  - Throw pillows fluffed
  - Lifestyle props set per the brief
  - HVAC set to a comfortable temperature

## Shot priority order — if time runs short

If the photographer's running over budget, this is the order to capture in:

1. Hero (twilight front exterior if booked, daytime front exterior otherwise)
2. Kitchen wide
3. Front exterior daytime
4. Backyard wide
5. Primary bedroom
6. Living room
7. Primary bath
8. One detail shot per renovated feature

Anything not on this priority list can be deferred to a re-shoot or skipped.

## Compliance check

- **No identifiable people, addresses other than this one, or neighbors' property** in the frame.
- **No lifestyle props that signal a buyer demographic** — no children's toys, no religious objects, no political signage anywhere visible.
- **"Primary bedroom"** in any labels or callouts that get added in post.
- **Renovation labels** ("Renovated 2024") must match what's in `property.md` — don't invent.

## Output format

The brief is one Markdown response, printable on a single page. Header includes property address, shoot date, photographer contact, and access notes (lockbox code, key location, gate code, alarm code, pet location). Save to `nyoa-workspace/listings/<slug>/marketing/photoshoot-brief.md` when the workspace exists.
