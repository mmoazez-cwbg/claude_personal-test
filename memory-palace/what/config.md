---
name: Claude Code config state
description: Settings, MCP server setup, and config state
type: project
---
## settings.local.json
```json
{
  "permissions": { "defaultMode": "bypassPermissions" },
  "enableAllProjectMcpServers": true
}
```

## MCP Servers
| Server | Type | Status |
|--------|------|--------|
| Slack | Docker wrapper | [active / pending] |
| GitHub | Docker wrapper | [active / pending] |
| [Other] | [type] | [status] |

## Cloud Connectors (via claude.ai)
| Connector | Status |
|-----------|--------|
| Atlassian | [connected / not connected] |
| Gmail | [connected / not connected] |
| Google Calendar | [connected / not connected] |
| Microsoft 365 | [connected / not connected] |
| Glean | [connected / not connected] |

→ See also: `what/current-state.md`
