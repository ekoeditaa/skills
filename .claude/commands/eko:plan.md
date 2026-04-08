---
description: Break down a spec into an executable plan
---

Enter plan mode. Do not write any code.

Read the spec from `.eko/specs/` and follow the process defined in the `eko:spec-to-plan` skill to turn it into an actionable plan.

Read the skill file before starting:
- `.claude/skills/spec-to-plan/SKILL.md`

MANDATORY: Execute every step in the skill's Process section in order. Do not skip the Verification checklist.

Save the plan to `.eko/plans/<name>.md`.

$ARGUMENTS

When complete, suggest the user run `/eko:build` to execute the plan.
