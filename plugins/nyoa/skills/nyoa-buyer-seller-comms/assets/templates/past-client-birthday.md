# Past Client — Birthday Note

**Required inputs:** Client first name, birthday month/day, one specific memory of their transaction or them.
**Channels:** Email by default. SMS variant for clients the agent texts with regularly.

**Tone:** A note from someone who actually knows the recipient. No CTA. No "I'm always here to help with real estate." The job is to be a person, not a marketer.

---

## Subject lines — find a specific angle, not "Happy Birthday!"

The generic subject reads like a marketing automation. Use a detail.

- "A spring birthday on [street]"
- "Year three on [street]"
- "Coffee on the porch you wanted"
- "[Year] birthday from your old realtor"

## Email variant

```
Subject: {{specific_subject}}

Hey {{first_name}},

{{one_specific_memory_or_detail — 1 sentence}}.

Hope this year treats you {{one_warm_word_that_isn't_template}}.

{{agent_first}}
```

**Example (fictional):**
> Subject: Year three on Maple
>
> Hey Tom,
>
> Three years on Maple feels right — the screened porch has earned its keep by now. Hope this year treats you slow.
>
> Ann-Riley

## SMS variant — for clients the agent actually texts with

```
{{first_name}} — birthday week. {{one_warm_specific_line}}. — {{agent_first}}
```

**Example:**
> Tom — birthday week. Hope the porch is in heavy use this spring. — AR

## What to skip

- "Happy Birthday!" as the subject. The whole point is to not sound like the automated card from the dentist.
- A CTA. No "if you ever think about selling…", no "thinking of you and your real estate needs". Birthday notes are relationship maintenance; they get worse when they're sales maintenance.
- "I hope this email finds you well." "Just wanted to reach out." "Touching base." None of these.
- Demographic assumptions ("hope you and the kids are well") — you may know, but write the note to the person, not the household.

## Workspace logging

After delivering, append to `nyoa-workspace/clients/<slug>/timeline.md`:

```
- {{YYYY-MM-DD}} — birthday note sent ({{channel}}).
```

And bump `pipeline.md` last-activity for the client.

## Compliance check

- No protected-class assumptions.
- No CTA.
- Sender identifiable from the signature block (agent name on email; agent initials or first name on SMS).
