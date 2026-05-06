# Workflow: First Month — Getting the Most from NYOA in 30 Days

Use this recipe to go from a fresh install to a fully operational workspace in your first month. It's designed to be paced across four weeks — don't try to do everything in one session.

---

## Week 1 — Build your foundation

### Step 1 — Run the full onboarding interview

```
/nyoa-setup
```

This is the most important thing you'll do. The setup skill runs an 8-round interview that builds your business identity:

1. Business profile (name, brokerage, market area, years in business)
2. Voice and tone (formal vs. casual, what you sound like, what you never want to sound like)
3. Social proof (testimonials, awards, stats — what agents typically share on their bio page)
4. Competitors (who you're up against and how you're different)
5. Active pipeline snapshot (current clients and listings by stage)
6. Templates and snippets you already use
7. MCP connectors (which tools you have wired up)
8. Review and finalize

Set aside 20–30 minutes. You don't have to complete all 8 rounds in one session — run `/nyoa-setup resume` to pick up where you left off.

**After this step:** `nyoa-context/` is populated with your profile, voice, proofs, and competitors. Every skill you run after this will read from these files and sound like you.

---

### Step 2 — Document your connected tools

```
/nyoa-connect
```

Run this immediately after setup (or during round 7 of setup — they overlap intentionally). NYOA will detect which MCPs are active in your current session and record them in `nyoa-context/connectors.md`. This determines which skills can offer to push directly to Gmail, Google Calendar, your CRM, or other tools.

If a tool isn't detected, NYOA will note the gap and use file-only behavior as a fallback. You can re-run `/nyoa-connect` anytime you add a new tool.

---

### Step 3 — Review and correct the pipeline snapshot

```
/nyoa-pipeline
```

Look at what setup built for your pipeline. Correct any stages, names, or next-step dates that are off. Add anyone who was missed. The pipeline is a living document — this first review is about making it accurate, not complete.

---

## Week 2 — Use it on a real scenario

### Step 4 — Log one real interaction

```
/nyoa-log
```

Pick a call, showing, or email exchange from your week and log it:

"Log: called Dana Reyes. She's pre-approved at $420k. Wants a 3/2 with a garage in Hillsboro Village or 12South. Timeline is 60 days. Very motivated."

This tells you whether the workspace feels natural or needs adjustment. If the log feels wrong, run `/nyoa-setup resume` to refine your voice or profile.

---

### Step 5 — Draft a real email to an active client

```
/nyoa-buyer-seller-comms <client name> <type of email>
```

Examples: "draft a check-in email to Marcus, he's been quiet for 2 weeks." or "write a showing recap for Dana after yesterday's tour of 310 Elmwood."

This is a voice quality test. Read what NYOA drafts. Does it sound like you? If not, run `/nyoa-setup resume` and revisit the voice round — or add a correction directly to `nyoa-context/voice.md`.

---

### Step 6 — Run one content skill against a real listing

If you have an active listing:

```
/nyoa-listing-copy <address>
```

Or run an audit against an existing listing:

```
/nyoa-listing-audit <live listing URL>
```

This stress-tests the workspace with real data. The audit is a great starting point because it gives you concrete feedback even if you don't need to rewrite anything right now.

---

## Weeks 3–4 — Build the habit

### Step 7 — Run your first weekly review

```
/nyoa-weekly-review
```

The weekly review reads your pipeline, recent log entries, and calendar to produce a summary of what happened this week, what's coming up next week, and where your attention should go. It writes the review to `nyoa-workspace/reviews/YYYY-MM-DD.md`.

This is the skill that makes the workspace compound over time. Every week you run it, NYOA has richer context to work with. Block 20 minutes every Friday.

---

### Step 8 — Create one AEO article for a search query you want to own

```
/nyoa-aeo
```

Example: "I want to rank for 'best real estate agent in East Nashville'" or "write an FAQ for buyers asking about Nashville closing costs."

AEO (Answer Engine Optimization) articles are structured to appear in AI search results and featured snippets — not just traditional Google. One article per week adds up fast. Start with the comparison or FAQ format: it's the easiest to write and the highest-value for search.

---

### Step 9 — Run the workspace health audit

```
/nyoa-doctor
```

At the end of your first month, run the doctor to see what's complete, what's stale, and what's missing. It will flag:
- Clients in the pipeline without a workspace folder
- Listings without copy or audit
- Voice or profile sections left blank
- Weekly reviews that haven't been run
- Connectors that were detected but not verified

Address the top 3 items from the doctor report and you're set for month 2.

---

**After your first month:** the workspace is your source of truth. Every session starts with context. Every skill knows your voice. The longer you use it, the less you start from scratch.

Run `/nyoa-help` anytime to see what's available and what's recommended for your current state.

Voice used: NYOA house
