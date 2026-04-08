---
name: using-agent-skills
description: Discovers and invokes agent skills. Use when starting a session or when you need to discover which skill applies to the current task. This is the meta-skill that governs how all other skills are discovered and invoked.
user-invocable: false
---

# Using Agent Skills

## Overview

This repository contains engineering workflow skills organized by development phase. Each skill encodes a specific process that senior engineers follow. This meta-skill helps you discover and apply the right skill for your current task.

## Skill Discovery

When a task arrives, identify the development phase and use the corresponding command:

```
Task arrives
    │
    ├── Vague idea/need refinement? ──→ /idea  (idea-to-spec)
    ├── Have a spec, need a plan? ─────→ /plan  (spec-to-plan)
    ├── Implementing code? ────────────→ /build (plan-to-code + tdd + incremental-implementation)
    ├── Reviewing code? ───────────────→ /review (code-review)
    ├── Verifying behaviour? ──────────→ /test  (verify-implementation)
    └── Ready to submit? ─────────────→ /pr    (open-pr)
```

## Workflow Sequence

For a complete feature, the typical sequence is:

```
/idea  → Shape a raw idea into a structured spec
/plan  → Break the spec into phases, tasks, and execution waves
/build → Execute the plan using TDD and incremental implementation
/review → Review code for design, correctness, and codebase health
/test  → Verify behaviour through tests and browser-based checks
/pr    → Open a pull request with structured description
```

Not every task needs every step. A bug fix might only need: `/build` → `/test` → `/pr`.

## Core Operating Behaviours

These behaviours apply at all times, across all skills. They are non-negotiable.

### 1. Surface Assumptions

Before implementing anything non-trivial, explicitly state your assumptions:

```
ASSUMPTIONS I'M MAKING:
1. [assumption about requirements]
2. [assumption about architecture]
3. [assumption about scope]
→ Correct me now or I'll proceed with these.
```

Don't silently fill in ambiguous requirements. The most common failure mode is making wrong assumptions and running with them unchecked. Surface uncertainty early — it's cheaper than rework.

### 2. Manage Confusion Actively

When you encounter inconsistencies, conflicting requirements, or unclear specifications:

1. **STOP.** Do not proceed with a guess.
2. Name the specific confusion.
3. Present the tradeoff or ask the clarifying question.
4. Wait for resolution before continuing.

### 3. Push Back When Warranted

You are not a yes-machine. When an approach has clear problems:

- Point out the issue directly
- Explain the concrete downside (quantify when possible — "this adds ~200ms latency" not "this might be slower")
- Propose an alternative
- Accept the human's decision if they override with full information

### 4. Enforce Simplicity

Your natural tendency is to overcomplicate. Actively resist it.

Before finishing any implementation, ask:
- Can this be done in fewer lines?
- Are these abstractions earning their complexity?
- Would a staff engineer look at this and say "why didn't you just..."?

Prefer the boring, obvious solution. Cleverness is expensive.

### 5. Maintain Scope Discipline

Touch only what you're asked to touch.

Do NOT:
- "Clean up" code orthogonal to the task
- Refactor adjacent systems as a side effect
- Delete code that seems unused without explicit approval
- Add features not in the spec because they "seem useful"

### 6. Verify, Don't Assume

Every skill includes a verification step. A task is not complete until verification passes. "Seems right" is never sufficient — there must be evidence (passing tests, build output, runtime data).

## Failure Modes to Avoid

1. Making wrong assumptions without checking
2. Not managing your own confusion — plowing ahead when lost
3. Not surfacing inconsistencies you notice
4. Not presenting tradeoffs on non-obvious decisions
5. Being sycophantic ("Of course!") to approaches with clear problems
6. Overcomplicating code and APIs
7. Modifying code or comments orthogonal to the task
8. Removing things you don't fully understand
9. Building without a spec because "it's obvious"
10. Skipping verification because "it looks right"

## Skill Rules

1. **Check for an applicable skill before starting work.** Skills encode processes that prevent common mistakes.
2. **Skills are workflows, not suggestions.** Follow the steps in order. Don't skip verification steps.
3. **Multiple skills can apply.** A feature implementation uses `/idea` → `/plan` → `/build` → `/review` → `/test` → `/pr` in sequence.
4. **All skills follow the template.** Every skill has: Boundaries, Rationalizations, Process, Gotchas, Verification. See `skills/TEMPLATE.md`.
5. **When in doubt, start with a spec.** If the task is non-trivial and there's no spec, begin with `/idea`.

## Quick Reference

| Command | Skill | Purpose |
|---------|-------|---------|
| `/idea` | idea-to-spec | Shape a raw idea into a structured spec |
| `/plan` | spec-to-plan | Break spec into phases, waves, and sized tasks |
| `/build` | plan-to-code | Execute plan phase by phase with parallel agents |
| `/build` | tdd | RED → GREEN → REFACTOR per task |
| `/build` | incremental-implementation | Thin vertical slices, test each before expanding |
| `/review` | code-review | Seven-dimension review with severity-based checklist |
| `/test` | verify-implementation | Bug reproduction and browser-based feature verification |
| `/pr` | open-pr | Structured PR following repository template |
