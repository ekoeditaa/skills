---
name: eko:verify-implementation
description: Use when verifying implemented work. Reproduces bugs with failing tests, verifies features through browser-based user testing. All verification steps are persisted as runnable test files.
---

## Overview

Verify implemented work behaves correctly. For bugs, reproduce them with a failing test before confirming the fix. For features, verify as a user through the browser. All verification steps are persisted as test files for future regression checks.

## Boundaries

Use when:
- A build phase is complete and needs verification
- A bug has been reported and needs reproducing
- A feature needs user-perspective verification

Do not use when:
- Code hasn't been built yet — run `/build` first
- The review is purely about code style or structure — use `/review` instead

## Rationalizations

| Excuse | Rebuttal |
|--------|----------|
| "The unit tests pass, so it works" | Unit tests verify code. This verifies behaviour. A user doesn't run your test suite — they click buttons. |
| "I'll manually check it once" | Manual checks are forgotten. Write it as a test file so the next person can re-run it. |
| "The bug is obvious, I'll just fix it" | Reproduce it first. A fix without a reproduction test is a fix that can silently regress. |
| "Browser testing is overkill for this" | If users interact with it through a browser, verify it through a browser. |
| "I verified it in my head" | That's not verification. Run it. Click it. See it. |

## Process

### Bug Verification

1. **Understand the bug** — Read the bug report. Identify expected vs actual behaviour. Exit criteria: you can describe the bug without looking at the report.
2. **Write a failing test** — Write a test that reproduces the bug. The test must fail against the current code. Exit criteria: test fails for the same reason the bug occurs.
3. **Verify the fix** — Apply the code changes. Run the reproduction test. It must now pass. Exit criteria: reproduction test passes.
4. **Run full test suite** — Confirm no regressions. Exit criteria: all tests pass.
5. **Browser verification (if applicable)** — If the bug is user-facing, use Playwright MCP to reproduce the user's steps and confirm the fix. Save the steps as a test file. Exit criteria: browser test passes.

### Feature Verification

1. **Read the acceptance criteria** — Load the task's acceptance criteria from the plan. These are the behaviours to verify. Exit criteria: you have a checklist of behaviours to confirm.
2. **Run existing tests** — Confirm all tests written during `/build` still pass. Exit criteria: full suite is green.
3. **Verify as a user** — For browser-based features, use Playwright MCP to walk through the feature as a user would. Follow the happy path first, then edge cases. Exit criteria: feature works end-to-end from a user's perspective.
4. **Persist verification steps** — Save the browser verification steps as a Playwright test file so they can be re-run. Follow existing test conventions for location and naming. Exit criteria: verification is a runnable test, not a memory.
5. **Run the persisted test** — Execute the saved test to confirm it passes. Exit criteria: the persisted test is green.

## Browser Verification

Use Playwright MCP for any user-facing verification:

- Navigate to the relevant page
- Interact as a user would (click, type, navigate)
- Assert on visible outcomes (text rendered, elements present, correct state)
- Capture screenshots for visual changes if needed

Save every browser verification as a test file:

```
tests/e2e/<feature-name>.spec.ts   (or follow project conventions)
```

The test file should be runnable independently so anyone can re-verify later.

## Gotchas

- A bug fix without a reproduction test will regress. Always write the failing test first.
- Don't verify against a running dev server you haven't restarted. Stale state hides bugs.
- Browser tests that depend on specific data or timing are flaky. Use stable selectors and explicit waits.
- Verification steps that only live in your head are worthless. Persist them.
- If Playwright MCP is not available, fall back to writing detailed manual verification steps as a checklist in the test file, then automate when possible.

## Verification

- [ ] Bugs have a reproduction test that fails before the fix and passes after
- [ ] Features are verified through the browser as a user
- [ ] All browser verification steps are saved as runnable test files
- [ ] Persisted tests pass when executed
- [ ] Full test suite passes with no regressions
