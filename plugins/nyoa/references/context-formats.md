# NYOA Shared Context Directory

All NYOA skills share a persistent `nyoa-context/` directory in the agent's working folder. This directory stores the agent's business identity, voice, proof elements, competitor research, and accumulated feedback. Any skill can read from and write to these files.

## Directory Structure

```
nyoa-context/
├── profile.md      # Business identity — name, services, locations, differentiators
├── voice.md        # Tone and style preferences for the agent's brand voice
├── proofs.md       # Testimonials, awards, stats, certifications
├── competitors.md  # Competitor research and notes
└── feedback.md     # Accumulated corrections and preferences from the agent
```

The directory starts empty and builds organically as the agent uses NYOA skills.

## Which skills read/write each file

| File | Read by | Written by |
|------|---------|------------|
| profile.md | nyoa-aeo, nyoa-listing-presentation, nyoa-social-content, nyoa-testimonial-engine | nyoa-aeo (auto-save), agent manual updates |
| voice.md | nyoa-aeo, nyoa-listing-copy, nyoa-listing-presentation, nyoa-social-content, nyoa-buyer-seller-comms | nyoa-aeo (auto-save), agent manual updates |
| proofs.md | nyoa-aeo, nyoa-listing-presentation, nyoa-social-content, nyoa-testimonial-engine | nyoa-aeo (auto-save), nyoa-testimonial-engine (primary writer) |
| competitors.md | nyoa-aeo (head-to-head articles) | nyoa-aeo (auto-save), agent manual updates |
| feedback.md | All skills (for tone/style corrections) | nyoa-aeo (auto-save), any skill that receives corrections |

## File Formats

### profile.md

```markdown
# Business Profile

## Business Name
[Exact name as it should appear in all content]

## Services
- [Service 1]
- [Service 2]
- [Service 3]

## Locations Served
- [City 1]
- [City 2]

## Ideal Clients
[Description of target customers]

## Key Differentiators
- [What makes this agent/business unique]
- [Specific expertise, process, or credential]
```

### voice.md

```markdown
# Voice & Style Preferences

## Tone
[e.g., Warm and conversational, Professional but approachable]

## Style Notes
- [e.g., Use contractions]
- [e.g., Sound like a knowledgeable friend]

## Words/Phrases to Use
- [Preferred terminology]

## Words/Phrases to Avoid
- [Terms to skip]
```

### proofs.md

```markdown
# Testimonials & Proof Elements

## Testimonials

### [Client Name/Initials] — [Service Type]
"[Quote]"
Source: [Google review, Zillow, video transcription, verbal — agent paraphrase, etc.]
Permission: [yes / pending / paraphrased]
Tags: [service types this testimonial supports]

## Awards & Certifications
- [Award 1]
- [Certification 1]

## Stats
- [Relevant statistic, e.g., "150+ homes sold in Nashville since 2018"]
```

### competitors.md

```markdown
# Competitor Research

## [Competitor Name]
- Website: [URL]
- Years in business: [number]
- Review rating: [stars] ([count] reviews)
- Specialties: [list]
- Notes: [anything notable]
- Source: [web search / user provided]
- Last updated: [date]
```

### feedback.md

```markdown
# Agent Feedback & Corrections

## Style Corrections
- [Date]: [Correction made]

## Factual Corrections
- [Date]: [What was corrected]

## Preferences
- [Date]: [Preference noted]
```

## Rules for All Skills

1. **Read before writing** — always check if context files exist and use them before asking the agent for info.
2. **Auto-save new info** — when an agent provides new business info, testimonials, or corrections during any skill interaction, save to the relevant file without asking "should I save this?"
3. **Confirm saves** — after auto-saving, tell the agent: "Saved to your [file]. This will be used in future content."
4. **Don't overwrite** — append new info. Only overwrite when the agent explicitly corrects existing info.
5. **Create on first use** — if `nyoa-context/` doesn't exist when a skill needs it, create the directory and the relevant file(s).
