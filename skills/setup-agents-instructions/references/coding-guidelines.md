# docs/CODING.md template

This is the fixed/opinionated portion of `docs/CODING.md`. The skill prepends a detected section at the top with codebase-specific patterns before writing this content.

---

```markdown
# Coding Guidelines

## Code Style

### Naming and Structure

- Match existing patterns in the codebase. When in doubt, grep for similar code and follow its conventions.
- Use self-documenting names. If a function needs a comment to explain what it does, rename it.
- Keep files focused. One module, one responsibility.

### TypeScript

- Use strict TypeScript. No `any`, no `as` casts unless provably safe, no `@ts-ignore`.
- Prefer what helps the compiler help you: discriminated unions over type guards, `satisfies` over assertions, `readonly` where mutation isn't needed.

### Comments

- Default to no comments. Only add one when the WHY is non-obvious: a hidden constraint, a workaround for a specific bug, behavior that would surprise a reader.
- Never explain WHAT the code does — well-named identifiers already do that.
- Never reference the current task, ticket, or caller in comments. Those belong in the commit message.

### Dead Code

- No TODOs, no placeholder functions, no commented-out code.
- If something is unused, delete it. We look forward, not backward.

## Change Discipline

### Scope

- Do exactly what was asked. No drive-by refactors, no bonus features, no speculative abstractions.
- Reuse existing code. If something is written thrice, refactor it into a common function.
- A bug fix doesn't need surrounding cleanup. A one-shot operation doesn't need a helper function.

### Vertical Slices

- Work incrementally in vertical slices. Each slice should be complete and verifiable by automated or manual tests.
- Commit each slice as a separate commit with a clear message describing what it delivers.

### Error Handling

- Only validate at system boundaries: user input, external APIs, network responses.
- Trust internal code and framework guarantees. Don't add defensive checks for scenarios that can't happen.
- No feature flags or backwards-compatibility shims when you can just change the code.

## Testing

- Aim for 100% unit test coverage on changed files.
- Run the existing test suite before and after making changes.
- Write tests for new behavior. Fix tests you break.
- Type checking and test suites verify code correctness, not feature correctness. For UI changes, verify in a browser.
- Don't mock what you can test directly. Prefer integration tests over unit tests with heavy mocking.

## Security

- Never introduce command injection, XSS, SQL injection, or other OWASP top 10 vulnerabilities.
- Don't commit secrets, credentials, or environment-specific values.
- If you notice insecure code while working nearby, fix it.

## Git

- Use conventional commits: `feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`.
- Write commit messages that explain WHY, not WHAT. The diff already shows what changed.
- Keep commits focused. One logical change per commit.
- Don't amend published commits. Create new commits instead.
```

## Notes for generating this file

- The skill prepends a `## Detected Patterns` section at the top of this template with codebase-specific conventions found during scanning (naming conventions, import style, test file locations, framework-specific patterns).
- If the project is not TypeScript, omit the TypeScript subsection and replace it with language-specific equivalents if detectable.
- Keep the file self-contained. An agent reading only this file should know how to write code in this project.
