---
name: setup-precommit
description: >-
  Set up linting (oxlint), formatting (oxfmt), typechecking (tsgo), testing (vitest),
  and precommit hooks (husky + lint-staged) in a TypeScript project.
  Use when user asks to "setup linting", "add precommit hooks", "setup dev tooling",
  "add code quality tools", "setup husky", "configure lint-staged", "setup formatting",
  "setup oxlint", "configure precommit", "add git hooks", "setup code quality",
  or any request to configure linting, formatting, or commit hooks.
---

# Setup Dev Tools

Install and configure linting, formatting, typechecking, testing, and precommit hooks for a TypeScript project.

## When to Use

- User asks to set up linting, formatting, or precommit hooks
- User mentions oxlint, oxfmt, tsgo, husky, or lint-staged
- User wants "dev tooling" or "code quality tools" added to a TypeScript project
- A TypeScript project has no linter/formatter/hook setup

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

Use the detected package manager for all commands below. Refer to it as `<pm>`.

### 2. Check for conflicting configs

Scan the project root for:

```
.prettierrc  .prettierrc.*  prettier.config.*
.eslintrc  .eslintrc.*  eslint.config.*
biome.json  biome.jsonc
.dprint.json  dprint.json
```

If any exist, list them and ask: "Found existing linter/formatter configs: [list]. Proceed anyway or bail?"

Stop if the user bails.

### 3. Detect what's already installed

Read `package.json`. Check both `devDependencies` and `dependencies` for:

| Check for | Package name |
|-----------|-------------|
| husky | `husky` |
| lint-staged | `lint-staged` |
| oxlint | `oxlint` |
| oxfmt | `oxfmt` |
| tsgo | `@typescript/native-preview` |
| vitest | `vitest` |

Build the list of missing packages.

### 4. Install missing packages

Skip if nothing is missing. Otherwise:

```sh
<pm> add -D <missing-packages>
```

### 5. Initialize husky

```sh
<pm> exec husky init
```

### 6. Write the pre-commit hook

Overwrite `.husky/pre-commit` with:

```sh
<pm> exec lint-staged
<pm> exec tsgo --noEmit
<pm> exec vitest run --reporter=minimal
```

Replace `<pm>` with the actual package manager. Make the file executable.

Fail-fast order: lint-staged runs first (auto-fixes staged files), then typecheck and tests gate the commit.

### 7. Configure lint-staged

Add to `package.json`:

```json
{
  "lint-staged": {
    "*.{ts,tsx,mts,cts}": [
      "oxfmt",
      "oxlint --fix"
    ]
  }
}
```

`oxfmt` defaults to `--write` mode. `oxlint --fix` auto-fixes what it can. lint-staged handles re-staging.

### 8. Add npm scripts

Add each script to `package.json` only if it doesn't already exist. Note which ones were skipped.

```json
{
  "scripts": {
    "lint": "oxlint .",
    "format": "oxfmt .",
    "typecheck": "tsgo --noEmit",
    "test": "vitest run --reporter=minimal"
  }
}
```

### 9. Verify

Run a smoke test:

```sh
<pm> run typecheck
<pm> run lint
```

Report what was installed, configured, and skipped.

## Rationalizations

| Excuse | Rebuttal |
|--------|----------|
| "We already have ESLint/Prettier" | oxlint is 50-100x faster. Conflicting configs were flagged in step 2 — the user chose to proceed. |
| "Precommit hooks slow down commits" | A 2-second lint gate is cheaper than a 20-minute CI round-trip for a formatting fix. |
| "We'll add hooks later" | Later never comes. Every commit between now and then ships without guardrails. |
| "tsgo is experimental" | It's a typecheck-only pass. It catches the same errors as tsc, faster. If it breaks, remove it from the hook — don't skip the setup. |

## Red Flags

- `husky init` fails (no `.git` directory, or git hooks path is non-standard)
- `package.json` doesn't exist (not a Node.js project)
- Conflicting configs exist and user chose to proceed but tools error on conflicting rules
- `typecheck` or `lint` fails on existing code (pre-existing issues, not caused by this skill)

## Verification

- [ ] All six packages are in `devDependencies`
- [ ] `.husky/pre-commit` exists and is executable
- [ ] `lint-staged` config is in `package.json`
- [ ] `lint`, `format`, `typecheck`, and `test` scripts exist in `package.json`
- [ ] `<pm> run typecheck` exits cleanly
- [ ] `<pm> run lint` exits cleanly
