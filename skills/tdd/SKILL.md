---
name: eko:tdd
description: Use when implementing any task during /build. Write failing tests first (RED), then implement minimum code to pass (GREEN). Enforces test-driven development discipline.
---

## Overview

Write tests before code. Every task starts with a failing test that describes the expected behaviour, then gets the minimum implementation to make it pass, then cleans up without changing behaviour. This is the RED-GREEN-REFACTOR cycle — the foundation of the `/build` phase.

## Boundaries

Use when:
- Implementing any task from a plan
- Adding new behaviour to existing code
- Fixing a bug (write a test that reproduces it first)

Do not use when:
- The task is pure configuration with no testable behaviour
- Writing documentation or non-code artifacts

## Rationalizations

| Excuse | Rebuttal |
|--------|----------|
| "I'll write the tests after" | Then you're testing your implementation, not your requirements. Tests written after confirm what you built, not what you should have built. |
| "This is too simple to test" | Simple things break too. A one-line test takes 30 seconds and catches regressions forever. |
| "I need to see the implementation shape first" | The test IS the shape. It defines the interface, the inputs, and the expected outputs. Write that first. |
| "The test framework isn't set up" | Setting up tests is part of the task. If there's no test infrastructure, that's your first RED. |
| "I can't test this without the implementation" | You can always test the interface. Mock what doesn't exist yet. The test defines the contract. |
| "These are just types/interfaces, nothing to test" | Correct — skip TDD for pure type definitions. But if there's logic, test it. |
| "The code works, no need to refactor" | GREEN means it works. REFACTOR means it's clean. Both matter. Don't skip the cleanup. |
| "I'll refactor later" | Later never comes. Refactor while the code is fresh and tests are green. It takes 2 minutes now, 20 minutes next week. |

## Process

### RED: Write Failing Tests

1. **Read the task** — Understand the acceptance criteria and verification method from the task template. These are your test cases. Exit criteria: you know exactly what behaviour to test.
2. **Choose the test location** — Follow existing test conventions in the codebase. If none exist, co-locate tests next to the code they test. Exit criteria: you know where the test file goes.
3. **Write the tests** — Write tests that describe the expected behaviour. Test the public interface, not internals. Each test should be independent and test one thing. Exit criteria: tests are written and they fail (because the implementation doesn't exist yet).
4. **Confirm RED** — Run the tests. They must fail. If they pass, either the behaviour already exists (no task needed) or your tests aren't testing the right thing. Exit criteria: tests fail for the right reason (missing implementation, not syntax errors).

### GREEN: Implement Minimum Code

5. **Write the minimum implementation** — Use the `incremental-implementation` skill. Write only enough code to make the failing tests pass. No extra features, no premature optimization, no "while I'm here" improvements. Exit criteria: all new tests pass.
6. **Run full test suite** — Run all tests, not just the new ones. Catch regressions immediately. Exit criteria: full suite passes.
7. **Run build** — Verify compilation, type checking, linting. Exit criteria: build is clean.

### REFACTOR: Clean Up While Green

8. **Refactor the implementation** — Now that tests pass, clean up the code. Remove duplication, improve naming, simplify logic, extract functions if warranted. Do not change behaviour — only structure. Exit criteria: code is clean and you'd be comfortable handing it to a reviewer.
9. **Confirm still GREEN** — Run full test suite and build again. Refactoring must not break anything. If tests fail, your refactor changed behaviour — undo and try again. Exit criteria: full suite passes, build is clean.

### COMMIT

10. **Commit** — Commit with a conventional commit message that describes what was built and why. Exit criteria: clean commit with passing tests and build.

## Test Writing Guidelines

### What to Test

- Expected behaviour from acceptance criteria
- Edge cases (empty inputs, boundaries, nulls)
- Error cases (invalid inputs, failures, timeouts)
- Integration points (does this piece connect correctly to its dependencies?)

### What NOT to Test

- Implementation details (private methods, internal state)
- Third-party library behaviour
- Exact error message strings (test the error type/code instead)
- Things that can't break (pure type definitions, constants)

### Test Structure

Each test follows Arrange-Act-Assert:

```
Arrange: set up the preconditions
Act:     perform the action being tested
Assert:  verify the expected outcome
```

One assertion per test. If you need multiple asserts, you likely need multiple tests.

## Gotchas

- If you can't write a test for a task, the acceptance criteria are too vague. Go back and clarify before implementing.
- Flaky tests are worse than no tests. If a test passes sometimes and fails sometimes, fix it immediately.
- Don't mock what you don't own unless you also have an integration test. Mocks drift from reality.
- Tests that test implementation details break on every refactor and catch no real bugs. Test behaviour.
- GREEN means minimum code. Fight the urge to add "nice to haves" that no test demands.

## Verification

- [ ] Tests were written before implementation
- [ ] Tests failed before implementation (confirmed RED)
- [ ] Implementation is the minimum to pass tests (GREEN)
- [ ] Code was refactored for clarity without changing behaviour (REFACTOR)
- [ ] Full test suite still passes after refactor
- [ ] Build is clean (compilation, types, linting)
- [ ] Committed with conventional commit message
