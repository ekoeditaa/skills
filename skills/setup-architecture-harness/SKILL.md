---
name: setup-architecture-harness
description: >-
  Set up mechanical enforcement of layered domain architecture via vitest structural
  tests and dependency-cruiser. Generates architecture config, scaffolds domain folder
  structure, creates architecture test suite, and adds agent instructions to AGENTS.md.
  Use when user asks to "setup architecture tests", "enforce architecture",
  "add architectural constraints", "setup dependency rules", "add architecture harness",
  "enforce layer boundaries", "setup structural tests", or any request to mechanically
  enforce codebase architecture conventions.
---

# Setup Architecture Harness

Mechanically enforce layered domain architecture via structural tests. Agents ship fast; the harness prevents drift.

## When to Use

- User asks to enforce architecture, add structural tests, or set up dependency rules
- User mentions layer boundaries, domain architecture, or dependency direction
- A codebase needs guardrails against architectural drift
- An existing domain structure lacks automated enforcement

## Process

### 1. Detect package manager

Check lock files in project root, first match wins:

| Lock file | Package manager |
|-----------|----------------|
| `pnpm-lock.yaml` | pnpm |
| `bun.lockb` or `bun.lock` | bun |
| `yarn.lock` | yarn |
| `package-lock.json` | npm |
| none | pnpm |

### 2. Ask the user for project details

Before generating anything, ask:

- "What should the starter domain be called?" (e.g. `user-management`, `app-settings`)
- "Do you want the default layer model (types -> config -> repo -> service -> runtime -> ui) with providers as cross-cutting, or do you want to customize the layers?"

If they want custom layers, ask for the ordered list and which are cross-cutting.

### 3. Install dependency-cruiser

Check `package.json` for `dependency-cruiser` in devDependencies. Install if missing:

```sh
<pm> add -D dependency-cruiser
```

### 4. Generate architecture.config.ts

Write `architecture.config.ts` at project root. See [references/architecture-config.md](references/architecture-config.md) for the template. Substitute the user's layer model and starter domain name.

### 5. Scaffold folder structure

Create the directory tree only for folders that don't already exist. Every layer folder gets an `index.ts` barrel with an empty export.

```
src/
  domains/
    <starter-domain>/
      types/index.ts
      config/index.ts
      repo/index.ts
      service/index.ts
      runtime/index.ts
      ui/index.ts
      providers/index.ts
  utils/
    index.ts
```

Each `index.ts` contains:

```ts
export {};
```

Skip any folder or file that already exists.

### 6. Generate architecture test suite

Write `tests/architecture.test.ts`. See [references/architecture-tests.md](references/architecture-tests.md) for the full template.

The test suite enforces:

1. **Dependency direction** — no backward imports across layers
2. **Boundary discipline** — cross-domain imports go through barrel exports only
3. **No circular dependencies** — between domains
4. **Kebab-case file naming** — all `.ts`/`.tsx` files
5. **Max file length** — 500 lines per file (excludes `.d.ts`)
6. **Barrel exports required** — every layer folder must have an `index.ts`

Every test failure prints a prescriptive error message: what file violated, what rule, and how to fix it.

### 7. Add test:arch script

Add to `package.json` scripts (skip if already exists):

```json
{
  "test:arch": "vitest run tests/architecture.test.ts --reporter=minimal"
}
```

### 8. Update AGENTS.md

Append an architecture section to `AGENTS.md` (create the file if it doesn't exist). See [references/agents-section.md](references/agents-section.md) for the template. Substitute the actual layer model from the config.

If `AGENTS.md` already has an `## Architecture` section, replace it rather than duplicating.

### 9. Verify

Run the architecture tests:

```sh
<pm> run test:arch
```

All tests should pass on the freshly scaffolded structure. If any fail, fix the issue before reporting success.

Report what was generated, what was skipped, and the test results.

## Rationalizations

| Excuse | Rebuttal |
|--------|----------|
| "We can add architecture tests later" | Drift starts on the first commit without guardrails. Retrofitting rules onto a tangled codebase takes days; setting them up on a clean structure takes minutes. |
| "This project is too small for layers" | Small projects grow. The cost of scaffolding layers now is trivial; untangling circular dependencies later is not. |
| "Dependency-cruiser is overkill" | It runs in CI in under a second. The alternative is code review catching import violations by eye, which it won't. |
| "We'll just follow conventions" | Conventions without enforcement are suggestions. Agents and new contributors don't read wikis — they read error messages. |
| "500-line file limit is arbitrary" | It's a pressure valve. Files that hit it get split, which improves readability and testability. The number is less important than having a number. |

## Red Flags

- `dependency-cruiser` install fails (network issue or incompatible Node version)
- Architecture tests fail on the freshly scaffolded structure (template bug or misconfigured layers)
- `architecture.config.ts` has duplicate layer names
- An existing `tests/architecture.test.ts` gets overwritten without the user being asked
- `AGENTS.md` has conflicting architecture sections from a previous run

## Verification

- [ ] `architecture.config.ts` exists at project root
- [ ] `src/domains/<starter>/` has all layer folders with barrel exports
- [ ] `tests/architecture.test.ts` exists
- [ ] `test:arch` script exists in `package.json`
- [ ] `<pm> run test:arch` passes with all tests green
- [ ] `AGENTS.md` has an `## Architecture` section with the correct layer model
