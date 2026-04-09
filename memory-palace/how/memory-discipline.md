---
name: Auto-commit to memory
description: Proactively save relevant changes, rules, and context to memory without waiting to be asked
type: feedback
---
Automatically save to memory whenever something worth remembering happens — don't wait for the user to ask.

**Why:** Having to ask Claude to remember things is friction. The assistant should be self-maintaining.

## Retrieval order — always follow before calling external tools
1. `MEMORY.md` — quick routes and room index
2. `CONTENTS.md` — key data points per file; find the fact without opening every file
3. Specific file — open only what CONTENTS.md points to
4. External tool — only if memory has no answer

## Memory palace structure
5 rooms under `~/.claude/projects/<encoded-project-path>/memory/`:

| Room | Path | Contents |
|------|------|----------|
| WHO | `who/` | People, identity, user profile |
| HOW | `how/` | Rules, behaviors, preferences |
| WHAT | `what/` | Project context, current state, config |
| FIX | `fix/` | Known issues and solutions |
| WHERE | `where/` | External references, IDs, pointers |
| LOGS | `changelog/` + `actionlog/` | Audit trails (30-day rolling) |

## How to apply
- New contact info → write/update `contacts/<name>.md` AND `where/contacts.md` AND `CONTENTS.md`
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

→ See also: `how/weekly-audit.md`, `how/token-efficiency.md`
