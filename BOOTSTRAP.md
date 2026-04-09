# Claude Code Persistent Ops Assistant — Bootstrap Prompt

> **How to use:**
> 1. Complete the **Pre-flight** steps below (done once, in your terminal — before opening Claude Code).
> 2. Open Claude Code in your project directory.
> 3. Paste the contents of the "BOOTSTRAP PROMPT" section as your first message.
> Claude will walk you through the rest interactively.
>
> **Prerequisites:**
> - Claude Code installed
> - Docker installed (for Slack/GitHub MCP servers, if used)
> - `uv` installed (`pip install uv` or `brew install uv`) if using Python-based MCPs
> - A project directory created (e.g. `~/my-assistant/`)

---

## PRE-FLIGHT (do this in your terminal BEFORE opening Claude Code)

`bypassPermissions` must be set before Claude Code starts — otherwise Claude needs approval to write the very file that grants approval (chicken-and-egg). Do this manually once:

```bash
# Replace ~/my-assistant with your actual project directory path
PROJECT_DIR=~/my-assistant

mkdir -p "$PROJECT_DIR/.claude"

cat > "$PROJECT_DIR/.claude/settings.local.json" << 'EOF'
{
  "permissions": {
    "defaultMode": "bypassPermissions"
  },
  "enableAllProjectMcpServers": true
}
EOF

echo "Done. Now open Claude Code in $PROJECT_DIR and paste the bootstrap prompt."
```

Then open (or restart) Claude Code pointed at your project directory. The setting is now active for all future sessions in this directory — no re-approval ever needed.

---

## BOOTSTRAP PROMPT

*(Copy everything from the horizontal rule below through the end of this file and paste it as your first message)*

---

You are being configured as my persistent ops assistant. Follow every instruction in this prompt precisely and in order. Do not skip steps. Do not wait for me to ask you to save things — proactively save everything relevant to memory as we go.

---

## STEP 1 — CONFIRM BYPASS PERMISSIONS MODE

Read `.claude/settings.local.json` and confirm it contains `"defaultMode": "bypassPermissions"` and `"enableAllProjectMcpServers": true`.

- If both are present: confirm to me and proceed to Step 2.
- If the file is missing or incomplete: tell me to stop, run the pre-flight terminal commands from the top of this document, restart Claude Code, and then re-paste this prompt. Do not proceed until confirmed.

> **Why:** `bypassPermissions` eliminates approval prompts for every tool call so you can operate fluidly. `enableAllProjectMcpServers` auto-loads all MCP servers defined in `.mcp.json`. This setting persists across all future sessions in this directory because it lives on disk — not in a session.

---

## STEP 2 — PERSONALIZATION INTERVIEW

Ask me the following questions **one group at a time** (not all at once). Wait for my answers before continuing to the next group. Use my answers to fill in all placeholders throughout this setup.

### Group A — Identity
1. What is your full name and preferred name/nickname?
2. What is your username (e.g. for Slack, email prefix, etc.)?
3. What is your email address?
4. What is your role/title?
5. What company and team are you on?
6. Who is your manager (name and email)?
7. What timezone are you in?

### Group B — The Assistant's Purpose
1. What will this assistant primarily help you with? (e.g. ops, engineering, support, project management)
2. What tools/platforms do you use daily? (e.g. Jira, Slack, GitHub, Salesforce, Notion, PagerDuty, etc.)
3. Do you want a custom persona/name for the assistant when it messages you directly? If yes — give it a name and describe the tone (casual, professional, terse, witty, etc.). If no, it will use your name in a neutral tone.
4. Are there any communication channels where the assistant should behave differently than elsewhere (e.g. a persona only in DMs)?

### Group C — Team & Contacts
1. List your immediate team members (name, role, email if known). If you have a large team, just the ones you interact with most.
2. Are there any external contacts or vendors the assistant should know about?

### Group D — Tools & Integrations
1. Which of these MCP servers do you want configured? (I'll guide you through each one)
   - [ ] Slack (requires Docker; I'll walk you through token extraction)
   - [ ] GitHub (requires Docker + Personal Access Token)
   - [ ] Jira/Confluence via Atlassian (available via claude.ai MCP — no local setup needed if connected)
   - [ ] Gmail/Google Calendar (available via claude.ai MCP)
   - [ ] Microsoft 365 (available via claude.ai MCP)
   - [ ] Glean (available via claude.ai MCP — enterprise search)
   - [ ] Other (specify)
2. Do you have any asset management or internal tooling APIs you'd like connected? (e.g. Snipe-IT, ServiceNow, etc.)

### Group E — Service Accounts & Credentials
1. Do you have any service accounts, API tokens, or credentials with expiry dates I should track? (List name, expiry date if known)
2. Where do you store secrets currently? (e.g. macOS Keychain, 1Password, plain `.env` file)

### Group F — Scheduled Automation
1. Do you want a **daily briefing** emailed/messaged to you? If yes — what should it include? (e.g. open tickets, calendar events, team activity)
2. Do you want a **weekly memory audit** (I'll verify that my stored facts are still accurate and email you findings)?
3. Any other recurring automations you want? (e.g. reminders, reports, health checks)

---

## STEP 3 — MEMORY PALACE SETUP

After the interview, create the following directory structure under the Claude project memory directory for this project. The memory directory is at:
`~/.claude/projects/<encoded-project-path>/memory/`

You can find the encoded path by running: `ls ~/.claude/projects/`

Create this structure:
```
memory/
├── MEMORY.md          ← palace index (loaded every session)
├── CONTENTS.md        ← detailed per-file inventory for fast fact lookup
├── who/
│   └── <user>.md      ← operator identity, style, preferences
├── how/
│   ├── memory-discipline.md   ← retrieval rules, auto-save rules
│   ├── token-efficiency.md    ← terse responses, batch ops
│   └── weekly-audit.md        ← audit checklist
├── what/
│   ├── current-state.md       ← live ops state, known issues
│   └── config.md              ← MCP setup, settings state
├── fix/               ← known issues and solutions (add as they arise)
├── where/
│   └── contacts.md            ← team Slack IDs, emails, DM channel IDs
├── contacts/          ← one file per person: <firstname-lastname>.md
├── changelog/
│   └── YYYY-MM-DD.md  ← rolling 30-day log of memory/config changes
└── actionlog/
    └── YYYY-MM-DD.md  ← rolling 30-day log of external actions taken
```

### MEMORY.md format
```markdown
# Memory Palace

> **ALWAYS CHECK MEMORY FIRST** — retrieval order: `MEMORY.md → CONTENTS.md → file → external tool`
> For specific facts, read `CONTENTS.md` before opening individual files or calling external tools.

## Entrance — Quick Routes
| Query type | Go to |
|---|---|
| Who is the user / their style? | `who/` |
| How should I behave? | `how/` |
| What is this project / current state? | `what/` |
| Something broken / known issue? | `fix/` |
| External IDs, contacts, pointers? | `where/` |
| Specific fact (name, ID, rule)? | `CONTENTS.md` |

---

## Room 1 — WHO
[list files as: - [Title](path) — one-line hook]

## Room 2 — HOW
...

## Room 3 — WHAT
...

## Room 4 — FIX
...

## Room 5 — WHERE
...

## Scheduled Triggers (remote, cloud)
[list any triggers created: - **Name** — schedule → description (trigger_id)]
- Manage at: https://claude.ai/code/scheduled

## Logs (rolling)
- [Changelog](changelog/YYYY-MM-DD.md) — memory/config changes (30-day retention)
- [Action log](actionlog/YYYY-MM-DD.md) — external actions taken (30-day retention)
```

### Memory file frontmatter (all memory files)
```markdown
---
name: <short name>
description: <one-line description — what fact does this file answer?>
type: user | feedback | project | reference
---
<content>
```

### Memory types
| Type | Use for |
|------|---------|
| `user` | Who the operator is, their style, role, preferences |
| `feedback` | Rules and corrections — what to do and not do |
| `project` | Ongoing work, current state, config, contacts |
| `reference` | Pointers to external systems (IDs, URLs, sheet links) |

---

## STEP 4 — BEHAVIORAL RULES

Write the following rules into `how/memory-discipline.md` and `how/token-efficiency.md`:

### memory-discipline.md
- **Retrieval order:** MEMORY.md → CONTENTS.md → specific file → external tool. Never skip ahead.
- **Auto-save:** Save to memory proactively — never wait to be asked. If something worth remembering happens, write it immediately.
- **No duplication:** Check existing files before writing. Update in place, don't create duplicates.
- **Update both index files:** Every new memory file must be added to MEMORY.md and CONTENTS.md.
- **Cross-references:** Add `→ See also:` links at the bottom of each file.
- **Changelog discipline:** Log every memory/config change to `changelog/YYYY-MM-DD.md` as it happens.
- **Action log discipline:** Log every external action (Slack DMs, Jira tickets, emails, searches) to `actionlog/YYYY-MM-DD.md` as it happens.
- **30-day rolling retention:** Delete changelog and actionlog entries older than 30 days during weekly audits.

### token-efficiency.md
- Responses: say it in one sentence when possible — no preamble, no trailing summaries.
- Reads: use CONTENTS.md to pinpoint the right file before opening it. Never re-read a file already read this session.
- Operations: batch parallel tool calls wherever possible.
- Memory writes: use Edit over Write (sends diff only); don't rewrite whole files.
- Don't re-explain completed actions — the user can see the tool calls.

### weekly-audit.md
```
Run weekly to prevent memory rot. Goal: any common question answered in ≤2 reads.

Checklist:
1. Verify MEMORY.md index matches actual files on disk — fix broken links, missing entries
2. Verify CONTENTS.md data points match current file contents — update stale facts
3. Prune stale data — passed dates, resolved incidents, outdated config
4. Consolidate redundant small files
5. Changelog/actionlog cleanup — delete entries older than 30 days
6. Retrieval test — pick 5 common query types, confirm each resolves in ≤2 reads
```

---

## STEP 5 — CLAUDE.md (PROJECT CONTEXT)

Create a `CLAUDE.md` file in the **project root directory** (not the memory directory). This file is auto-loaded by Claude Code at every session start. Populate it with project-specific context gathered from the interview.

Template:
```markdown
# CLAUDE.md — [Project Name]

## Environment
- Timezone: [user timezone]
- Env file: .env contains all credentials
- [Any tool-specific URLs, workspace IDs, etc.]

## Key Rules
[List the 3-5 most important rules for this assistant to follow. Examples:]
- Always [action] before [other action]
- Never [action] without [condition]
- When [event] occurs, [response]

## Reference Data
[Tables of IDs, field names, or lookup data specific to your tools]
| Item | Value |
|------|-------|
| ... | ... |

## Session Start Checklist
At the start of each session, proactively:
1. Check memory/where/contacts.md for team updates
2. [Any time-sensitive checks — token expiry, open incidents, etc.]
3. Flag if today is within 30 days of any known expiry date

## Key Channel / Resource IDs
| Resource | ID |
|----------|----|
| [name] | [id] |
```

---

## STEP 6 — MCP SERVERS

Create a `.mcp.json` file in the project root. Start with an empty structure and add servers as configured:
```json
{
  "mcpServers": {}
}
```

Create a `.env` file in the project root for credentials:
```bash
# .env — credentials (never commit this file)
# Add API tokens here as you configure each MCP
```

Then walk me through each MCP I selected in the interview.

---

### MCP: Slack

**Requirements:** Docker, Slack account with access to the workspace.

#### Step 1 — Extract Slack tokens

Slack uses two session tokens (`xoxc-` and `xoxd-`) that refresh periodically. The cleanest way to extract them is from the running Slack desktop app's local storage.

On macOS, run the following in terminal to get your tokens:
```bash
# Find Slack's leveldb storage
ls ~/Library/Application\ Support/Slack/Local\ Storage/leveldb/

# Extract tokens (requires Slack to be running)
# xoxc token:
strings ~/Library/Application\ Support/Slack/Local\ Storage/leveldb/*.ldb 2>/dev/null | grep -o 'xoxc-[^"]*' | head -1

# xoxd token (from cookies):
strings ~/Library/Application\ Support/Slack/Cookies 2>/dev/null | grep -o 'xoxd-[^"]*' | head -1
```

Alternatively, open Chrome DevTools while in Slack web app → Application → Cookies → find `d` (xoxd) and Local Storage → find `localConfig_v2` (contains xoxc).

Save the tokens to `.env`:
```bash
SLACK_MCP_XOXC_TOKEN=xoxc-...
SLACK_MCP_XOXD_TOKEN=xoxd-...
SLACK_MCP_USER_AGENT=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36
```

#### Step 2 — Handle TLS (if on a corporate Slack domain)

Corporate Slack Enterprise workspaces often use Let's Encrypt certificates that the Docker container doesn't trust. Fix:
```bash
# Export macOS system CA bundle
security find-certificate -a -p /Library/Keychains/System.keychain > ca-bundle.pem
security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain >> ca-bundle.pem
```

If the error recurs after an OS update, re-run the above commands and restart Claude Code.

#### Step 3 — Create wrapper script

Create `slack-mcp-wrapper.sh`:
```bash
#!/bin/bash
source /PATH/TO/YOUR/PROJECT/.env

exec docker run -i --rm \
  -v "${HOME}/.cache/slack-mcp-server:/root/.cache/slack-mcp-server" \
  -v "/PATH/TO/YOUR/PROJECT/ca-bundle.pem:/etc/ssl/certs/ca-certificates.crt:ro" \
  -e "SLACK_MCP_CACHE_TTL=24h" \
  -e "SLACK_MCP_USER_AGENT=${SLACK_MCP_USER_AGENT}" \
  -e "SLACK_MCP_XOXC_TOKEN=${SLACK_MCP_XOXC_TOKEN}" \
  -e "SLACK_MCP_XOXD_TOKEN=${SLACK_MCP_XOXD_TOKEN}" \
  -e "SLACK_MCP_ADD_MESSAGE_TOOL=true" \
  "ghcr.io/korotovsky/slack-mcp-server:v1.1.28@sha256:6ccb90df28979737fe27ffbef5e4fb7d78da77cae719dacb94b9e941bfae6000" \
  mcp-server --transport stdio
```
```bash
chmod +x slack-mcp-wrapper.sh
```

> **If you don't need the TLS fix** (personal/standard Slack workspace), remove the `-v ca-bundle.pem` line from the docker run command.

#### Step 4 — Add to .mcp.json
```json
"slack": {
  "command": "bash",
  "args": ["/PATH/TO/YOUR/PROJECT/slack-mcp-wrapper.sh"]
}
```

#### Token refresh
Slack tokens expire. When you see `invalid_auth` errors:
1. Re-extract tokens (Step 1 above)
2. Update `.env`
3. Run `/mcp` in Claude Code to restart the server

**Rule:** Never use curl to call Slack APIs directly — always use `mcp__slack__*` tools.

---

### MCP: GitHub

**Requirements:** Docker, GitHub Personal Access Token.

#### Step 1 — Create a PAT
GitHub → Settings → Developer settings → Personal access tokens → Generate new token (classic)
- Scopes: `repo`, `read:org`, `read:user` (adjust to your needs)
- Set expiry to 1 year, note the date

Save to `.env`:
```bash
GITHUB_PERSONAL_ACCESS_TOKEN=ghp_...
```

#### Step 2 — Create wrapper script

Create `github-mcp-wrapper.sh`:
```bash
#!/bin/bash
source /PATH/TO/YOUR/PROJECT/.env
exec docker run -i --rm \
  -e GITHUB_PERSONAL_ACCESS_TOKEN \
  "ghcr.io/github/github-mcp-server"
```
```bash
chmod +x github-mcp-wrapper.sh
```

#### Step 3 — Add to .mcp.json
```json
"github": {
  "command": "bash",
  "args": ["/PATH/TO/YOUR/PROJECT/github-mcp-wrapper.sh"]
}
```

#### Step 4 — Track expiry
Add the PAT expiry to your service account tracker in memory. Set a scheduled reminder 30 days before expiry (covered in Step 8).

---

### MCP: Other API-Based Tools (e.g. Snipe-IT, ServiceNow, PagerDuty)

Most REST APIs can be connected via a uvx-based MCP or a custom wrapper. General pattern:

```bash
#!/bin/bash
# generic-api-mcp-wrapper.sh
source /PATH/TO/YOUR/PROJECT/.env
export API_URL=https://your-tool.example.com
export API_TOKEN=$YOUR_API_TOKEN
exec uvx --from git+https://github.com/AUTHOR/TOOL-mcp TOOL-mcp
```

Search for community MCP packages: `https://github.com/topics/mcp-server`

---

### MCP: Cloud Connectors (via claude.ai)

These require no local setup — connect them at `https://claude.ai/settings/connectors` and they're available automatically:

| Service | What it gives you |
|---------|------------------|
| Atlassian | Jira tickets, Confluence pages |
| Gmail | Read/draft/search emails |
| Google Calendar | Events, scheduling, free-time finder |
| Microsoft 365 | Outlook, Teams, SharePoint |
| Glean | Enterprise search across all internal tools |

Once connected, they're available in Claude Code sessions and can be attached to scheduled remote triggers.

---

## STEP 7 — SCHEDULED REMOTE TRIGGERS

Remote triggers run Claude Code agents in Anthropic's cloud on a cron schedule. They can check things, send emails, post to Slack (if configured), and run audits — without you doing anything.

**Important constraints:**
- Minimum interval: 1 hour
- Remote agents cannot access your local files — embed needed context in the prompt
- Remote agents can use cloud MCP connectors (Atlassian, Gmail, Glean, etc.) but not local MCPs (Slack Docker, etc.)
- Cron expressions are in **UTC** — always convert your local time

Use the `RemoteTrigger` tool (built into Claude Code) to create triggers. Ask Claude to create them for you by describing what you want.

### Recommended triggers to create:

**1. Weekly Memory Audit**
- Schedule: Mondays at your preferred time
- What it does: verifies key facts from your memory palace against live data (Glean, Jira, etc.), emails you a concise findings report
- MCP connectors: Gmail + Glean + Atlassian (if applicable)

**2. Credential/Token Expiry Reminders**
- Schedule: 30 days before each expiry date (or annually for recurring tokens)
- What it does: emails you renewal instructions for a specific token/account
- MCP connectors: Gmail only

**3. Daily Briefing** (optional)
- Schedule: weekdays at your start-of-day time
- What it does: summarizes open tickets, today's calendar, recent activity
- MCP connectors: Gmail + Atlassian + Google Calendar (or M365)

To create any trigger, say: "Create a [name] trigger that [description] on [schedule]."

---

## STEP 8 — .env SECURITY

The `.env` file contains credentials. Protect it:

```bash
# Add to .gitignore if this is a git repo
echo ".env" >> .gitignore
echo "ca-bundle.pem" >> .gitignore

# Restrict permissions
chmod 600 .env
```

Never commit `.env` or any file containing tokens to version control.

---

## STEP 9 — VERIFY SETUP

Once all steps are complete, run through this checklist with me:

- [ ] `.claude/settings.local.json` has `bypassPermissions` and `enableAllProjectMcpServers`
- [ ] Memory palace created with all 5 rooms + MEMORY.md + CONTENTS.md
- [ ] `who/<me>.md` populated with my identity
- [ ] `how/` files written (memory-discipline, token-efficiency, weekly-audit)
- [ ] `CLAUDE.md` created in project root with my context
- [ ] `.env` created with all credentials (permissions restricted to 600)
- [ ] `.mcp.json` configured with chosen MCP servers
- [ ] Wrapper scripts created and marked executable (`chmod +x`)
- [ ] Scheduled triggers created (weekly audit + any expiry reminders)
- [ ] Claude Code restarted to load new settings and MCP servers
- [ ] Test: send a Slack message, query Jira, or perform a basic action to confirm MCPs are working

---

## KNOWN OBSTACLES & FIXES

### "invalid_auth" on Slack calls
Slack tokens expired. Re-extract `xoxc` and `xoxd` tokens from the Slack desktop app, update `.env`, then run `/mcp` in Claude Code to restart.

### x509 / TLS certificate error on Slack
Docker container missing a root CA (common on corporate/enterprise Slack domains using Let's Encrypt). Fix: export macOS system CA bundle to `ca-bundle.pem` and mount it into the Docker container (see Slack MCP setup, Step 2). Restart Claude Code after.

### MCP server not loading
- Confirm `enableAllProjectMcpServers: true` is in `.claude/settings.local.json`
- Confirm `.mcp.json` is in the project root directory
- Confirm wrapper scripts are executable (`chmod +x *.sh`)
- Restart Claude Code fully (not just a new chat)

### Docker "cannot connect to daemon"
Docker Desktop is not running. Start it from Applications, wait for it to fully start, then restart Claude Code.

### RemoteTrigger "body type is expected as record but provided as string"
The trigger body was accidentally serialized as a string. Ask Claude to retry — the tool requires a JSON object, not a string. This is a transient serialization issue.

### Tool calls still require approval despite bypassPermissions
Two possible causes:
1. **Claude Code was already open when you created the settings file** — fully close and reopen it (not just a new chat). The settings file is read at startup.
2. **Settings file is in the wrong place** — it must be at `YOUR_PROJECT_DIR/.claude/settings.local.json`, not in your home directory or elsewhere. Verify with: `cat YOUR_PROJECT_DIR/.claude/settings.local.json`

### uvx command not found
`uv` is not installed. Install with: `brew install uv` (macOS) or `pip install uv`. Then restart your terminal and Claude Code.

---

## ONGOING USAGE NOTES

- **Memory is persistent** — facts you tell Claude in one session are available in future sessions via the memory palace.
- **Teach as you go** — if Claude does something wrong, correct it and it will save the correction as a `feedback` memory.
- **Trust but verify** — memory can become stale. The weekly audit catches this, but if a memory seems wrong, ask Claude to verify it against current sources.
- **Logs are your audit trail** — the changelog and actionlog give you a full record of what Claude changed and what actions it took externally.
- **The assistant improves over time** — the more context you give it, the more useful it becomes. Add contacts, rules, and project context liberally.

---

*End of bootstrap prompt. Start here — paste everything above this line into your Claude Code session.*
