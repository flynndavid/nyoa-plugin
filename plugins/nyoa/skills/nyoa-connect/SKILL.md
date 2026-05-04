---
name: nyoa-connect
description: Detect which Model Context Protocol (MCP) servers the agent has wired up (Google Workspace for Gmail / Calendar / Drive, Slack, Notion, Firecrawl, etc.) and record the inventory in nyoa-context/connectors.md so other NYOA skills can branch on availability. Use this skill when an agent says "check my tools", "what connectors do I have", "connect Gmail", "set up integrations", or "what MCPs do I have". Triggers on phrases like "connectors", "connect", "integrations", "tools", "mcp", "hook up gmail", "hook up calendar".
---

# Connectors

Detect which external tools the agent has available, document the inventory in `nyoa-context/connectors.md`, and explain how every other NYOA skill should use what's there. This skill ships **no integration code** — it works by inspecting which MCP tool namespaces exist in the current session.

## When this skill triggers

- "What connectors do I have" / "check my tools" / "what's wired up"
- "Connect Gmail" / "hook up calendar" / "set up integrations"
- "What MCPs do I have" / "add MCP"
- After `/nyoa-setup` completes and tells the agent to run this skill

## Inputs you need

Nothing. The skill detects what's available; for missing tools, it asks the agent which ones they actually use.

## What this skill does NOT do

It does **not** invent MCP server names. It only records connectors we can verify in two ways:

1. **Detected directly** in the current session's tool list (the strongest signal).
2. **Confirmed publicly available** via the official MCP registry, an official vendor publication (e.g., Google's Workspace MCP), or Anthropic's reference servers.

If the agent asks about a tool we can't verify (a specific CRM, MLS portal, e-sign service, SMS provider), the skill says so plainly and records the gap rather than naming a server that may not exist.

## Workflow

### 1. Detect available MCP tool namespaces in the current session

Look at the tool list available in this session. Match against the verified-real catalogue below. The detection keyword is a substring on the tool name; the namespace prefix may vary by install.

| Connector | Detection keywords | Source | NYOA uses for |
|-----------|--------------------|--------|---------------|
| Google Workspace (Gmail, Calendar, Drive) | `gmail`, `calendar`, `gcal`, `drive`, `gdrive`, `gworkspace` | Google official MCP (announced 2025) | Sending email drafts, syncing calendar events, contract storage |
| Filesystem | `filesystem`, `read_file`, `write_file` (when MCP-namespaced) | Anthropic reference | Workspace file operations |
| GitHub | `github` | GitHub-maintained | Source-control if the agent uses git for templates |
| Slack | `slack` | Anthropic reference | Team comms |
| Notion | `notion` | Notion official | Alternative workspace if the agent stores client info there |
| Firecrawl | `firecrawl` | Firecrawl official | Listing scrapes for `/nyoa-listing-audit` |
| Postgres | `postgres`, `psql` | Anthropic reference | If the agent connects to their own database |
| Brave Search | `brave_search` | Anthropic reference | Neighborhood / market research |
| Puppeteer | `puppeteer` | Anthropic reference | Headless browsing for listings if Firecrawl absent |

Also note availability of the built-ins `WebFetch` and `WebSearch` — these aren't MCPs but are used by `/nyoa-listing-audit` and `/nyoa-aeo`.

Do not check for or list any other connector by name. If the agent asks about Gmail / Calendar / Drive specifically, the answer is "check Google's official Workspace MCP"; we don't name third-party Gmail MCPs because their authorship and maintenance status varies.

### 2. Ask about tool categories we can't auto-detect

For categories where there is **no verified public MCP** as of this skill's last update, ask the agent in plain language so we can capture their workflow gap (not their MCP install). One short list:

> "Which of these do you use day-to-day? (a) a CRM — if so, which one, (b) an e-signature tool — DocuSign / Dotloop / etc., (c) an SMS tool — Twilio / company SMS, (d) an MLS portal — which one. I'll record what you have so the rest of NYOA knows the fallback for each, but we won't recommend an MCP for these because we can't verify any specific public package as of today."

For each category the agent uses, record `tool: <name>` and `mcp: not-verified-as-of-2025`. Other skills will fall back to file-only behavior.

### 3. Write `nyoa-context/connectors.md`

Use the format defined in `plugins/nyoa/references/context-formats.md`. Always overwrite the file in full — it's canonical state, not a log.

```markdown
# Connectors

## Detected (verified MCPs available in this session)
- google-workspace: yes — namespace: <observed prefix>
- firecrawl: yes — namespace: mcp__firecrawl__*
- slack: no
- notion: no

## Built-in tools
- WebFetch: yes
- WebSearch: yes

## Stack we tracked but can't verify a public MCP for
- crm: <name agent uses or "none"> — mcp: not-verified-as-of-2025
- e-sign: <name or "none"> — mcp: not-verified-as-of-2025
- sms: <name or "none"> — mcp: not-verified-as-of-2025
- mls: <name or "none"> — mcp: not-verified-as-of-2025

## Notes
- Default email send-from: <agent's email if Google Workspace MCP is wired and they shared it>
- Default calendar: <which calendar to write events to if multiple>

Last updated: YYYY-MM-DD
```

### 4. For each missing verified MCP, give an honest install hint

Keep it short and only point to first-party sources:

- **Google Workspace (Gmail / Calendar / Drive)** — "Google publishes an official MCP for Workspace. Search Google's developer docs for `Workspace MCP` to add Gmail / Calendar / Drive."
- **Slack** — "Anthropic's reference Slack MCP at github.com/modelcontextprotocol/servers."
- **Notion** — "Notion publishes an official MCP — see Notion's developer docs."
- **Firecrawl** — "Firecrawl publishes an MCP at firecrawl.dev. Free tier works for typical listing scraping."

For categories without a verified MCP (CRM, e-sign, SMS, MLS): tell the agent honestly that we don't know of a publicly-verified server, and the fallback in NYOA is markdown-in-workspace plus the agent's native tool. No name-dropping of unverified servers.

### 5. Tell the agent how the inventory changes their experience

After writing `connectors.md`, summarize the impact:

- Google Workspace detected → "`/nyoa-buyer-seller-comms` will offer to push email drafts to Gmail. `/nyoa-pipeline` and `/nyoa-weekly-review` will offer to sync deadlines as Calendar events."
- Firecrawl detected → "`/nyoa-listing-audit` will use Firecrawl for Zillow / Redfin / Realtor.com scrapes instead of falling back to manual paste."
- Notion detected → "You can mirror `nyoa-workspace/` content into Notion if you prefer that as your daily UI. Other skills still write to `nyoa-workspace/` as the source of truth."
- No CRM / no e-sign / no SMS / no MLS MCP → "Those workflows stay file-based in `nyoa-workspace/` for now. Update via paste / export / manual logging."

### 6. Re-run friendly

This skill is idempotent. Re-running picks up newly-installed MCPs and updates `connectors.md`. Encourage the agent to re-run after any MCP config change.

## How other skills should consume `connectors.md`

Every NYOA skill that *might* benefit from a connector should:

1. Read `nyoa-context/connectors.md` near the start of its workflow.
2. If the relevant connector is `yes`, offer to use it (don't auto-execute send / sync — always confirm).
3. If `no` or `not-verified-as-of-2025`, fall back to file-only behavior (write a draft to disk, ask the agent to paste / export, etc.) without making the missing connector a blocker.

## Compliance pass

- Don't store API keys, OAuth tokens, account secrets, or auth headers in `connectors.md`. Only namespace identifiers and human-readable settings.
- If the agent volunteers a secret, refuse to save it and tell them where it actually belongs (their MCP server's own config).
- Never instruct the agent to bypass terms of service for any portal (no scraping a site that prohibits it).
- Never invent MCP server names — if you don't know it exists, say so and stop.

## Output format

1. Print the detection summary (the table).
2. Print the install hints for verified MCPs the agent doesn't have yet.
3. Print the "what newly works" summary.
4. Confirm the file write: `Saved to nyoa-context/connectors.md.`

End with: `Voice used: NYOA house`.

## Shared context

This skill is the **primary writer** for `nyoa-context/connectors.md`. All other skills should read from it before deciding whether to invoke a connector vs. fall back to files.

## Reference files

- `plugins/nyoa/references/context-formats.md` — connectors.md schema
