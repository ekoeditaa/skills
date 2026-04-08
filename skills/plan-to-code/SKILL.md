---
name: eko:plan-to-code
description: Use when a plan is ready to be built. Execute a plan phase by phase, spawning parallel agents per wave, using TDD and incremental implementation for each task.
---

## Overview

Execute a plan from `/plan` by building it phase by phase, wave by wave. Each task follows the TDD cycle (RED → GREEN → commit) using the `tdd` and `incremental-implementation` skills. Verification happens at every level — task, wave checkpoint, and phase gate.

## Boundaries

Use when:
- A plan exists in `.eko/plans/` and is ready to build
- You've confirmed which phase to start from (default: first incomplete phase)

Do not use when:
- There's no plan yet — run `/plan` first
- The plan has unresolved open risks or missing dependencies

## Rationalizations

| Excuse | Rebuttal |
|--------|----------|
| "I'll skip the checkpoint, the code looks fine" | Checkpoints exist because "looks fine" isn't verification. Run the checks. |
| "I'll fix the failing verification later" | A failing gate means the phase isn't done. Fix it now before moving on. |
| "I'll do these parallel tasks sequentially, it's easier" | Waves are designed for parallelism. Spawn the agents. That's the point. |
| "This task changed scope, I'll just keep going" | If a task outgrew its estimate, stop and re-plan. Update the plan file before continuing. |
| "I'll refactor this while I'm here" | Build what the plan says. Improvements go into `/review`. |
| "The plan is wrong, I'll improvise" | If the plan is wrong, update the plan first. Don't build from a stale map. |
| "I'll write tests after the implementation" | No. Use the `tdd` skill. RED before GREEN. Always. |

## Process

1. **Load the plan** — Read the plan from `.eko/plans/`. Identify the current phase (first incomplete phase, or as specified). Exit criteria: you know which phase, wave, and tasks to start with.
2. **Verify prerequisites** — Check that all dependencies for the current phase are satisfied. If a prior phase gate hasn't passed, stop and complete it first. Exit criteria: all upstream phase gates are green.
3. **Execute wave by wave** — For each wave in the current phase, spawn parallel agents for all tasks in the wave. Each agent executes its task using the TDD flow below. Wait for all agents in the wave to complete before moving to the next wave. Exit criteria: all tasks in the wave are done and individually verified.
4. **Run wave checkpoints** — After every 2-3 waves (as defined in the plan), run the checkpoint verification. If any check fails, stop and fix before continuing. Exit criteria: checkpoint passes.
5. **Run phase verification gate** — When all waves in the phase are complete, run every check in the phase verification gate. The phase is not done until all checks pass. Exit criteria: gate clears.
6. **Update the plan** — Mark completed tasks and phases in `.eko/plans/<name>.md`. Note any deviations, scope changes, or new risks discovered during building. Exit criteria: plan file reflects current state.
7. **Proceed or stop** — If more phases remain, return to step 2 for the next phase. If all phases are complete, the build is done.

## TDD Flow Per Task

Each task follows this cycle using the `tdd` and `incremental-implementation` skills:

```
1. Pick up next available task
2. Load relevant context (plan, codebase, dependencies)
3. RED   — Write failing tests for expected behaviour (tdd skill)
4. GREEN — Implement minimum code to pass tests (incremental-implementation skill)
5. Run full test suite for regressions
6. Run build to verify compilation
7. Commit with conventional commit and descriptive message
8. Mark task complete, move to next available task
```

## Agent Task Brief

When spawning an agent for a task, provide:

```
Task: <task name>
Summary: <from task template>
Description: <from task template>
Acceptance criteria: <from task template>
Verification: <from task template>
Scope: <from task template>

Codebase context: <from plan's codebase context section>

Instructions:
- Use the `tdd` skill: write failing tests first (RED), then implement (GREEN)
- Use the `incremental-implementation` skill: build in thin vertical slices
- Follow existing codebase conventions
- Only touch files within this task's scope
- Run full test suite and build before committing
- Commit with conventional commit message
- Do not refactor or improve code outside the task
```

## Handling Deviations

- **Task is smaller than estimated** — Complete it, note the actual scope, move on.
- **Task is larger than estimated** — Stop. Break it down in the plan file. Resume with the sub-tasks.
- **Task is blocked** — Document the blocker in the plan. Skip to the next unblocked task or wave. Flag it for resolution.
- **Plan is wrong** — Update the plan file first, then continue building from the updated plan.

## Gotchas

- Don't start a phase until its gate prerequisites are met.
- Parallel agents must not touch the same files. If two tasks in a wave share files, they shouldn't be in the same wave — fix the plan.
- Keep the plan file updated as you go. It's the source of truth.
- Build what the plan says. Save improvements for `/review`.
- Every task goes through RED → GREEN → commit. No exceptions.

## Verification

- [ ] Plan was loaded and current phase identified
- [ ] All upstream phase gates were verified before starting
- [ ] Every task followed the TDD flow (RED → GREEN → commit)
- [ ] Tasks were executed in wave order with parallel agents
- [ ] Wave checkpoints passed before proceeding
- [ ] Phase verification gate passed before moving to next phase
- [ ] Plan file is updated with completion status and any deviations
