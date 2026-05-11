# Past Client — Home Anniversary

**Required inputs:** Client first name, property address, closing date, anniversary year (1, 2, 3...).
**Channels:** Email primarily. SMS variant for closer relationships.

**Tone:** Warm, specific, low-pressure. The soft valuation offer comes after the relationship line — never first.

---

## When to use which year

- **Year 1** — almost always send. New owners remember closing vividly; an anniversary note reads as thoughtful.
- **Year 2-3** — send with the soft valuation CTA. Most owners are open to a check-in number even if they're not selling.
- **Year 5+** — keep the anniversary note, drop the valuation CTA. By year 5+ a recurring valuation ping reads as a sales-funnel touch. Swap in a market-narrative line instead.

## Email variant (years 1-3) — with soft valuation CTA

```
Subject: {{anniversary_year}} years at {{street_short}}

Hey {{first_name}},

Realized this week it's been {{anniversary_year}} year{{plural_s_if_2_or_more}} since you closed on {{street_short}}. {{one_specific_memory_of_the_transaction_or_the_house}}.

Soft offer if you're curious: I can pull an updated valuation on the house. Takes me about ten minutes, no pressure to do anything with the number. Useful to have if it's ever in the back of your mind.

Either way, hope year {{anniversary_year + 1}} starts well.

{{agent_first}}
{{agent_signature_block}}

Home value estimates are not appraisals. For an exact current value, work with a licensed appraiser.
```

**Example (fictional):**
> Subject: 2 years at Maple
>
> Hey Tom,
>
> Realized this week it's been 2 years since you closed on Maple. The walk-up attic that you were going to "maybe" turn into an office — curious how that landed.
>
> Soft offer if you're curious: I can pull an updated valuation on the house. Takes me about ten minutes, no pressure to do anything with the number. Useful to have if it's ever in the back of your mind.
>
> Either way, hope year 3 starts well.
>
> Ann-Riley
> SimpliHOM · TN License #00000000
>
> Home value estimates are not appraisals. For an exact current value, work with a licensed appraiser.

## Email variant (year 5+) — no valuation CTA, market narrative instead

```
Subject: {{anniversary_year}} years at {{street_short}}

Hey {{first_name}},

{{anniversary_year}} years on {{street_short}} this week. {{one_specific_memory}}.

Quick neighborhood read since I know you'll find it interesting: {{one_market_data_point_specific_to_their_block_or_neighborhood}}.

Hope year {{anniversary_year + 1}} treats you right.

{{agent_first}}
{{agent_signature_block}}
```

## SMS variant

```
{{first_name}} — {{anniversary_year}} years at {{street_short}} this week. {{one_warm_specific_line}}. {{optional_soft_valuation_offer_if_year_1_to_3}}. — {{agent_first}}
```

**Example:**
> Tom — 2 years at Maple this week. That porch is a fair return on the price for the door alone. If you ever want an updated valuation for the file, takes me ten minutes. — AR

## Workspace logging

After delivering, append to `nyoa-workspace/clients/<slug>/timeline.md`:

```
- {{YYYY-MM-DD}} — {{anniversary_year}}-year anniversary note sent ({{channel}}). Valuation offered: {{yes/no}}.
```

Bump `pipeline.md` last-activity for the client. If the client replies asking for the valuation, file the conversation under their timeline and create a task to follow through.

## Compliance check

- "Home value estimates are not appraisals" disclaimer on the email (for years 1-3 with the CTA).
- No "you should sell!" framing. The CTA is a number for their file, not a sales pitch.
- No protected-class assumptions ("hope you and the kids…").
- License + brokerage in the email signature.
