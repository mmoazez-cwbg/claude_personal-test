# Claude Ops Assistant — Bootstrap & Setup Guide

> **How to use this file:**
> Open a new Claude Code session in your project directory and run:
> `Prompt: Parse through /path/to/claude-assistant-bootstrap.md and execute the changes.`
> Claude will read this file, propose a setup plan, and walk you through it interactively.
>
> **Prerequisites:**
> - Claude Code installed
> - Docker installed (for Slack/GitHub MCP servers)
> - `uv` installed (`brew install uv` or `pip install uv`) for Python-based MCPs
> - A project directory created (e.g. `~/my-assistant/`)

---

## CLAUDE — PARSE INSTRUCTIONS (read before doing anything else)

You are setting up a persistent ops assistant for a new user. Follow this exactly:

### 0A — Optimization Analysis
Before making any changes, read this entire file and compile a short summary:
- What will be set up automatically vs. what requires user input
- Any optimizations or additions you'd suggest given the user's context
- Any steps you can skip if certain tools aren't relevant

Present this as a brief bullet list. Ask the user if they'd like to proceed, adjust scope, or skip anything.

### 0B — Source Selection
Ask the user:

> "Would you like to:
> **(A) Pull the base from the public template repo** (`https://github.com/mmoazez-cwbg/claude_personal-test`) — includes pre-built scripts, wrapper templates, memory structure, and known fixes pre-applied. Fastest start.
> **(B) Build from scratch** — cleaner slate, more manual setup, but nothing inherited you didn't choose.
>
> If (A): I'll clone/copy the repo contents, then customize for your environment.
> If (B): I'll create everything from the steps below."

Wait for their answer before proceeding.

---

## STEP 1 — PERMISSIONS

`bypassPermissions` must be set before Claude Code starts — otherwise Claude needs approval
to write the very file that grants it. Do this once in your terminal before opening Claude Code:

```bash
PROJECT_DIR=~/my-assistant   # change to your project path

mkdir -p "$PROJECT_DIR/.claude"
cat > "$PROJECT_DIR/.claude/settings.local.json" << 'EOF'
{
  "permissions": {
    "defaultMode": "bypassPermissions"
  },
  "enableAllProjectMcpServers": true
}
EOF
echo "Done. Open Claude Code in $PROJECT_DIR and paste the bootstrap prompt."
```

Then fully restart Claude Code. Claude should verify this is set before proceeding with any setup.

**Verify:** Read `.claude/settings.local.json` and confirm both keys are present.
If missing — stop and instruct the user to run the above commands, then restart Claude Code.

---

## STEP 2 — PERSONALIZATION INTERVIEW

Ask questions **one group at a time**. Wait for answers before the next group.

### Group A — Identity
1. Full name and preferred name/nickname?
2. Username (Slack handle, email prefix)?
3. Email address?
4. Role/title?
5. Company and team?
6. Manager's name, email, Slack username?
7. Timezone?

### Group B — Assistant Purpose
1. What will this assistant primarily help with? (ops, engineering, support, PM, etc.)
2. Daily tools/platforms? (Jira, Slack, GitHub, PagerDuty, Salesforce, Notion, etc.)
3. Want a custom persona/name for bot DMs? If yes — name + tone (casual, terse, witty, etc.)
4. Any channels where the persona should differ? (e.g. formal in group channels, casual in DMs)

### Group C — Team & Contacts
1. Immediate team members (name, role, email if known)?
2. Any VIPs — people whose messages should trigger immediate alerts? (manager + up to 3 others)
3. External contacts or vendors to know about?

### Group D — Tools & Integrations
Which MCP servers to configure?
- [ ] Slack (Docker + session tokens — I'll walk you through extraction)
- [ ] GitHub (Docker + Personal Access Token)
- [ ] Atlassian/Jira/Confluence (claude.ai MCP connector — no local setup)
- [ ] Gmail / Google Calendar (claude.ai MCP connector)
- [ ] Microsoft 365 (claude.ai MCP connector)
- [ ] Glean (claude.ai MCP connector — enterprise search)
- [ ] Snipe-IT or other asset/ITSM tool (API-based)
- [ ] Other (specify)

### Group E — Credentials & Expiry
1. Service accounts or API tokens with expiry dates? (name + expiry)
2. Where do you store secrets? (macOS Keychain, 1Password, plain `.env`)

### Group F — Scheduling
1. Want a **daily briefing**? What should it cover?
2. Want a **weekly memory audit** (I verify stored facts against live data, email findings)?
3. Other recurring automations?

---

## STEP 3 — PROJECT STRUCTURE

Create this layout (skip anything from the template repo if using option A):

```
<project-root>/
├── .env                        # ALL secrets — never commit
├── .gitignore                  # Must include .env, ca-bundle.pem, *.lock
├── .claude/
│   └── settings.local.json     # bypassPermissions + enableAllProjectMcpServers
├── .mcp.json                   # MCP server definitions
├── CLAUDE.md                   # Session checklist — loaded every session
├── memory/                     # Git-tracked palace snapshot (synced from ~/.claude)
│   ├── MEMORY.md               # Index — always loaded
│   ├── CONTENTS.md             # Fact index for fast lookup
│   ├── who/                    # User identity + preferences
│   ├── how/                    # Behavioral rules
│   ├── what/                   # Project context and state
│   ├── fix/                    # Known issues and solutions
│   ├── where/                  # External IDs, contacts, pointers
│   ├── contacts/               # One file per person: <firstname-lastname>.md
│   ├── changelog/              # YYYY-MM-DD.md — rolling 30-day
│   └── actionlog/              # YYYY-MM-DD.md — rolling 30-day
├── tars-support/scripts/
│   └── extract-slack-tokens.py # Token extractor (see Step 8)
├── sync-memory.sh              # Syncs Claude memory → git-tracked memory/
├── slack-mcp-wrapper.sh
├── github-mcp-wrapper.sh
└── snipeit-mcp-wrapper.sh      # Optional
```

### .gitignore (minimum)
```
.env
ca-bundle.pem
*.lock
.DS_Store
__pycache__/
*.pyc
```

---

## STEP 4 — CLAUDE.md TEMPLATE

Create in project root. Loaded every session automatically.

```markdown
# CLAUDE.md — [Project Name]

## Environment
- Timezone: [user timezone]
- Env file: .env contains all credentials
- [Tool-specific URLs, workspace IDs, etc.]

## Session Start Checklist
At the start of each session, proactively:
1. **MCP health check** — auto-fix before escalating. See `memory/how/mcp-health-monitoring.md`.
2. **Inbox check** — mentions + VIP DMs past 24h; re-surface `/tmp/slack_monitor_pending.txt`.
   Then start two CronCreate jobs (session-only, must be recreated each session — user does not do this).
   See `memory/how/inbox-monitoring.md`.
3. Check `memory/where/contacts.md` for any new contacts needed.
4. Flag if any service account token expiry is within 30 days — see `memory/what/service-accounts.md`.

**Pending messages:** Never auto-clear. Remove from `/tmp/slack_monitor_pending.txt` only when user explicitly confirms handled.

## Key Rules
[Fill in: Always X before Y. Never Z without W. etc.]

## Reference Data
[Tables of IDs, field names specific to your tools]
```

---

## STEP 5 — MEMORY PALACE

Create in `~/.claude/projects/<encoded-project-path>/memory/`.
Find encoded path: `ls ~/.claude/projects/`

### MEMORY.md (palace index)
```markdown
# Memory Palace

> **ALWAYS CHECK MEMORY FIRST** — retrieval order: MEMORY.md → CONTENTS.md → file → external tool

## Entrance — Quick Routes
| Query type | Go to |
|---|---|
| Who is the user / their style? | `who/` |
| How should I behave? | `how/` |
| What is this project / current state? | `what/` |
| Something broken / known issue? | `fix/` |
| External IDs, contacts, pointers? | `where/` |
| Specific fact? | `CONTENTS.md` |

## Room 1 — WHO
- [User profile](who/user.md)

## Room 2 — HOW
- [MCP health monitoring](how/mcp-health-monitoring.md)
- [Inbox monitoring](how/inbox-monitoring.md)
- [Messaging preferences](how/messaging-preferences.md)
- [Git commit cadence](how/git-commits.md)
- [No secrets in commits](how/no-secrets-in-commits.md)
- [Memory discipline](how/memory-discipline.md)
- [Token efficiency](how/token-efficiency.md)

## Room 3 — WHAT
- [Project overview](what/overview.md)
- [Current state](what/current-state.md)
- [Config](what/config.md)
- [Service accounts](what/service-accounts.md)

## Room 4 — FIX
- [Slack TLS](fix/slack-tls.md)
- [Slack auth self-healing](fix/slack-auth-selfheal.md)
- [Slack UA extraction bug](fix/slack-ua-bug.md)
- [GitHub MCP cold-start](fix/github-mcp-coldstart.md)

## Room 5 — WHERE
- [Contacts](where/contacts.md)

## Scheduled Triggers (remote, cloud)
- Manage at: https://claude.ai/code/scheduled
```

### Memory file frontmatter (every file)
```markdown
---
name: <short name>
description: <one-line description>
type: user | feedback | project | reference
---
```

---

## STEP 6 — CORE HOW-TO FILES

Write these into `how/`:

### `how/mcp-health-monitoring.md`
At session start, verify all MCP servers before doing anything else.

**Slack MCP** (`mcp__slack__channels_list` limit 1):
- `invalid_auth` → self-heal (see `fix/slack-auth-selfheal.md`)
- Uses korotovsky/slack-mcp-server via Docker — NOT the built-in claude.ai Slack MCP

**GitHub MCP** (`mcp__github__get_me`):
- Tools missing → `docker pull ghcr.io/github/github-mcp-server` then `/mcp` restart

**Other MCPs:** If tools missing from system-reminder, check wrapper script and restart.

Always attempt auto-fix. Only escalate to user if fix fails after one attempt.

### `how/inbox-monitoring.md`
At session start: search Slack for high-priority messages (past 24h), then start two CronCreate jobs.

**VIP users (fill in for your org):**
- Your manager — DM messages + thread replies
- Key stakeholders

**Session crons (auto-create at session start each time — session-only, not durable):**
- Every 1 min: mentions + VIP DMs; re-surface pending; silent if nothing
- Every 6 hours: VIP relationship check (poll `vip_users` from Slack prefs, update memory if changed)

**Pending tracking:**
- New message found → write to `/tmp/slack_monitor_seen.txt` (dedup) AND `/tmp/slack_monitor_pending.txt` (display)
- Every cron run: re-display all pending items until user confirms
- Never auto-clear — only remove after explicit user confirmation
- Format: `ts|||label|||summary`

**Channel follow-up:**
After clearing a VIP channel from pending, re-check that channel for new activity before treating as done.

### `how/git-commits.md`
Commit after each meaningful change during a session — not just at the end.
Never commit `.env` or any file containing secrets/tokens/API keys.

### `how/no-secrets-in-commits.md`
Never commit secrets: API keys, bearer tokens, session cookies, passwords, .env files.
Audit staged files with `git diff --cached` before every commit.

### `how/messaging-preferences.md`
Fill in per user preferences. Common rules:
- For personal/social messages, always DM — never post to a channel
- If no DM channel exists, open one via `conversations.open` API autonomously
- Save returned channel ID to contacts memory immediately
- Never ask user to open the DM themselves

---

## STEP 7 — KNOWN FIXES

Write these into `fix/`:

### `fix/slack-auth-selfheal.md`
When Slack MCP returns `invalid_auth` — handle autonomously, never ask user to run `/mcp`:

1. Re-extract tokens:
```bash
source .env
SLACK_SAFE_STORAGE_PASSWORD=$(security find-generic-password -s "Slack Safe Storage" -w) \
  uv run tars-support/scripts/extract-slack-tokens.py
```
2. Kill the running container:
```bash
docker ps --filter "ancestor=ghcr.io/korotovsky/slack-mcp-server" \
  --format "{{.ID}}" | xargs -r docker kill
```
3. Retry — Claude Code restarts the subprocess with fresh tokens automatically.
4. If extracted tokens are still invalid: Slack desktop app is signed out. Ask user to sign in, then redo step 1.

### `fix/slack-ua-bug.md`
Slack leveldb stores User-Agent as JSON context. Raw extraction may include an embedded `"` character, e.g.:
`...Slack_SSB/4.48.102","sdkVersion"...`

If the UA is split at this quote, the token is truncated → Slack rejects auth and may
invalidate the desktop session.

**Fix in `tars-support/scripts/extract-slack-tokens.py`** — after extracting the UA:
```python
ua = ua.split('"')[0].strip()
```

**Verify:** `SLACK_MCP_USER_AGENT` in `.env` should be a single clean UA string with no embedded quotes.

### `fix/slack-tls.md`
Slack MCP Docker container fails with x509 certificate error (ISRG Root X1 / Let's Encrypt).
Common on enterprise Slack domains.

Fix — mount system CA bundle into the container in `slack-mcp-wrapper.sh`:
```bash
-v "/path/to/ca-bundle.pem:/etc/ssl/certs/ca-certificates.crt:ro"
```

Generate `ca-bundle.pem`:
```bash
security find-certificate -a -p /Library/Keychains/System.keychain > ca-bundle.pem
security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain >> ca-bundle.pem
```

### `fix/github-mcp-coldstart.md`
GitHub MCP tools missing on first session — Docker image not pre-pulled.

Fix:
```bash
docker pull ghcr.io/github/github-mcp-server
```
Then `/mcp` to restart. Tools appear on next start.

---

## STEP 8 — SLACK MCP SETUP

Uses korotovsky/slack-mcp-server (Docker) — full session access including DMs + private channels.
The built-in claude.ai Slack MCP uses bot tokens and lacks DM/private channel access.

### Token extraction (`tars-support/scripts/extract-slack-tokens.py`)

This script extracts `xoxc` + `xoxd` tokens and User-Agent from macOS Keychain + leveldb.
It must apply the UA bug fix (split at embedded `"`) before writing to `.env`.

Pseudocode for the script:
```python
import subprocess, os, re

# Extract xoxc from leveldb
# (use leveldb reader or parse .ldb files for xoxc- prefixed strings)

# Extract xoxd from Cookies SQLite
# (query cookies.db for name='d', value starting with xoxd-)

# Extract User-Agent from leveldb JSON context
# CRITICAL: strip at embedded quote
ua = raw_ua_from_leveldb.split('"')[0].strip()

# Write to .env
env_path = os.path.join(os.path.dirname(__file__), '../../.env')
# Update SLACK_MCP_XOXC_TOKEN, SLACK_MCP_XOXD_TOKEN, SLACK_MCP_USER_AGENT in .env
```

**Manual extraction fallback:**
```bash
# xoxc (from leveldb):
strings ~/Library/Application\ Support/Slack/Local\ Storage/leveldb/*.ldb 2>/dev/null \
  | grep -o 'xoxc-[^"]*' | head -1

# xoxd (from Cookies SQLite):
python3 -c "
import sqlite3, os
db = os.path.expanduser('~/Library/Application Support/Slack/Cookies')
conn = sqlite3.connect(db)
rows = conn.execute(\"SELECT value FROM cookies WHERE name='d'\").fetchall()
print(rows[0][0] if rows else 'not found')
"
```

After extraction, always verify `SLACK_MCP_USER_AGENT` is not truncated.

### `slack-mcp-wrapper.sh`
```bash
#!/usr/bin/env bash
set -a; source "$(dirname "$0")/.env"; set +a

exec docker run -i --rm \
  -v "${HOME}/.cache/slack-mcp-server:/root/.cache/slack-mcp-server" \
  -v "$(dirname "$0")/ca-bundle.pem:/etc/ssl/certs/ca-certificates.crt:ro" \
  -e "SLACK_MCP_CACHE_TTL=24h" \
  -e "SLACK_MCP_USER_AGENT=${SLACK_MCP_USER_AGENT}" \
  -e "SLACK_MCP_XOXC_TOKEN=${SLACK_MCP_XOXC_TOKEN}" \
  -e "SLACK_MCP_XOXD_TOKEN=${SLACK_MCP_XOXD_TOKEN}" \
  -e "SLACK_MCP_ADD_MESSAGE_TOOL=true" \
  "ghcr.io/korotovsky/slack-mcp-server:v1.1.28" \
  mcp-server --transport stdio
```

If not on a corporate TLS domain, remove the `-v ca-bundle.pem` line.

### `.mcp.json` entry
```json
"slack": {
  "command": "bash",
  "args": ["/absolute/path/to/slack-mcp-wrapper.sh"]
}
```

### Opening new DM channels autonomously
The MCP has no `conversations.open` tool. Use curl directly (required for first DM only):
```bash
source .env
curl -s -X POST "https://slack.com/api/conversations.open" \
  -H "Authorization: Bearer $SLACK_MCP_XOXC_TOKEN" \
  -H "Cookie: d=$SLACK_MCP_XOXD_TOKEN" \
  -H "User-Agent: $SLACK_MCP_USER_AGENT" \
  -H "Content-Type: application/json" \
  -d '{"users": "UXXXXXXX"}' | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['channel']['id'] if d.get('ok') else d)"
```
**The User-Agent header is required** — Slack rejects without it.
Save the returned channel ID to `where/contacts.md`. All future messages use MCP, not curl.

---

## STEP 9 — INBOX MONITORING CRON

This is the 1-minute message monitor cron. Create it at session start via `CronCreate`.
Prompt prefix **must** include a human-readable name (e.g. `slack-message-monitor —`).

```bash
slack-message-monitor — Run this Bash command. If there is NO output, do absolutely
nothing — do not respond, do not say anything. Only surface output if something prints.

source /path/to/project/.env
SEEN_FILE="/tmp/slack_monitor_seen.txt"
PENDING_FILE="/tmp/slack_monitor_pending.txt"
touch "$SEEN_FILE" "$PENDING_FILE"

PENDING_OUT=$(python3 -c "
import os
pf = '/tmp/slack_monitor_pending.txt'
lines = [l.strip() for l in open(pf) if l.strip()] if os.path.exists(pf) else []
if lines:
    print('=== PENDING (unconfirmed) ===')
    for line in lines:
        parts = line.split('|||', 2)
        if len(parts) == 3:
            _, lbl, summary = parts
            print(f'  [{lbl}] {summary}')
    print('============================')
")
[ -n "$PENDING_OUT" ] && printf "%s\n" "$PENDING_OUT"

check() {
  local QUERY="$1"; local LABEL="$2"; local RESULT
  RESULT=$(curl -s "https://slack.com/api/search.messages?query=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$QUERY'))")&sort=timestamp&sort_dir=desc&count=10" \
    -H "Authorization: Bearer $SLACK_MCP_XOXC_TOKEN" \
    -H "Cookie: d=$SLACK_MCP_XOXD_TOKEN" \
    -H "User-Agent: $SLACK_MCP_USER_AGENT" | \
  python3 -c "
import sys, json, os
seen_file = '$SEEN_FILE'; pending_file = '$PENDING_FILE'; label = '$LABEL'
seen = set(open(seen_file).read().splitlines()) if os.path.exists(seen_file) else set()
d = json.load(sys.stdin)
msgs = d.get('messages', {}).get('matches', [])
new_seen = []; out = []; pending_lines = []
for m in msgs:
    msg_id = m.get('ts','')
    if msg_id and msg_id not in seen:
        u = m.get('username', m.get('user','?'))
        ch = m.get('channel', {}).get('name', '?')
        txt = m.get('text','')[:120]
        thread = ' [thread]' if m.get('ts') != m.get('thread_ts', m.get('ts')) else ''
        summary = u + ' #' + ch + thread + ': ' + txt
        out.append(summary); new_seen.append(msg_id)
        pending_lines.append(msg_id + '|||' + label + '|||' + summary)
if new_seen:
    with open(seen_file, 'a') as f: f.write('\n'.join(new_seen) + '\n')
    with open(pending_file, 'a') as f: f.write('\n'.join(pending_lines) + '\n')
print('\n'.join(out))
")
  [ -n "$RESULT" ] && printf "NEW — %s:\n%s\n" "$LABEL" "$RESULT"
}

OUT=""
OUT+=$(check "<@YOUR_SLACK_USER_ID>" "MENTION")
OUT+=$(check "<@YOUR_SLACK_USER_ID> is:thread" "MENTION (thread reply)")
OUT+=$(check "from:YOUR_MANAGER_HANDLE in:@YOUR_HANDLE" "VIP DM - Manager")
OUT+=$(check "from:YOUR_MANAGER_HANDLE is:thread" "VIP Thread - Manager")
printf "%s" "$OUT"
```

**Customize:** Replace `YOUR_SLACK_USER_ID`, `YOUR_MANAGER_HANDLE`, `YOUR_HANDLE`.
Find your user ID in Slack → Profile → ⋮ More → Copy member ID.

---

## STEP 10 — MEMORY SYNC WORKFLOW

### `sync-memory.sh`
Copies Claude's internal memory (`~/.claude/projects/<encoded>/memory/`) into the
git-tracked `memory/` directory so you can commit and version-control it.

```bash
#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$SCRIPT_DIR/memory"
ENCODED=$(ls "$HOME/.claude/projects/" | grep "$(echo "$SCRIPT_DIR" | sed 's|/|-|g' | sed 's|^-||')" 2>/dev/null | head -1)
[ -z "$ENCODED" ] && echo "ERROR: Claude project memory not found" >&2 && exit 1
SOURCE="$HOME/.claude/projects/$ENCODED/memory"
[ ! -d "$SOURCE" ] && echo "ERROR: Memory source not found: $SOURCE" >&2 && exit 1
rsync -av --delete "$SOURCE/" "$TARGET/"
echo "Sync complete."
if [[ "${1:-}" == "--commit" ]]; then
  cd "$SCRIPT_DIR"
  git add memory/
  git diff --cached --quiet || git commit -m "chore: sync memory palace snapshot"
fi
```

Run `./sync-memory.sh --commit` before pushing to capture memory changes.

---

## STEP 11 — GITHUB MCP SETUP

### Create a Personal Access Token
GitHub → Settings → Developer settings → Personal access tokens → New token
- Scopes: `repo`, `read:org`, `read:user`
- Expiry: 1 year — log the expiry in `what/service-accounts.md`

### `github-mcp-wrapper.sh`
```bash
#!/usr/bin/env bash
set -a; source "$(dirname "$0")/.env"; set +a
exec docker run -i --rm \
  -e GITHUB_PERSONAL_ACCESS_TOKEN \
  "ghcr.io/github/github-mcp-server"
```

### `.mcp.json` entry
```json
"github": {
  "command": "bash",
  "args": ["/absolute/path/to/github-mcp-wrapper.sh"]
}
```

**Cold-start fix:** If tools are missing on first session, run `docker pull ghcr.io/github/github-mcp-server` then restart.

---

## STEP 12 — CLOUD MCP CONNECTORS

Connect at `https://claude.ai/settings/connectors` — no local setup needed.
Available in Claude Code sessions and usable in remote triggers.

| Service | Gives you |
|---------|-----------|
| Atlassian | Jira tickets, Confluence pages, search |
| Gmail | Read, draft, search, send email |
| Google Calendar | Events, scheduling, free-time finder |
| Microsoft 365 | Outlook, Teams, SharePoint |
| Glean | Enterprise search across all internal tools |

---

## STEP 13 — SCHEDULED REMOTE TRIGGERS

Run Claude agents in Anthropic's cloud on a cron schedule. No local process needed.

**Constraints:**
- Minimum interval: 1 hour
- Cron expressions in UTC
- Can use cloud MCP connectors (Gmail, Atlassian, Glean), not local Docker MCPs
- Embed all needed context in the trigger prompt

**Recommended triggers:**

1. **Weekly Memory Audit** — Mondays at your preferred time
   Verifies key facts from memory against live data; emails findings report.

2. **Token/Credential Expiry Reminders** — 30 days before each known expiry
   Emails renewal steps for a specific token or service account.

3. **Daily Briefing** (optional) — weekday mornings
   Open tickets, calendar summary, team activity digest.

4. **Slack Inbox Monitor** (between sessions) — hourly at :07
   Searches Gmail for Slack notification emails (mentions, DMs); emails if found.
   Supplements the in-session 1-minute cron for when Claude Code isn't open.

To create: "Create a [name] trigger that [description] on [schedule]."
Manage all triggers: `https://claude.ai/code/scheduled`

---

## STEP 14 — PERSISTENT BEHAVIOR RULES

These should be written into `how/` memory files so they apply every session automatically:

1. **Self-healing MCP auth** — Never ask user to run `/mcp`. Re-extract → kill container → retry.
2. **Pending messages never auto-clear** — Remove only after explicit user confirmation.
3. **Channel follow-up** — After clearing a VIP channel from pending, re-check for new activity.
4. **Session crons are auto-created** — Start inbox monitoring crons at session start, every session. User never does this manually.
5. **Git commits throughout session** — Commit after each meaningful change, not just at end.
6. **No secrets in commits** — Always `git diff --cached` before committing.
7. **DMs for personal messages** — Never post to a channel for social/personal messages.
8. **New DM channels** — Open via `conversations.open` curl autonomously; save ID to contacts; use MCP for all subsequent messages.
9. **Terse responses** — Lead with action. No preamble, no trailing summaries.
10. **Memory auto-save** — Save new facts to memory proactively; never wait to be asked.

---

## STEP 15 — VERIFY SETUP

After all steps, run through this checklist:

- [ ] `.claude/settings.local.json` has `bypassPermissions` + `enableAllProjectMcpServers`
- [ ] Memory palace created with all 5 rooms + MEMORY.md + CONTENTS.md
- [ ] `who/user.md` populated with identity
- [ ] All `how/`, `fix/` files written
- [ ] `CLAUDE.md` in project root with session checklist
- [ ] `.env` populated; permissions `chmod 600 .env`
- [ ] `.gitignore` covers `.env` and `ca-bundle.pem`
- [ ] `.mcp.json` configured with chosen servers
- [ ] Wrapper scripts executable (`chmod +x *.sh`)
- [ ] `sync-memory.sh` executable and tested
- [ ] Remote triggers created (weekly audit + expiry reminders)
- [ ] Claude Code restarted to load new settings + MCPs
- [ ] Test: basic Slack/GitHub action confirms MCPs are working
- [ ] Session crons start automatically (verify with `CronList` in next session)

---

## TROUBLESHOOTING

**`invalid_auth` on Slack calls**
Tokens expired. Run self-heal: re-extract → kill container → retry.
If still failing, Slack desktop is signed out — sign back in and re-extract.

**x509 / TLS certificate error**
Mount `ca-bundle.pem` into Docker container (see fix/slack-tls.md). Regenerate after macOS updates.

**Slack desktop app signs out repeatedly (~every 20 min)**
Almost always caused by a malformed User-Agent in `.env` (embedded `"` splitting the value).
Run extraction script, verify UA is a single clean string, restart Slack MCP container.

**MCP server not loading at session start**
- Confirm `enableAllProjectMcpServers: true` in `.claude/settings.local.json`
- Confirm `.mcp.json` is in project root (not a subdirectory)
- Confirm wrapper scripts are executable: `chmod +x *.sh`
- Fully restart Claude Code (not just new chat)

**GitHub MCP tools missing**
Image not pre-pulled: `docker pull ghcr.io/github/github-mcp-server` then restart.

**`conversations.open` returns `invalid_auth`**
The User-Agent header is required for session-token Slack API calls. Ensure all three headers
(Authorization, Cookie, User-Agent) are present in the curl command.

**Remote trigger body error**
The trigger body must be a JSON object, not a string. Ask Claude to retry.

**Tool calls still require approval despite bypassPermissions**
Settings file read at startup — fully close and reopen Claude Code (not just new chat).
Verify file is at `YOUR_PROJECT_DIR/.claude/settings.local.json`.

---

*Source template: https://github.com/mmoazez-cwbg/claude_personal-test*
*Customize all placeholder values before use. Never commit this file with real credentials.*
