---
name: idea-to-spec
description: Use when turning a vague idea into something concrete. Shape a raw idea into a structured spec with clear problem, solution, scope, and next steps.
---

## Overview

Turn a raw idea into a structured, researched spec ready for `/plan`. The spec is the source of truth between you and the human engineer — it defines what we're building, why, and how we'll know it's done.

## Boundaries

Use when:
- A raw idea needs shaping into something actionable
- Requirements are fuzzy and need structuring
- Starting a brand new project or a large feature

Do not use when:
- The idea is already a well-defined spec with clear requirements
- The request is a bug fix or incremental change to existing work

## Rationalizations

| Excuse | Rebuttal |
|--------|----------|
| "The problem is obvious from the solution" | Restate it anyway. A spec that only describes the solution will drift from the actual need. |
| "I'll fill in the open questions later" | Open questions are the most valuable part. If you have none, you haven't thought hard enough. |
| "The scope is obvious" | Explicit scope prevents creep. Write down what's out, not just what's in. |
| "This idea is too small for a spec" | Small ideas grow. A lightweight spec takes 5 minutes and saves hours of rework. |

## Process

1. **Interview the user** — Ask questions to understand the idea fully. Dig into the why, who it's for, what success looks like, and what prompted the idea. Don't assume you understand — keep asking until the picture is clear. Use frameworks from [reference.md](reference.md) to guide your questioning (JTBD, CIRCLES, Lean Canvas, etc.) — pick the one that fits, don't force all of them. Exit criteria: you can explain the idea back to the user and they agree you've got it.
2. **Identify the core problem** — Separate the problem from the proposed solution. The user often describes a solution — your job is to find the underlying need. Exit criteria: you can state the problem in one sentence without mentioning implementation.
3. **Research (if needed)** — If the problem space involves unfamiliar domains, external tools, or existing solutions worth knowing about, do web research. Skip this if the idea is well-understood and self-contained. Exit criteria: you either have useful references or a clear reason research isn't needed.
4. **Shape the spec** — Structure the idea into a clear problem/solution framing. Exit criteria: problem and solution sections are written.
5. **Define the boundaries** — Determine what's in scope for a first pass and what's explicitly out. Exit criteria: scope section has both inclusions and exclusions.
6. **Surface unknowns** — List genuine open questions that block moving to `/plan`. Exit criteria: each question is specific enough that an answer would unblock a decision.
7. **Write next steps** — Concrete actions to hand off to `/plan`. Exit criteria: each step is actionable by someone with no context beyond this spec.
8. **Save the spec** — Write to `.eko/specs/<slugified-name>.md` using the structure below.

## Spec Structure

```markdown
# <Idea Name>

## Problem
What pain point or gap does this address?

## Proposed Solution
High-level approach. What does this look like when it works?

## Prior Art
Existing solutions, competitors, and relevant references. Include links. Omit this section if no research was done.

## Scope
What's in and what's out for a first pass.

## Boundaries
- Always: [...]
- Ask first: [...]
- Never: [...]

## Success Criteria
[How we'll know this is done — specific, testable conditions]

## Open Questions
Unknowns that need answering before moving to /plan.

## Next Steps
Concrete actions to take this into /plan.
```

## Gotchas

- If research is done, links must be real. Never fabricate URLs.
- Keep it to one page. A spec that takes longer to read than the idea took to explain has failed.
- "Proposed Solution" is a direction, not a design. Save implementation details for `/plan`.
- Focus on understanding what the user actually wants, not what you think they should want.

## Verification

- [ ] Problem statement exists and contains no implementation details
- [ ] Scope explicitly lists what's out, not just what's in
- [ ] Open questions are specific and non-trivial
- [ ] Next steps are actionable without context beyond this spec
- [ ] Spec is saved to `.eko/specs/<name>.md`
