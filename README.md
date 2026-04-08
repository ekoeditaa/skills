# Eko Skills

Engineering workflow skills for Claude Code. Each skill encodes a specific process that senior engineers follow — from shaping ideas into specs through to opening pull requests.

## Setup

Run this from inside your project directory:

```bash
curl -fsSL https://raw.githubusercontent.com/ekoeditaa/skills/master/setup.sh | bash
```

This installs:
- **Commands** (`.claude/commands/`) — `/eko-idea`, `/eko-plan`, `/eko-build`, `/eko-review`, `/eko-test`, `/eko-pr`
- **Skills** (`.claude/skills/`) — 9 reusable skill definitions invoked by commands
- **Session hook** (`hooks/`) — auto-loads the skill discovery guide on every Claude Code session start
- **Hook config** (`.claude/settings.json`) — merges the `SessionStart` hook without overwriting existing config

## Workflow

```
/eko-idea   → Shape a raw idea into a structured spec
/eko-plan   → Break the spec into phases, tasks, and execution waves
/eko-build  → Execute the plan using TDD and incremental implementation
/eko-review → Review code for design, correctness, and codebase health
/eko-test   → Verify behaviour through tests and browser-based checks
/eko-pr     → Open a pull request with structured description
```

Not every task needs every step. A bug fix might only need `/eko-build` → `/eko-test` → `/eko-pr`.

## Skills

| Command | Skill | Purpose |
|---------|-------|---------|
| `/eko-idea` | eko:idea-to-spec | Shape a raw idea into a structured spec |
| `/eko-plan` | eko:spec-to-plan | Break spec into phases, waves, and sized tasks |
| `/eko-build` | eko:plan-to-code | Execute plan phase by phase with parallel agents |
| `/eko-build` | eko:tdd | RED → GREEN → REFACTOR per task |
| `/eko-build` | eko:incremental-implementation | Thin vertical slices, test each before expanding |
| `/eko-review` | eko:code-review | Seven-dimension review with severity-based checklist |
| `/eko-test` | eko:verify-implementation | Bug reproduction and browser-based feature verification |
| `/eko-pr` | eko:open-pr | Structured PR following repository template |

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- `jq` or `python3` (for merging hook config during setup)
