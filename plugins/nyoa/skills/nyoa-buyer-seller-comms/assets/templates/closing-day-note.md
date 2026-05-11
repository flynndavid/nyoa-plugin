# Closing Day — Handwritten-Style Note

**Required inputs:** Client first name(s), property address, one or two-sentence transaction story (how they found the home, what mattered, anything memorable from the deal).
**Channels:** Mailed handwritten card. Email variant only if the agent can't get a card in their hands that day.

**Tone:** A note. Not a marketing piece. The card has no CTA, no signature block, no license number, no brokerage logo. It's a moment, not a touchpoint.

---

## Skeleton

```
{{first_name}}{{or "First and First" for two-name households}},

{{one_specific_moment_from_the_transaction — 1 short sentence}}.

{{one_sentence_acknowledging_what_they_brought_to_it — patience, trust, persistence, whatever fits}}.

{{one_warm_forward_looking_line — specific to the house, not generic}}.

{{agent_first}}
```

**Rules:**
- ≤ 80 words.
- No subject line (it's a card).
- No signature block.
- First name only at the bottom.
- No "looking forward to working with you again".
- No "feel free to reach out".
- No "and if you know anyone who's looking…".

## Example (fictional)

> Tom,
>
> The eleventh walk-through was the one. I'll remember the look at the porch railing for a long time.
>
> Eleven Saturdays of patience earned this. Most buyers wouldn't have stayed in.
>
> Hope the slow Sunday mornings start showing up fast.
>
> Ann-Riley

## When the client is a couple or family

For two-name households, lead with both names:

> Tom and Maria,
> ...

Single-line opening. Don't write "and family", "and the kids" — leave family composition out.

## Email variant (only if the card can't reach them that day)

Same content. Add:

- Subject: `Closing day, {{address_short_no_house_number_if_security_concern}}`
- A signature block in light typography. Still no CTA.

## Workspace logging

After delivering, append to `nyoa-workspace/clients/<slug>/timeline.md`:

```
- {{YYYY-MM-DD}} — closing day note ({{mailed card | email}}).
```

If the closing is also logged in `listings/<slug>/`, append a one-liner to that listing's `showings.md` or `offers.md` accepted entry: "Closing note sent to {{client_first}}."

## Compliance check

- No protected-class language.
- No CTA. Not even a soft one.
- No "future referral" framing.
- No brokerage marketing footer on the card. (Email variant can include the signature block.)
- The story must be one the agent actually remembers. If the agent doesn't have a real moment, write a shorter, less specific note rather than inventing detail.
