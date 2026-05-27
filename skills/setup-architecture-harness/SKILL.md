---
name: setup-architecture-harness
description: Set up mechanical enforcement of layered domain architecture via vitest structural tests and dependency-cruiser. Generates architecture config, scaffolds domain folder structure, creates architecture test suite, and adds agent instructions to AGENTS.md. Use when user asks to "setup architecture tests", "enforce architecture", "add architectural constraints", "setup dependency rules", "add architecture harness", "enforce layer boundaries", "setup structural tests", or any request to mechanically enforce codebase architecture conventions.
---

# Setup Architecture Harness

Mechanically enforce layered domain architecture via structural tests. Agents ship fast; the harness prevents drift.

## What gets generated

| File | Purpose |
|------|---------|
| `architecture.config.ts` | Source of truth for layers, dependency edges, style rules |
| `src/domains/<starter>/` | Scaffolded domain with layer folders and barrel exports |
| `src/utils/index.ts` | Shared utilities barrel |
| `tests/architecture.test.ts` | Vitest tests that enforce all rules |
| `AGENTS.md` | Agent-facing instructions about the architecture |

## Procedure

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
- "Do you want the default layer model (types → config → repo → service → runtime → ui) with providers as cross-cutting, or do you want to customize the layers?"

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

1. **Dependency direction** — no backward imports across layers. Each layer can only import from layers earlier in the configured order. Cross-cutting layers can be imported by any layer but must not import domain layers. Shared (`utils`) is importable by anything.
2. **Boundary discipline** — imports from another domain's layer must go through its `index.ts` barrel. No deep imports into internal files.
3. **No circular dependencies** — between domains.
4. **Kebab-case file naming** — all `.ts`/`.tsx` files must use kebab-case.
5. **Max file length** — 500 lines per file. Excludes `.d.ts` and other generated files. Does not exclude test files.
6. **Barrel exports required** — every layer folder must have an `index.ts`.

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
