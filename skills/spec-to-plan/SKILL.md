---
name: spec-to-plan
description: Use when a spec needs breaking down into an executable plan. Turns a structured spec into vertical-slice phases with sized tasks, execution waves, and verification gates ready for /build.
---

## Overview

Turn a spec from `/idea` into an executable plan ready for `/build`. The plan bridges intent and implementation — specific enough to build from, flexible enough to adapt. You are in plan mode. Do not write any code.

## Boundaries

Use when:
- A spec exists in `.eko/specs/` and needs an execution plan
- The work involves multiple steps, components, or decisions

Do not use when:
- There's no spec yet — run `/idea` first
- The task is a single, obvious change that doesn't need a plan

## Rationalizations

| Excuse | Rebuttal |
|--------|----------|
| "Let me just start coding to figure it out" | You're in plan mode. No code. Think first, build later. |
| "I can figure it out as I build" | That's how scope creep starts. Spend 10 minutes planning to save hours of rework. |
| "The spec already describes what to build" | The spec describes *what* and *why*. The plan describes *how* and *in what order*. |
| "I'll build all the API endpoints first, then the UI" | No horizontal slices. Each phase ships a complete vertical feature — API, logic, UI, tests. |
| "This task is big but I'll manage" | If it touches more than 8 files, break it down. No exceptions. |
| "Dependencies are obvious" | Write them down. What's obvious now won't be obvious mid-build. |
| "I'll verify at the end" | Verification happens at every level — task, wave checkpoint, and phase gate. Not at the end. |

## Process

1. **Enter plan mode** — You are planning, not building. Do not write, edit, or generate any code. Do not create files outside of `.eko/plans/`. Exit criteria: you are in plan mode.
2. **Read the spec** — Load the spec from `.eko/specs/`. Understand the problem, solution, scope, boundaries, and success criteria. Exit criteria: you can summarize the spec without looking at it.
3. **Explore the codebase** — Understand the existing codebase: conventions, patterns, architecture, tech stack, and current state. Identify what already exists that the plan should build on. Exit criteria: you know where new work fits and what patterns to follow.
4. **Identify the approach** — Determine the technical strategy. Consider 2-3 alternatives briefly, pick one, and document why. Exit criteria: approach is chosen with a one-line rationale for the alternatives you rejected.
5. **Define phases as vertical slices** — Each phase delivers a complete, end-to-end feature. Not "build all APIs" then "build all UI" — instead, each phase ships a working slice through the full stack (data, logic, API, UI, tests). Earlier phases should de-risk the hardest parts. Exit criteria: each phase has a clear deliverable that a user could interact with or verify independently.
6. **Break phases into tasks** — Each task follows the task template below. Size every task using T-shirt sizes. Any task sized XL or larger (more than 8 files changed) must be broken down further. Exit criteria: no task is larger than L.
7. **Map the dependency graph** — Define dependencies between phases and between tasks within phases. Flag external dependencies (APIs, access, decisions from others). Exit criteria: the graph has no cycles and no missing prerequisites.
8. **Arrange into execution waves** — Group tasks into waves that respect dependency order. Tasks within the same wave have no dependencies on each other and can run in parallel via separate agents. After every 2-3 waves, insert a verification checkpoint that confirms the work so far integrates correctly before proceeding. Exit criteria: every task is assigned to a wave, every wave's dependencies are satisfied by prior waves, and no stretch of more than 3 waves lacks a checkpoint.
9. **Define phase verification gates** — Each phase ends with a non-negotiable verification gate. The phase is not complete until every check passes. The next phase cannot begin until the gate clears.
10. **Save the plan** — Write to `.eko/plans/<name>.md` using the output format below.

## Task Template

Every task in the plan must follow this structure:

```markdown
- [ ] **<Task name>** [<Size>]
  - Summary: <one-line what this task does>
  - Description: <context, approach, and details>
  - Acceptance criteria: <specific conditions that must be true when done>
  - Verification: <how to prove the acceptance criteria are met>
  - Dependencies: <task or phase dependencies, or "none">
  - Scope: <S|M|L — files/areas affected>
```

Sizes:
- **S** — 1-2 files changed, straightforward
- **M** — 3-5 files changed, some decisions involved
- **L** — 6-8 files changed, meaningful complexity
- **XL** — More than 8 files. **Must be broken down into smaller tasks.**

## Output Format

The plan is saved to `.eko/plans/<name>.md` with this structure:

```markdown
# Plan: <Name>

Spec: `.eko/specs/<name>.md`

## Approach

What technical strategy we're using and why. Brief mention of alternatives considered.

## Codebase Context

Relevant conventions, patterns, and existing code the plan builds on.

## Phases

### Phase 1: <Name>
Depends on: none
Deliverable: [what's working end-to-end when this phase is done]

#### Execution Order

##### Wave 1 (parallel)
- [ ] **Task name** [S]
  - Summary: ...
  - Description: ...
  - Acceptance criteria: ...
  - Verification: ...
  - Dependencies: none
  - Scope: S — ...
- [ ] **Task name** [M]
  - Summary: ...
  - Description: ...
  - Acceptance criteria: ...
  - Verification: ...
  - Dependencies: none
  - Scope: M — ...

##### Wave 2 (parallel)
- [ ] **Task name** [M]
  - Summary: ...
  - Description: ...
  - Acceptance criteria: ...
  - Verification: ...
  - Dependencies: Wave 1 > Task name
  - Scope: M — ...

##### Checkpoint: Verify Wave 1-2
- [ ] [integration check]
- [ ] [specific assertion]

#### Phase Verification (gate)
- [ ] [end-to-end check proving the deliverable works]
- [ ] [all acceptance criteria from this phase's tasks are met]

> Phase 2 cannot begin until all phase verification checks pass.

### Phase 2: <Name>
Depends on: Phase 1
Deliverable: [...]

#### Execution Order
...

#### Phase Verification (gate)
...

## Dependency Graph

Summary of phase ordering and cross-phase task dependencies.

## Open Risks

What could go wrong and how we'd know early.
```

## Gotchas

- You are in plan mode. If you catch yourself writing implementation code, stop.
- Phases are vertical slices, not horizontal layers. If a phase only touches one layer (only backend, only frontend), rethink the boundaries.
- Don't plan implementation details that belong in `/build`. Tasks say *what* to do, not *how* to write the code.
- A plan with one phase is just a task list. If everything fits in one phase, question whether you need a plan at all.
- Don't gold-plate the plan. It's a guide, not a contract. It will change during `/build`.

## Verification

- [ ] No code was written during planning
- [ ] Plan references the source spec
- [ ] Codebase context section documents existing conventions
- [ ] Approach section mentions at least one alternative considered
- [ ] Every phase is a vertical slice delivering end-to-end functionality
- [ ] Every task follows the task template with all six fields
- [ ] No task is sized XL or larger
- [ ] Tasks are arranged into waves with parallel-safe grouping
- [ ] Checkpoints appear every 2-3 waves
- [ ] Every phase ends with a verification gate
- [ ] Phase and task dependencies are mapped with no cycles
- [ ] Plan is saved to `.eko/plans/<name>.md`
