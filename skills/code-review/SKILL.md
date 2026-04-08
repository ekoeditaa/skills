---
name: eko:code-review
description: Use when reviewing code changes. Evaluates design, functionality, complexity, tests, naming, and style to improve long-term codebase health. Produces actionable findings with severity levels.
---

## Overview

Review code changes to improve the long-term health of the codebase. Not perfection — continuous improvement. Every finding is weighed against whether it raises or lowers the baseline health of the codebase.

## Boundaries

Use when:
- A build or test phase is complete and code needs reviewing
- Preparing code for a pull request
- Reviewing someone else's changes

Do not use when:
- Verifying behaviour or running tests — use `/test` instead
- The code hasn't been written yet

## Rationalizations

| Excuse | Rebuttal |
|--------|----------|
| "The tests pass, so the code is fine" | Tests verify behaviour. Review verifies design, complexity, and maintainability. Different concerns. |
| "It's a small change, no review needed" | Small changes cause big outages. A one-line auth bypass is a small change. Code health is cumulative — small declines compound. |
| "That's just my personal preference" | If the style guide covers it, it's not preference — it's the standard. If it doesn't, defer to the author. |
| "We can fix it later" | Later is never. Each change either raises or lowers the baseline. |
| "The author knows what they're doing" | Everyone misses things. The review is for the code, not a judgement of the author. |
| "I'll just approve it, the design issue is minor" | Start with design. If the foundation is wrong, line-by-line detail is wasted effort. |

## Process

1. **Load the diff** — Read the changes (staged, unstaged, or between branches as specified). Understand what changed and why. Exit criteria: you know the scope and intent of every change.

2. **Check the change is focused** — *Is this one logical change?*
   - Does the diff mix unrelated concerns (a bug fix and a reformat, a feature and a refactor)?
   - Could this be split into smaller, independently reviewable changes?
   - Is every file in the diff necessary for this change?
   - Exit criteria: the change does one thing, or you've flagged that it doesn't.

3. **Review design** — *Does this change belong here, and does it fit the system?*
   - Do the interacting pieces make sense together?
   - Does this belong in the codebase, or in a library?
   - Does it integrate cleanly with existing architecture and patterns?
   - Is now the right time to add this functionality?
   - Is there an existing mechanism this should use instead of introducing a new one?
   - Exit criteria: design is sound, or a design concern is raised before proceeding further.

4. **Review functionality** — *Does the code actually do what it claims to do?*
   - What happens with empty, null, or unexpected input?
   - Are there race conditions or concurrency risks?
   - What happens when external dependencies fail (network, database, third-party APIs)?
   - Are error paths handled, not just the happy path?
   - Could any state mutation leave the system in an inconsistent state?
   - Exit criteria: every code path is accounted for.

5. **Review complexity** — *Is this the simplest solution that meets the requirement?*
   - Could a junior developer understand this without explanation?
   - Are there abstractions that only have one implementation?
   - Is any code solving a future problem that doesn't exist yet?
   - Could any of this be replaced by a standard library or existing utility?
   - Is the indirection (layers, wrappers, factories) earning its keep?
   - Exit criteria: you can't simplify the code further without losing clarity.

6. **Review tests** — *Do the tests prove the code works, or just that it runs?*
   - Are tests present in the same change as the production code?
   - Do tests verify actual outputs and side effects, or just that functions were called?
   - Are edge cases and error paths tested, not just the happy path?
   - Would these tests catch a regression if someone changed the implementation?
   - Are tests independent from each other (no shared mutable state)?
   - Exit criteria: tests verify actual behaviour.

7. **Review naming and comments** — *Could a new team member understand this without asking the author?*
   - Are variable, function, and class names specific and unambiguous?
   - Do any names mislead about what the code does?
   - Do comments explain *why*, not just restate *what* the code does?
   - Are there magic numbers or strings that should be named constants?
   - Exit criteria: code communicates its intent through names and targeted comments.

8. **Review style and documentation** — *Is the change consistent with how the rest of the codebase looks and is documented?*
   - Does it follow the established style guide?
   - Are new public APIs, configuration options, or behaviours documented?
   - If the change modifies existing behaviour, is documentation updated to match?
   - Are imports, file structure, and error handling consistent with project conventions?
   - Exit criteria: change is consistent with project conventions and docs are current.

9. **Review code health** — *Did this change leave the codebase cleaner than it found it?*
   - Is there dead code introduced or left behind by this change (unused imports, unreachable branches, commented-out code)?
   - Are there orphaned functions, variables, or files that nothing references anymore?
   - Did a refactor leave behind the old implementation alongside the new one?
   - Are there TODOs or temporary workarounds that should be resolved now, not later?
   - Could any copy-pasted code be consolidated without premature abstraction?
   - Are there leftover debug statements (console.log, print, debugger)?
   - Exit criteria: the change leaves no dead weight behind.

10. **Review every line** — Go through every line of human-written code in the change. Exit criteria: no line was skipped.

11. **Produce review** — Output findings using the severity levels and format below.

12. **Persist review** — Save the review report to `.eko/reviews/<scope-slug>.md`. Exit criteria: the report file exists and contains the full review output.

## Decision Principles

Apply these when deciding whether to flag something:

- **Improve, don't perfect** — a change that improves maintainability, readability, or understandability should not be blocked because it isn't ideal.
- **Technical facts over opinion** — design decisions should be weighed on engineering principles, not personal preference.
- **Defer to the author** when multiple approaches are equally valid and they can demonstrate this with data or reasoning.
- **Style guide is authoritative** — anything not covered by the style guide is personal preference and is not a blocker.
- **Avoid speculative scope** — reject functionality added for future use cases that aren't yet real requirements.
- **Code health is cumulative** — small declines compound. Each change either raises or lowers the baseline.

## Severity Levels

- **CRITICAL** — Must fix. Blocks merge. Security vulnerabilities, data loss, broken functionality, fundamental design flaws.
- **IMPORTANT** — Should fix. Blocks merge. Bugs, missing error handling, race conditions, inadequate tests, speculative complexity.
- **SUGGESTION** — Consider fixing. Does not block merge. Alternative approaches, minor simplifications, documentation gaps.
- **NIT** — Take it or leave it. Does not block merge. Style preferences, naming alternatives, minor readability tweaks.

Only findings marked CRITICAL or IMPORTANT block merge. Only report findings you're confident about. False positives erode trust.

## Review Output Format

```markdown
## Code Review: <scope>

### Summary
<1-2 sentence overview of the changes and overall assessment>

### Review Checklist

#### Architecture & Design
- [ ] **[CRITICAL|IMPORTANT|SUGGESTION|NIT]** <filename>:<line> — <description>
  Why: <technical rationale>
  Suggestion: <concrete fix or direction>

#### Functionality
- [ ] **[IMPORTANT]** <filename>:<line> — <description>
  Why: <technical rationale>
  Suggestion: <concrete fix or direction>

#### Complexity
- [ ] **[SUGGESTION]** <filename>:<line> — <description>
  Why: <technical rationale>
  Suggestion: <concrete fix or direction>

#### Tests
- [ ] **[IMPORTANT]** <filename>:<line> — <description>
  Why: <technical rationale>
  Suggestion: <concrete fix or direction>

#### Naming & Comments
- [ ] **[NIT]** <filename>:<line> — <description>
  Why: <technical rationale>
  Suggestion: <concrete fix or direction>

#### Style & Documentation
- [ ] **[NIT]** <filename>:<line> — <description>
  Why: <technical rationale>
  Suggestion: <concrete fix or direction>

#### Code Health
- [ ] **[SUGGESTION]** <filename>:<line> — <description>
  Why: <technical rationale>
  Suggestion: <concrete fix or direction>

### Merge Status
<BLOCKED | CLEAR>
Blockers: <count of CRITICAL + IMPORTANT findings, or "none">

### Verdict
<APPROVE | REQUEST CHANGES | NEEDS DISCUSSION>
<one-line rationale>
```

Omit any category that has no findings. Only include categories where issues were found.

**APPROVE** when no CRITICAL or IMPORTANT findings remain — even if suggestions and nits exist.
**REQUEST CHANGES** when CRITICAL or IMPORTANT findings block the merge.
**NEEDS DISCUSSION** when design decisions require a conversation before proceeding.

## Gotchas

- Start with design. If the foundation is wrong, don't waste time on line-by-line review.
- Don't rewrite the author's code in your review. Describe the problem and suggest a direction.
- A review with zero findings is valid. "Looks good" is a legitimate outcome.
- Don't nitpick style when the project has no style guide. Focus on correctness and design.
- Review the diff, not the whole file — unless the change interacts with surrounding code.
- A custom in-memory cache when Redis is already configured is a design issue, not a style issue. Catch the big things.

## Verification

- [ ] Change focus was assessed (one logical change per review)
- [ ] Design was reviewed before line-by-line detail
- [ ] All seven dimensions checked (design, functionality, complexity, tests, naming, style, code health)
- [ ] Every line of human-written code was reviewed
- [ ] Findings have severity levels and technical rationale
- [ ] No false positives — every finding can be defended with facts, not preference
- [ ] Verdict is provided with rationale
- [ ] Review report is saved to `.eko/reviews/<scope-slug>.md`
