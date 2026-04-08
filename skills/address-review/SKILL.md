---
name: eko:address-review
description: Use when a code review has been completed and findings need to be fixed. Reads the persisted review report, fixes merge-blocking findings (CRITICAL and IMPORTANT), and cleans up the report file.
---

## Overview

Fix merge-blocking issues identified by a code review. Read the review report, apply fixes for CRITICAL and IMPORTANT findings, skip suggestions and nits, then clean up.

## Boundaries

Use when:
- A review report exists in `.eko/reviews/` with CRITICAL or IMPORTANT findings
- The review verdict is REQUEST CHANGES

Do not use when:
- No review report exists — run `/review` first
- The review verdict is APPROVE — there are no blockers to fix
- The review verdict is NEEDS DISCUSSION — resolve the design conversation before fixing code

## Rationalizations

| Excuse | Rebuttal |
|--------|----------|
| "I'll fix the suggestions and nits too while I'm at it" | Scope creep. The author decides on suggestions and nits. Fix blockers, nothing more. |
| "The review suggestion is wrong, I'll skip this finding" | If a CRITICAL or IMPORTANT finding is genuinely wrong, flag it to the user — don't silently skip it. |
| "I'll refactor the surrounding code to make the fix cleaner" | Fix the finding, not the neighbourhood. Refactoring beyond the finding's scope introduces new review surface. |
| "The fix is obvious, I don't need to read the context" | Line numbers shift. Code around the finding may have changed. Always read the current file state before editing. |
| "I'll batch all the fixes and verify at the end" | Verify each fix individually. A later fix can break an earlier one if they touch the same code. |

## Process

1. **Load the review report** — Read the latest report from `.eko/reviews/`. If multiple reports exist, use the one matching the user's argument or the most recent. Exit criteria: you have the full review report in context.

2. **Parse findings by severity** — Extract all findings and group them: CRITICAL, IMPORTANT, SUGGESTION, NIT. Count the blockers (CRITICAL + IMPORTANT). Exit criteria: you have a clear list of blockers to fix and non-blockers to skip.

3. **Triage blockers** — Order the blockers: CRITICAL before IMPORTANT. Within the same severity, order by file — group findings in the same file together to avoid re-reading. If fixing one finding would change the context of another (same function, overlapping lines), fix the earlier one first. Exit criteria: you have an ordered fix list.

4. **Fix each blocker** — For each finding in order:
   a. Read the file at the referenced location. Understand the surrounding code, not just the flagged line.
   b. Apply the fix following the review's suggestion direction. The suggestion describes *what* to fix — use your judgement on *how*.
   c. Verify the fix addresses the finding without introducing new issues. If the fix changes behaviour, confirm existing tests still pass.
   d. Move to the next finding.
   Exit criteria: every CRITICAL and IMPORTANT finding has been addressed.

5. **Commit** — Commit all fixes with a conventional commit message that describes what review findings were addressed. Exit criteria: clean commit with all fixes staged, tests passing, build clean.

6. **Clean up** — Delete the review report from `.eko/reviews/`. Exit criteria: the report file no longer exists.

7. **Report** — Summarize:
   - How many blockers were fixed (with one-line description of each fix)
   - How many suggestions/nits were skipped (list them so the author can decide)
   Exit criteria: the user knows what changed and what was left untouched.

## Gotchas

- Line numbers in the review report refer to the state of the code when the review was run. If code has changed since, find the correct location by matching the code pattern, not the line number.
- A finding's suggestion is a direction, not a prescription. The fix should address the underlying issue, which may differ from the literal suggestion.
- If a fix requires changes outside the scope of the finding (e.g., updating a caller when a function signature changes), make those changes too — but only the minimum necessary.
- If a CRITICAL or IMPORTANT finding cannot be fixed without a design decision, stop and ask the user rather than guessing.

## Verification

- [ ] Review report was read from `.eko/reviews/`
- [ ] Only CRITICAL and IMPORTANT findings were fixed
- [ ] SUGGESTION and NIT findings were reported but not modified
- [ ] Each fix was verified individually
- [ ] All fixes committed with conventional commit message, tests passing, build clean
- [ ] No uncommitted changes remain (`git status` is clean)
- [ ] Review report was deleted from `.eko/reviews/` after fixes
- [ ] Summary of fixes and skipped findings was provided
