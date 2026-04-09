# Claude Code Persistent Ops Assistant — Template

A blank-slate template for setting up a **persistent, self-improving ops assistant** using [Claude Code](https://claude.ai/code). Built to be personalized — configure your own tools, persona, team, and automations.

## What you get

- **Memory palace** — structured, persistent memory across sessions (5 rooms: who, how, what, fix, where)
- **MCP integrations** — Slack, GitHub, Jira, Gmail, Google Calendar, and more
- **Scheduled triggers** — automated audits, briefings, and expiry reminders that run in the cloud
- **Behavioral rules** — token efficiency, proactive memory saving, retrieval order
- **Pre-built fixes** — Slack TLS issues, token refresh, permission setup

## Quick start

1. **Read the pre-flight instructions** in `BOOTSTRAP.md` — run the one-time terminal command to set `bypassPermissions` before opening Claude Code.
2. **Open Claude Code** in your project directory.
3. **Paste `BOOTSTRAP.md`** as your first message — Claude will interview you and build everything out.

## Repo structure

```
BOOTSTRAP.md              ← paste this into Claude Code to start setup
templates/                ← config file templates (customize after bootstrap)
  CLAUDE.md               ← project context loaded every session
  .mcp.json               ← MCP server definitions
  .env.example            ← all supported environment variables
  slack-mcp-wrapper.sh    ← Slack MCP Docker wrapper (with TLS fix)
  github-mcp-wrapper.sh   ← GitHub MCP Docker wrapper
  generic-api-mcp-wrapper.sh ← template for any REST API MCP
  start.sh                ← launcher script (loads .env, starts Claude)
memory-palace/            ← template memory files (Claude populates these)
  MEMORY.md               ← palace index (auto-loaded each session)
  CONTENTS.md             ← detailed inventory for fast fact lookup
  how/                    ← behavioral rules
  who/                    ← user identity
  what/                   ← project context and config
  fix/                    ← known issues and solutions
  where/                  ← external references and contacts
  contacts/               ← one file per person
  changelog/              ← rolling 30-day memory change log
  actionlog/              ← rolling 30-day external actions log
```

## Prerequisites

- [Claude Code](https://claude.ai/code) installed
- [Docker](https://docs.docker.com/get-docker/) (for Slack/GitHub MCPs)
- `uv` — `brew install uv` or `pip install uv` (for Python-based MCPs)

## See also

- [Claude Code docs](https://docs.anthropic.com/claude-code)
- [MCP server registry](https://github.com/topics/mcp-server)
- [Manage scheduled triggers](https://claude.ai/code/scheduled)
