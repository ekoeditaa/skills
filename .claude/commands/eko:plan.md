---
description: Break down a spec into an executable plan
---

Enter plan mode. Do not write any code.

MANDATORY: Load and use the `eko:spec-to-plan` skill at `.claude/skills/spec-to-plan/SKILL.md`. Do not improvise your own process — execute every step in the skill's Process section in order. Do not skip the Verification checklist.

Read the spec from `.eko/specs/` and save the plan to `.eko/plans/<name>.md`.

$ARGUMENTS

When complete, suggest the user run `/eko:build` to execute the plan.
