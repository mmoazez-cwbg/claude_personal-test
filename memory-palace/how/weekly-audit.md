---
name: Weekly memory audit
description: Weekly self-maintenance process to keep the memory palace clean, accurate, and fast
type: feedback
originSessionId: 9a6bcfba-e9d4-47eb-97ec-33a1dbbf74bc
---
Run a weekly audit to prevent memory rot. Goal: common questions answered in ≤2 reads.

**Checklist:**
1. Verify MEMORY.md index matches actual files on disk — fix broken links, missing entries
2. Verify CONTENTS.md data points match current file contents — update stale facts
3. Prune stale data — passed dates, resolved incidents, outdated config
4. Consolidate small files if it makes sense
5. Changelog/actionlog cleanup — delete entries older than 30 days
6. Retrieval test — pick 5 common query types, confirm each resolves in ≤2 reads

**Why:** Memory drifts over time without maintenance. Stale entries cause wrong answers; bloated files slow retrieval.

**How to apply:**
- When auditing flags uncertain items, use available tools (Slack, Jira, etc.) to verify before asking the user — do the legwork first
- If a fact can't be verified and may be stale, remove it rather than leave it as noise

→ See also: `how/memory-discipline.md`, `CONTENTS.md`
