---
description: Execute a plan by building each phase using test-driven development
---

Read the plan from `.eko/plans/` then invoke these skills:

1. Invoke `eko:plan-to-code` to execute phase by phase, wave by wave
2. For each task, invoke `eko:tdd`: RED (write failing tests) → GREEN (minimum implementation) → REFACTOR → commit
3. For each task, invoke `eko:incremental-implementation`: thin vertical slices, test each before expanding

$ARGUMENTS

When complete, suggest the user run `/eko:review` to review the code.
