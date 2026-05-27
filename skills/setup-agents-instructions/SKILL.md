---
name: setup-agents-instructions
description: Set up a structured agent knowledge base with AGENTS.md as a short map, ARCHITECTURE.md as a domain map, and docs/CODING.md as coding guidelines. Follows the progressive disclosure model — agents start with a small entry point and follow pointers to deeper docs. Use when user asks to "setup agents instructions", "create AGENTS.md", "setup agent knowledge base", "add agent docs", "generate AGENTS.md", "setup agent context", or any request to create documentation that helps AI agents navigate and work within a codebase.
---

# Setup Agents Instructions

Generate a structured agent knowledge base for any codebase. AGENTS.md is a ~100-line map, not an encyclopedia. Agents start with the map and follow pointers to deeper docs.

## What gets generated

| File | Purpose |
|------|---------|
| `AGENTS.md` | Short factual map: tech stack, scripts, folder structure, pointers to deeper docs |
| `CLAUDE.md` | Symlink to `AGENTS.md` so Claude Code picks up the same map |
| `ARCHITECTURE.md` | High-level domain map: top-level directories, entry points, dependency flow |
| `docs/CODING.md` | Coding guidelines: detected patterns + opinionated best practices |

## Procedure

### 1. Scan the codebase

Detect the project type and tech stack by checking for these files (first match per category wins):

**Language / runtime:**

| File | Stack |
|------|-------|
| `package.json` | Node.js / JavaScript / TypeScript |
| `tsconfig.json` or `tsconfig.*.json` | TypeScript |
| `Cargo.toml` | Rust |
| `go.mod` | Go |
| `pyproject.toml` or `setup.py` or `requirements.txt` | Python |
| `Gemfile` | Ruby |
| `build.gradle` or `pom.xml` | Java / Kotlin |
| `Package.swift` | Swift |
| `*.csproj` or `*.sln` | .NET / C# |
| `mix.exs` | Elixir |

**Framework (check within detected language):**

For Node.js/TypeScript, check `package.json` dependencies for: `next`, `react`, `vue`, `svelte`, `angular`, `express`, `fastify`, `hono`, `nest`, `remix`, `astro`, `nuxt`.

For Python, check imports or config for: `django`, `flask`, `fastapi`, `streamlit`.

For other languages, check the standard framework indicators for that ecosystem.

**Package manager (Node.js projects):**

| Lock file | Package manager |
|-----------|----------------|
| `pnpm-lock.yaml` | pnpm |
| `bun.lockb` or `bun.lock` | bun |
| `yarn.lock` | yarn |
| `package-lock.json` | npm |

**Monorepo detection:**

Check for `pnpm-workspace.yaml`, `lerna.json`, `nx.json`, `turbo.json`, or a `workspaces` field in `package.json`. If found, list the packages/apps by reading the workspace config and scanning the workspace directories.

**Scripts:**

Read available scripts from `package.json` scripts, `Makefile` targets, `Taskfile.yml`, `justfile`, `Cargo.toml` aliases, or equivalent. Note what each script does based on its command.

**Folder structure:**

List top-level directories and determine the purpose of each by examining its contents. Go one level deeper for `src/` or equivalent source directories.

**Code patterns (for docs/CODING.md detected section):**

- File naming convention: scan source files and determine kebab-case, camelCase, snake_case, or PascalCase
- Import style: relative vs. path aliases, barrel exports
- Test file location: colocated (`*.test.ts` next to source) or separate (`tests/`, `__tests__/`)
- Framework-specific patterns: component structure, routing conventions, state management

### 2. Generate docs/CODING.md

Create `docs/` directory if it doesn't exist.

Write `docs/CODING.md` with two parts:

**Part 1 — Detected Patterns** (generated from scan):

Add a `## Detected Patterns` section at the top listing codebase-specific conventions found in step 1. Only include patterns that were actually detected. Example entries:

- File naming: kebab-case
- Imports: path aliases via `@/` prefix
- Tests: colocated as `*.test.ts` files
- Components: functional components with named exports

**Part 2 — Coding Guidelines** (from template):

Append the content from [references/coding-guidelines.md](references/coding-guidelines.md).

If the project is not TypeScript, omit the TypeScript subsection. If a different language was detected, substitute language-specific equivalents where possible (e.g., clippy lints for Rust, type hints for Python).

### 3. Generate ARCHITECTURE.md

Write `ARCHITECTURE.md` at the project root.

Structure:

```markdown
# Architecture

## Overview

One paragraph describing what the project is and what it's built with (detected stack and framework).

## Directory Structure

Top-level directories with one-line descriptions of each. Go one level deeper for source directories.

## Entry Points

List the main entry points: where the app starts, where requests come in, where the CLI dispatches. Include file paths.

## Module Dependencies

Describe the high-level dependency flow between major directories/modules. Which modules depend on which. Keep it directional — show what imports what.

## Packages (monorepo only)

If monorepo detected: list each package/app with its name, path, and one-line purpose.
```

Only include sections where content was detected. Skip the Packages section for non-monorepos. Skip Module Dependencies if the project is too small or flat to have meaningful module boundaries.

### 4. Generate AGENTS.md

Write `AGENTS.md` at the project root.

Target length: 50-80 lines. This is a map, not a manual.

Structure:

```markdown
# Agents

> Read [docs/CODING.md](docs/CODING.md) for coding guidelines before making changes.

## Stack

List detected language, framework, key dependencies, and their versions. Table format:

| Category | Technology |
|----------|------------|
| Language | TypeScript 5.x |
| Framework | Next.js 15 |
| ... | ... |

## Scripts

List available scripts and what they do. Table format:

| Command | Purpose |
|---------|---------|
| `npm run dev` | Start development server |
| `npm test` | Run test suite |
| ... | ... |

Use the detected package manager in the commands.

## Structure

Top-level folder map with one-line descriptions. Same content as ARCHITECTURE.md's directory structure but condensed to one line per directory.

## Deep Docs

| Document | What it covers |
|----------|---------------|
| [ARCHITECTURE.md](ARCHITECTURE.md) | Domain map, entry points, module dependencies |
| [docs/CODING.md](docs/CODING.md) | Code style, change discipline, testing, git conventions |
```

### 5. Create CLAUDE.md symlink

Create a symbolic link so Claude Code reads the same map:

```sh
ln -sf AGENTS.md CLAUDE.md
```

If `CLAUDE.md` already exists and is a regular file (not a symlink), ask the user before replacing it. If it already exists as a symlink pointing to `AGENTS.md`, skip this step.

### 6. Handle existing files

If any of the three files already exist:

1. Read the existing file content.
2. Identify sections that were generated by this skill (auto-detected content) vs. sections that appear to be human-written or from other tools.
3. Update auto-detected sections with fresh scan results.
4. Preserve all other sections in their original position.
5. If you cannot confidently distinguish generated vs. human content, append new sections at the end rather than overwriting.

For AGENTS.md specifically: if sections from other tools exist (like an `## Architecture` section from setup-architecture-harness), leave them untouched.

### 7. Report

Report what was generated and what was detected:

- Files created or updated
- Tech stack detected
- Number of scripts found
- Number of top-level directories mapped
- Detected code patterns included in CODING.md
- Any sections skipped and why
