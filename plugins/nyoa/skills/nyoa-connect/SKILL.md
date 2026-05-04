---
name: nyoa-connect
description: Detect which MCP servers and external tools the agent has wired up (Gmail, Calendar, Drive, DocuSign, Twilio, CRM, MLS, Firecrawl) and record the inventory in nyoa-context/connectors.md so other NYOA skills can branch on availability. Use this skill when an agent says "check my tools", "what connectors do I have", "connect Gmail", "set up integrations", or "wire up my CRM". Triggers on phrases like "connectors", "connect", "integrations", "tools", "mcp", "hook up gmail", "hook up calendar".
---

# Connectors

Detect what external tools the agent has available, document the inventory in `nyoa-context/connectors.md`, and explain how every other NYOA skill should use what's there. This skill ships **no integration code** — it works by checking which MCP tool namespaces are exposed in the current session.

## When this skill triggers

- "What connectors do I have" / "check my tools" / "what’s wired up"
- "Connect Gmail" / "hook up calendar" / "set up DocuSign" / "add my CRM"
- "Set up integrations" / "add MCP"
- After `/nyoa-setup` completes and tells the agent to run this skill

## Inputs you need

Nothing. The skill detects what’s available; for missing tools, it asks the agent which ones they actually use.

## Workflow

### 1. Detect available MCP tool namespaces

Look at the tool list available in the current session. Match against this catalogue (the namespace prefix may vary by MCP install — substring-match on the keywords in parentheses):

| Connector | Detection keywords (in tool names) | Used by NYOA for |
|-----------|-----------------------------------|------------------|
| Gmail | `gmail`, `google_mail`, `mail_send`, `draft` | Sending drafts from `/nyoa-buyer-seller-comms`, `/nyoa-testimonial-engine` review requests |
| Google Calendar | `calendar`, `gcal`, `event` | Syncing showings + follow-ups from `/nyoa-pipeline` and `/nyoa-weekly-review` |
| Google Drive | `drive`, `gdrive`, `google_doc` | Storing contracts, photos, listing presentations |
| Dropbox | `dropbox` | Same as Drive |
| DocuSign | `docusign`, `envelope` | Listing agreements, offers, disclosures |
| Twilio (SMS) | `twilio`, `sms`, `message_send` | SMS drafts from `/nyoa-buyer-seller-comms`, review-request follow-up SMS |
| Follow Up Boss | `followupboss`, `fub` | CRM sync — leads, contacts, notes |
| HubSpot | `hubspot` | CRM sync |
| Salesforce | `salesforce`, `sfdc` | CRM sync |
| kvCORE / Sierra / Lofty | `kvcore`, `sierra`, `lofty`, `chime` | CRM sync |
| Firecrawl | `firecrawl` | Listing scrapes for `/nyoa-listing-audit` |
| MLS portal | `mls`, `flexmls`, `paragon`, `matrix`, `bright`, `crmls` | Comps + active listing search |
| Notion | `notion` | Alternative workspace storage |
| Slack | `slack` | Team notifications |

Also check whether `WebFetch`, `WebSearch`, and image/file MCPs are available — most setups have these and they’re used by audit + AEO skills.

### 2. Ask about anything ambiguous

For connectors not auto-detected, ask the agent in one short list: "Which of these do you actively use? (Gmail, Google Calendar, Drive/Dropbox, DocuSign, Twilio, a CRM — and which one, an MLS portal — and which one)". Skip what they don’t use.

For each tool the agent uses but doesn’t have wired up as an MCP, capture it as `wanted: yes` (so we can flag the gap).

### 3. Write `nyoa-context/connectors.md`

Use the format defined in `plugins/nyoa/references/context-formats.md`. Always write the full file (overwrite is OK here — this is canonical state, not a log). Include:

```markdown
# Connectors

## Available
- gmail: yes — namespace: mcp__gmail__*
- google-calendar: yes — namespace: mcp__gcal__*
- google-drive: no
- docusign: no
- twilio: no
- crm: follow-up-boss — namespace: mcp__followupboss__*
- mls: no — wanted: yes (Bright MLS)
- firecrawl: yes

## Notes
- Default email send-from: <agent’s email if known>
- Default calendar: <which calendar to write events to if multiple>
- CRM list ID for new leads: <if applicable>

Last updated: YYYY-MM-DD
```

### 4. Show the agent install instructions for what they want but don’t have

For each `wanted: yes` line, give a short, pasteable install hint. NYOA does not ship MCP servers — we point at the canonical install path:

- **Gmail / Calendar / Drive**: Anthropic’s reference Google MCP, or `mcp-server-gsuite` style packages. Tell the agent: "Add the Google MCP server in your Claude Code `~/.claude/settings.json`, then re-run `/nyoa-connect` to detect it."
- **DocuSign**: most reliable path is the official DocuSign developer API + a community MCP. "No first-party MCP yet — if you want it now, fall back to manual: drop signed PDFs into `documents.md` per client."
- **Twilio**: Twilio has an MCP. "Install via your Claude Code MCP config; needs a Twilio account SID + auth token."
- **CRM**: depends on the CRM. Follow Up Boss has a public API; HubSpot has a community MCP. Tell the agent which one applies and link them to documentation in their CRM.
- **MLS**: gated by region. "Most MLSs don’t have public APIs. The fallback is paste-in: export comps as CSV from your MLS portal and paste here — `/nyoa-listing-new` and `/nyoa-listing-audit` will parse them."
- **Firecrawl**: "`pip install firecrawl-py` or the Firecrawl-MCP package; needs a free API key from firecrawl.dev."

Keep these hints short — don’t turn the output into a tutorial. The goal is to make the gap visible, not to handhold the install.

### 5. Tell the agent how this changes their experience

After writing connectors.md, summarize what newly works and what doesn’t:

- ✅ "Gmail detected — `/nyoa-buyer-seller-comms` will now offer to send drafts directly."
- ✅ "Google Calendar detected — `/nyoa-pipeline` will offer to sync next-step deadlines as events."
- ⚠️ "No CRM detected — leads will live in `nyoa-workspace/` only. If you bring a CRM, lead state will sync."
- ⚠️ "No MLS detected — paste comps as CSV when running `/nyoa-listing-audit`."

### 6. Re-run friendly

This skill is idempotent. Re-running picks up newly-installed MCPs and updates `connectors.md`. Encourage the agent to re-run after any MCP config change.

## How other skills should consume `connectors.md`

Every NYOA skill that *might* benefit from a connector should:

1. Read `nyoa-context/connectors.md` near the start of its workflow.
2. If the relevant connector is `yes`, offer to use it (don’t auto-execute send/sync — always confirm).
3. If `no`, fall back to file-only behavior (write a draft to disk, ask the agent to paste/export, etc.) without making the missing connector a blocker.

This branching pattern keeps the plugin instruction-only — we don’t ship adapter code, we just teach skills to look for what’s already there.

## Compliance pass

- Don’t store API keys, OAuth tokens, account secrets, or auth headers in `connectors.md`. Only namespace identifiers and human-readable settings.
- If the agent volunteers a secret, refuse to save it and tell them where it actually belongs (their MCP server’s own config).
- For CRM / MLS, never instruct the agent to bypass terms of service (no scraping a portal that prohibits it).

## Output format

1. Print the detection summary (the table).
2. Print the install hints for `wanted: yes` items.
3. Print the "what newly works" summary.
4. Confirm the file write: `Saved to nyoa-context/connectors.md.`

End with: `Voice used: NYOA house`.

## Shared context

This skill is the **primary writer** for `nyoa-context/connectors.md`. All other skills should read from it before deciding whether to invoke a connector vs. fall back to files.

## Reference files

- `plugins/nyoa/references/context-formats.md` — connectors.md schema
