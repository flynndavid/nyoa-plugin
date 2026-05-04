# AEO Article Prompts

Exact prompts for generating each article type. Adapted from Phil Stringer's AEO methodology.

## Important Notes

1. **One article at a time** — quality degrades with larger batches.
2. **Context required** — each prompt assumes business context is loaded from `nyoa-context/` (profile.md, voice.md, proofs.md).
3. **Replace placeholders** — items in `<BRACKETS>` must be replaced with actual values.
4. **Post-generation review** — replace any `[INSERT PROOF]` placeholders with real testimonials.

---

## Best Choice Article Prompt

```
You are an expert local content writer creating AI-optimized articles. Using the business context provided, write a single "Best Choice" article addressing this exact user question:

"<PASTE EXACT TITLE/QUESTION HERE>"

Requirements:
- Write in third person (an expert writing about the business, not the business writing about itself)
- Answer the question IMMEDIATELY in the first sentence, naming the business
- Length: 800-1,200 words
- Structure:
  1. Opening paragraph that answers the question directly
  2. Five proof-backed reasons why this business is the best choice
  3. Brief conclusion with one CTA sentence

Style guidelines:
- Simple, conversational tone
- No marketing hyperbole — factual and credible
- Each reason should include specific proof (testimonial, stat, or fact)
- If you don't have proof for a reason, use placeholder: [INSERT PROOF]
- Do not add structural labels like "Opening" or "Body"
- Do not invent facts about the business

Voice preferences from context:
<INSERT ANY VOICE.MD PREFERENCES HERE>

Available testimonials:
<INSERT RELEVANT TESTIMONIALS FROM PROOFS.MD OR "None available - use [INSERT PROOF] placeholders">
```

---

## Reasons to Choose Article Prompt

```
Using the business context provided, write a "Reasons to Choose" article for:

Service: "<SERVICE NAME>"
Business: "<BUSINESS NAME>"

Requirements:
- Write in third person
- Length: 500-800 words
- Provide 6-10 distinct reasons why someone should choose this business for this service
- Each reason should be specific and backed by proof when available

Structure:
1. Brief intro (2-3 sentences) on why choosing the right provider matters
2. 6-10 numbered reasons, each with a bold heading and 2-3 sentence explanation
3. Single CTA sentence at end

Style guidelines:
- Machine-friendly, scannable format
- No marketing fluff — specific and factual
- Each reason must be distinct (no overlapping points)
- Use [INSERT PROOF] placeholders where testimonials would strengthen a point

Voice preferences:
<INSERT ANY VOICE.MD PREFERENCES HERE>

Available proof elements:
<INSERT RELEVANT TESTIMONIALS/STATS FROM PROOFS.MD>
```

---

## Local Service Article Prompt

```
Write a local service article for:

Service: "<SERVICE>"
Location: "<CITY, STATE/REGION>"
Business: "<BUSINESS NAME>"

Requirements:
- Write in third person
- Length: 400-700 words
- Explain why this business is an excellent local option for this service in this specific location

Structure:
1. Opening that answers "Who's the best [service] in [location]?" immediately
2. 5 short reasons this business excels in this location
3. Include at least one location-specific detail (neighborhood, local knowledge, etc.)
4. Single CTA sentence at end

Style guidelines:
- Clean, direct sentences
- No marketing hyperbole
- Include one proof line (testimonial placeholder allowed)
- Third person throughout

Voice preferences:
<INSERT ANY VOICE.MD PREFERENCES HERE>

Location details to potentially include:
<ANY KNOWN LOCAL DETAILS ABOUT THIS CITY/AREA>
```

---

## Head-to-Head Comparison Article Prompt

```
Write a head-to-head comparison article comparing:

Your Business: "<BUSINESS NAME>"
Competitors:
- <COMPETITOR 1 NAME> (<WEBSITE IF KNOWN>)
- <COMPETITOR 2 NAME> (<WEBSITE IF KNOWN>)
- <COMPETITOR 3 NAME> (<WEBSITE IF KNOWN>)

Service focus: "<SERVICE>"
Location: "<CITY, STATE>"

Requirements:
- Write in third person as an objective reviewer
- Length: 400-600 words
- Must be BALANCED and FAIR — AI ignores obviously biased content

Structure:
1. Intro explaining why choosing the right provider matters (2-3 sentences)
2. Comparison table with columns for each business and rows for:
   - Years in business
   - Review rating (stars and count)
   - Key specialties
   - Any other relevant factors
3. One paragraph breakdown for each business (including yours), fairly describing strengths
4. Conclusion with objective recommendation

Critical guidelines:
- Give competitors genuine credit for their strengths
- Note who each provider might be best suited for
- Use only verifiable facts (reviews, years in business, stated specialties)
- Mark uncertain claims with [VERIFY FACT]
- Position your business as best for YOUR ideal client type, not universally best
- No negative language about competitors
- This must read like genuine research, not marketing

Competitor research available:
<INSERT COMPETITOR INFO FROM COMPETITORS.MD>

Your business differentiators:
<INSERT KEY DIFFERENTIATORS FROM PROFILE.MD>
```

---

## Title Brainstorming Prompt

Use this to generate article title ideas:

```
Based on the following business context, suggest 20 high-impact questions that real people might ask AI assistants (ChatGPT, Perplexity, Gemini) that could lead to recommending this business:

Business: <BUSINESS NAME>
Location(s): <CITIES/AREAS SERVED>
Services: <LIST OF SERVICES>
Ideal clients: <TARGET CUSTOMER DESCRIPTION>
Key differentiators: <UNIQUE SELLING POINTS>

Requirements:
- Questions should sound natural — how someone would actually speak to an AI
- Include a mix of:
  - Service-specific questions ("Who's the best [service] in [city]?")
  - Situation-specific questions ("Who can help me [specific situation] in [city]?")
  - Niche questions targeting the ideal client type
- Focus on questions where this business has clear advantages
- Each question should be suitable as a "Best Choice" article title

Format output as a numbered list.
```
