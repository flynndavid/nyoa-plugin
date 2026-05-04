# Buyer Drip — New Listings Hitting Their Criteria

**Required inputs:** Buyer first name, neighborhood/criteria they're watching, address(es) of new listing(s), each listing's hook + price + beds/baths/sqft.

**Channels:** SMS + email (default). Pick SMS for ≤2 listings; email when there are 3+.

---

## SMS variant

```
{{first_name}} — new on {{street}} this morning. {{one_specific_feature}}. {{price}}, {{beds}}/{{baths}}, {{sqft}} sqft. Want me to set up a showing this week? — {{agent_first}}
```

**Example:**
> Mike — new on Maple this morning. 1924 craftsman with a six-burner Wolf range and a walk-up attic already wired for an office. $625K, 3/2, 2,400 sqft. Want me to set up a showing this week? — AR

---

## Email variant

```
Subject: New on {{street}} — {{single_feature_phrase}}

Hey {{first_name}},

A new one hit MLS this morning that fits what you've been looking for in {{neighborhood}}.

· {{address}}
· {{price}} · {{beds}} bed · {{baths}} bath · {{sqft}} sqft
· {{feature_1}}
· {{feature_2}}
· {{feature_3}}

Listing page: {{link}}

I have showing slots {{day_1}} and {{day_2}}. Want me to grab one?

— {{agent_first}}
```

**Example:**

```
Subject: New on Maple — 1924 craftsman, Wolf range, walk-up attic

Hey Mike,

A new one hit MLS this morning that fits what you've been looking for in East Nashville.

· 123 Maple St
· $625,000 · 3 bed · 2 bath · 2,400 sqft
· Quartz + six-burner Wolf range
· Original 1924 white oak floors, leaded glass entry
· Walk-up attic, already wired — office or 4th bedroom

Listing page: [link]

I have showing slots Friday afternoon and Saturday morning. Want me to grab one?

— Ann-Riley
```

## Multiple listings (3+)

If sending 3+ listings, use email only and format as a single short list:

```
Subject: 3 new in {{neighborhood}} this morning

Hey {{first_name}},

Three hit MLS today that match what you've been watching:

1. {{addr_1}} — {{hook_1}} · {{price_1}}
2. {{addr_2}} — {{hook_2}} · {{price_2}}
3. {{addr_3}} — {{hook_3}} · {{price_3}}

Reply with which (if any) you want to walk and I'll line it up.

— {{agent_first}}
```
