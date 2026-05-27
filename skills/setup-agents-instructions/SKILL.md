---
name: setup-agents-instructions
description: >-
  Set up a structured agent knowledge base with AGENTS.md as a short map,
  ARCHITECTURE.md as a domain map, and docs/CODING.md as coding guidelines.
  Follows progressive disclosure — agents start with a small entry point and
  follow pointers to deeper docs. Use when user asks to "setup agents instructions",
  "create AGENTS.md", "setup agent knowledge base", "add agent docs",
  "generate AGENTS.md", "setup agent context", or any request to create documentation
  that helps AI agents navigate and work within a codebase.
---

# Setup Agents Instructions

Generate a structured agent knowledge base for any codebase. AGENTS.md is a ~100-line map, not an encyclopedia. Agents start with the map and follow pointers to deeper docs.

## When to Use

- User asks to create AGENTS.md, agent docs, or agent context
- User wants documentation that helps AI agents navigate a codebase
- A codebase has no AGENTS.md or CLAUDE.md
- Existing agent docs are outdated or monolithic

## Process

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

Check for `pnpm-workspace.yaml`, `lerna.json`, `nx.json`, `turbo.json`, or a `workspaces` field in `package.json`. If found, list the packages/apps by reading the workspace config.

**Scripts:**

Read available scripts from `package.json` scripts, `Makefile` targets, `Taskfile.yml`, `justfile`, `Cargo.toml` aliases, or equivalent.

**Folder structure:**

List top-level directories and determine the purpose of each. Go one level deeper for `src/` or equivalent source directories.

**Code patterns (for docs/CODING.md detected section):**

- File naming convention: scan source files for kebab-case, camelCase, snake_case, or PascalCase
- Import style: relative vs. path aliases, barrel exports
- Test file location: colocated (`*.test.ts` next to source) or separate (`tests/`, `__tests__/`)
- Framework-specific patterns: component structure, routing conventions, state management

### 2. Generate docs/CODING.md

Create `docs/` directory if it doesn't exist.

Write `docs/CODING.md` with two parts:

**Part 1 — Detected Patterns** (generated from scan):

Add a `## Detected Patterns` section at the top listing codebase-specific conventions found in step 1.

**Part 2 — Coding Guidelines** (from template):

Append the content from [references/coding-guidelines.md](references/coding-guidelines.md).

If the project is not TypeScript, omit the TypeScript subsection. Substitute language-specific equivalents where possible.

### 3. Generate ARCHITECTURE.md

Write `ARCHITECTURE.md` at the project root with these sections:

- **Overview** — what the project is and what it's built with
- **Directory Structure** — top-level directories with one-line descriptions, one level deeper for source dirs
- **Entry Points** — where the app starts, where requests come in
- **Module Dependencies** — high-level dependency flow between major directories

Only include sections where content was detected. Add a **Packages** section for monorepos.

### 4. Generate AGENTS.md

Write `AGENTS.md` at the project root. Target length: 50-80 lines.

Structure:

- Callout linking to `docs/CODING.md`
- **Stack** table (language, framework, key dependencies, versions)
- **Scripts** table (command + purpose)
- **Structure** (condensed folder map)
- **Deep Docs** table linking to ARCHITECTURE.md and docs/CODING.md

### 5. Create CLAUDE.md symlink

```sh
ln -sf AGENTS.md CLAUDE.md
```

If `CLAUDE.md` already exists as a regular file, ask the user before replacing. If it's already a symlink to `AGENTS.md`, skip.

### 6. Handle existing files

If any target files already exist:

1. Read the existing content
2. Distinguish generated sections from human-written content
3. Update generated sections with fresh scan results
4. Preserve human-written sections in their original position
5. If distinction is unclear, append new sections rather than overwriting

For AGENTS.md: if sections from other tools exist (like `## Architecture` from setup-architecture-harness), leave them untouched.

### 7. Verify

Report what was generated and detected:

- Files created or updated
- Tech stack detected
- Number of scripts found
- Number of top-level directories mapped
- Detected code patterns included in CODING.md
- Sections skipped and why

## Rationalizations

| Excuse | Rebuttal |
|--------|----------|
| "Agents can figure out the codebase by reading files" | They can, but it costs tokens and time. A 50-line map saves hundreds of lines of exploratory reads per session. |
| "We already have a README" | READMEs are for humans onboarding to the project. AGENTS.md is for machines that need to know where things are and how to run them. Different audience, different content. |
| "ARCHITECTURE.md will go stale" | It goes stale slower than you think — directory structure and entry points change rarely. And a stale map is still better than no map. |
| "docs/CODING.md duplicates what's in the code" | The detected patterns section reflects what the code does today. The guidelines section says what it should do going forward. Both are useful. |
| "50-80 lines isn't enough" | That's the point. AGENTS.md is an index, not a manual. Depth lives in the linked docs. |

## Red Flags

- No `package.json`, `Cargo.toml`, `go.mod`, or equivalent found (might not be a code project)
- Scan detects conflicting patterns (e.g., both camelCase and kebab-case file naming)
- Existing AGENTS.md has content that looks hand-written and would be overwritten
- CLAUDE.md exists as a regular file with non-trivial content
- Generated AGENTS.md exceeds 100 lines (too much detail pulled into the map)

## Verification

- [ ] `AGENTS.md` exists and is under 100 lines
- [ ] `CLAUDE.md` is a symlink pointing to `AGENTS.md`
- [ ] `ARCHITECTURE.md` exists with at least Overview and Directory Structure sections
- [ ] `docs/CODING.md` exists with Detected Patterns and Coding Guidelines sections
- [ ] All links between documents resolve (no broken references)
- [ ] Existing human-written sections in any file are preserved
