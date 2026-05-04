# Buyer Drip — Price Drop

**Required inputs:** Buyer first name, address, original price, new price, prior interaction context (did they walk it, did they just save it, did they pass).

**Channels:** SMS first (price drops are time-sensitive); email when the buyer is in a slower mode.

---

## SMS variant — they walked it before

```
{{first_name}} — {{address}}, the one you walked {{day_or_week}}, just dropped from {{old_price}} to {{new_price}} ({{percent_drop}}). If that changes the math, I have a {{day}} slot. — {{agent_first}}
```

**Example:**
> Mike — 312 Maple, the one you walked Tuesday, just dropped from $649K to $619K (-4.6%). If that changes the math, I have a Saturday slot. — AR

---

## SMS variant — they saved it but never walked

```
{{first_name}} — {{address}}, on your saved list, just dropped from {{old_price}} to {{new_price}}. Want to walk it this weekend? — {{agent_first}}
```

---

## Email variant — slower buyer, soft re-engage

```
Subject: Price moved on {{address}}

Hey {{first_name}},

Quick note — {{address}} dropped from {{old_price}} to {{new_price}} this morning ({{percent_drop}} off the original).

Couple of reasons that might matter:
· It's been on the market {{dom}} days, so they're motivated.
· At {{new_price}}, the {{ppsf}} per sqft now {{compare_phrase — e.g., "lines up with what we were seeing in your range"}}.

If you want to walk it before the next round of weekend traffic, let me know — I have {{slot_1}} or {{slot_2}}.

— {{agent_first}}
```

## Compliance check

- No "perfect for someone like you" — keep it about the property and the math.
- No "rare opportunity" / "won't last" pressure clichés.
- If the price is dropping because of a known issue (failed inspection, etc.), the agent must disclose. Don't soften.
