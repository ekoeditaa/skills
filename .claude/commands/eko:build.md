---
description: Execute a plan by building each phase using test-driven development
---

Read the plan from `.eko/plans/` and follow the process defined in these skills:

1. `eko:plan-to-code` — Follow its Process section to execute phase by phase, wave by wave
2. For each task, follow the `eko:tdd` process: RED (write failing tests) → GREEN (minimum implementation) → REFACTOR → commit
3. For each task, follow the `eko:incremental-implementation` process: thin vertical slices, test each before expanding

Read each skill file before starting:
- `.claude/skills/plan-to-code/SKILL.md`
- `.claude/skills/tdd/SKILL.md`
- `.claude/skills/incremental-implementation/SKILL.md`

MANDATORY: Execute every step in each skill's Process section in order. Do not skip the Verification checklists.

$ARGUMENTS

When complete, suggest the user run `/eko:review` to review the code.
