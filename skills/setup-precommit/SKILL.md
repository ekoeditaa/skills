---
name: setup-precommit
description: Set up linting (oxlint), formatting (oxfmt), typechecking (tsgo), testing (vitest), and precommit hooks (husky + lint-staged) in a TypeScript project. Use when user asks to "setup linting", "add precommit hooks", "setup dev tooling", "add code quality tools", "setup husky", "configure lint-staged", "setup formatting", "setup oxlint", "configure precommit", "add git hooks", "setup code quality", or any request to configure linting, formatting, or commit hooks.
---

# Setup Dev Tools

## Stack

| Tool | Package | Purpose |
|------|---------|---------|
| oxlint | `oxlint` | Linter |
| oxfmt | `oxfmt` | Formatter |
| tsgo | `@typescript/native-preview` | Typechecker |
| vitest | `vitest` | Test runner |
| husky | `husky` | Git hooks |
| lint-staged | `lint-staged` | Run tools on staged files |

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

Use the detected package manager for all commands below. Refer to it as `<pm>`.

### 2. Check for conflicting configs

Scan the project root for:

```
.prettierrc  .prettierrc.*  prettier.config.*
.eslintrc  .eslintrc.*  eslint.config.*
biome.json  biome.jsonc
.dprint.json  dprint.json
```

If any exist, list them and ask the user: "Found existing linter/formatter configs: [list]. Proceed anyway or bail?"

Stop here if the user bails.

### 3. Detect what's already installed

Read `package.json`. Check both `devDependencies` and `dependencies` for these packages:

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

Fail-fast order: lint-staged runs first (auto-fixes staged files), then typecheck and tests gate the commit. If any step fails, the commit is blocked.

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

`oxfmt` defaults to `--write` mode — it formats files in place. `oxlint --fix` auto-fixes what it can. lint-staged handles re-staging the modified files.

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

Run a quick smoke test to confirm the setup works:

```sh
<pm> run typecheck
<pm> run lint
```

Report what was installed, what was configured, and what was skipped.
