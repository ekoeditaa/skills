---
name: eko:open-pr
description: Use when work is ready to be submitted as a pull request. Analyzes changes, generates structured PR description following the repository's PR template, and opens the PR via gh CLI.
---

## Overview

Package completed work into a well-structured pull request. Analyze all changes since branching, generate a description that tells reviewers what changed and why, link back to specs and plans, and open the PR via `gh`.

## Boundaries

Use when:
- Build, review, and test phases are complete
- Changes are committed and ready for merge

Do not use when:
- Tests are failing — run `/test` first
- Review has unresolved blockers — run `/review` first
- Changes aren't committed yet — run `/build` first

## Rationalizations

| Excuse | Rebuttal |
|--------|----------|
| "The code speaks for itself" | Code shows what changed. The PR description explains why. Reviewers need both. |
| "I'll write the description later" | You have full context now. In an hour you won't. Write it now. |
| "It's a small change, no description needed" | Small changes with no context get the most questions. A two-line summary saves a round trip. |
| "I'll just merge it, no one reviews anyway" | The PR is the historical record. Future you will want to know why this change was made. |
| "The spec covers everything" | Link the spec, but summarize. Reviewers shouldn't need to read three documents to understand a PR. |
| "The repo doesn't have a PR template, so anything goes" | Use the fallback structure. Consistent PRs are reviewable PRs. |

## Process

1. **Verify readiness** — Confirm all tests pass, build is clean, and no uncommitted changes remain. Exit criteria: working tree is clean, tests green, build green.
2. **Analyze changes** — Read the full diff from the base branch. Read all commits since branching. Understand what they collectively deliver. Exit criteria: you can explain the change in 2-3 sentences.
3. **Identify the base branch** — Determine the correct target branch (main, develop, or as specified). Exit criteria: base branch is confirmed.
4. **Load the PR template** — Look for a pull request template in the repository. Check these locations in order:
   - `.github/PULL_REQUEST_TEMPLATE.md`
   - `.github/pull_request_template.md`
   - `PULL_REQUEST_TEMPLATE.md`
   - `pull_request_template.md`
   - `.github/PULL_REQUEST_TEMPLATE/` directory (if multiple templates exist, use the default)
   If a template is found, use it as the structure for the PR body. Fill in every section the template defines. If no template is found, use the fallback structure below. Exit criteria: you have a structure to fill in.
5. **Write the PR title** — Short, imperative, under 70 characters. Describes the outcome, not the process. Exit criteria: title would make sense in a changelog.
6. **Write the PR body** — Fill in the template (or fallback structure). Link to specs, plans, and any relevant issues. Exit criteria: a reviewer can understand the what, why, and how without reading the code first.
7. **Push and open the PR** — Push the branch with `-u`, open the PR via `gh pr create`. Exit criteria: PR is open and URL is returned.

## Fallback PR Structure

Use this only when the repository has no PR template:

```markdown
## Summary
<2-3 sentences: what this PR does and why>

## Spec
<link to .eko/specs/<name>.md, or "N/A">

## Plan
<link to .eko/plans/<name>.md, or "N/A">

## Changes
<bulleted list of what changed, grouped logically>

## How to Test
<steps a reviewer can follow to verify the change works>
```

## Gotchas

- Always check for a PR template first. Don't skip it because you have a fallback.
- Don't list every file changed. Group changes by what they achieve, not where they live.
- The "How to Test" section (or its equivalent in the template) should be copy-pasteable. A reviewer should be able to verify without asking you anything.
- If the PR is large, question whether it should be split. A PR that changes 30+ files is hard to review well.
- Don't open a PR with failing CI. Fix it first, even if you think it's a flaky test.
- Link specs and plans even if the reviewer won't read them. They're the audit trail.

## Verification

- [ ] All tests pass and build is clean before opening
- [ ] PR template was loaded from the repository (or fallback used if none exists)
- [ ] PR title is under 70 characters and describes the outcome
- [ ] PR body fills in every section of the template
- [ ] Specs and plans are linked where applicable
- [ ] PR is opened via `gh pr create` and URL is returned
