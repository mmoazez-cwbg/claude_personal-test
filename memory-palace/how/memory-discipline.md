---
name: Auto-commit to memory
description: Proactively save relevant changes, rules, and context to memory without waiting to be asked
type: feedback
originSessionId: 9a6bcfba-e9d4-47eb-97ec-33a1dbbf74bc
---
Automatically save to memory whenever something worth remembering happens — don't wait for the user to ask.

**Why:** The user explicitly requested this. Having to ask Claude to remember things is friction they don't want.

## Retrieval order — always follow before calling external tools
1. `MEMORY.md` — quick routes and room index
2. `CONTENTS.md` — key data points per file; find the fact without opening every file
3. Specific file — open only what CONTENTS.md points to
4. External tool — only if memory has no answer

## Memory palace structure
5 rooms under `/Users/mikem/.claude/projects/<encoded-project-path>/memory/`:

| Room | Path | Contents |
|------|------|----------|
| WHO | `who/` | People, identity, user profile |
| HOW | `how/` | Rules, behaviors, preferences |
| WHAT | `what/` | Project context, current state, config |
| FIX | `fix/` | Known issues and solutions |
| WHERE | `where/` | External references, IDs, pointers |
| LOGS | `changelog/` + `actionlog/` | Audit trails (30-day rolling) |

## How to apply
- New contact info → write/update `contacts/<name>.md` AND `where/slack-contacts.md` AND `CONTENTS.md`
- New rules or preferences → `how/*.md`
- New project context → `what/*.md`
- New external resource pointers → `where/*.md`
- Known issues or fixes → `fix/*.md`
- Config changes → `what/config.md`
- Every memory/config change → log to `changelog/YYYY-MM-DD.md` as it happens
- Every external action (Slack DM, Jira, calendar, search) → log to `actionlog/YYYY-MM-DD.md` as it happens
- Always update `MEMORY.md` and `CONTENTS.md` when adding a new memory file
- Add `→ See also:` cross-references at the bottom of each file
- Don't duplicate — check existing files first, update in place
- Save mid-conversation, not at the end — never wait to be asked

→ See also: `who/mike.md`, `how/weekly-audit.md`
