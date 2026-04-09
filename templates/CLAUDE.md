# CLAUDE.md — [Project Name]

## Environment
- Timezone: [your timezone, e.g. America/New_York]
- Env file: .env contains all credentials
- [Tool workspace URL, e.g. yourcompany.atlassian.net]
- [Any other tool-specific base URLs or workspace IDs]

## Key Rules
<!-- List 3-5 non-negotiable rules Claude must follow for your workflows -->
- Always [action] before [other action] (e.g. "Always add a customer comment before closing a ticket")
- Never [action] without [condition]
- When [event] occurs, [response]

## Reference Data
<!-- Static lookup tables Claude needs — field IDs, category names, region codes, etc. -->
| Item | Value |
|------|-------|
| [field name] | [value] |

## Session Start Checklist
At the start of each session, proactively:
1. Check memory/where/contacts.md for any team updates
2. Flag if today is within 30 days of any known credential/token expiry
3. [Any other time-sensitive checks relevant to your work]

## Key Resource IDs
<!-- Channel IDs, workspace IDs, queue IDs — anything Claude needs to reference by ID -->
| Resource | ID |
|----------|----|
| [e.g. #general Slack channel] | [ID] |
