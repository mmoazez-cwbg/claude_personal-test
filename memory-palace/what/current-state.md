---
name: Current ops state
description: Live MCP health, known issues, restart checklist
type: project
---
## MCP Health
- Slack: [working / issues]
- GitHub: [working / issues]
- [Other MCPs]: [status]

## Known Issues
<!-- Document active problems here -->

## Restart Checklist
If something isn't working:
1. Check `.env` credentials are populated
2. Confirm Docker is running (for Slack/GitHub MCPs)
3. Run `/mcp` in Claude Code to restart MCP servers
4. If Slack shows `invalid_auth`: re-extract tokens, update `.env`, restart

→ See also: `what/config.md`, `fix/`
