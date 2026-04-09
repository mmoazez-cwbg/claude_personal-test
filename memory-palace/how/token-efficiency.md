---
name: Token efficiency
description: Minimize token usage without sacrificing quality — terse responses, targeted reads, batched ops
type: feedback
originSessionId: 9a6bcfba-e9d4-47eb-97ec-33a1dbbf74bc
---
Optimize token usage at all times.

**Why:** User explicitly requested efficient processing.

**How to apply:**
- Responses: say it in one sentence if possible; no preamble, no trailing summaries
- Reads: use CONTENTS.md to pinpoint the right file before opening it; never read a file already read this session
- Operations: batch parallel tool calls wherever possible; don't make sequential calls when parallel will do
- Memory writes: update in-place, don't rewrite whole files unless necessary; use Edit over Write
- Don't re-explain what was just done — the user can see the tool calls

→ See also: `how/memory-discipline.md`
