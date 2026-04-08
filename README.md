# Eko Skills

Engineering workflow skills for Claude Code. Each skill encodes a specific process that senior engineers follow — from shaping ideas into specs through to opening pull requests.

## Setup

Run this from inside your project directory:

```bash
curl -fsSL https://raw.githubusercontent.com/ekoeditaa/skills/master/setup.sh | bash
```

This installs:
- **Commands** (`.claude/commands/`) — `/idea`, `/plan`, `/build`, `/review`, `/test`, `/pr`
- **Skills** (`skills/`) — 9 reusable skill definitions invoked by commands
- **Session hook** (`hooks/`) — auto-loads the skill discovery guide on every Claude Code session start
- **Hook config** (`.claude/settings.json`) — merges the `SessionStart` hook without overwriting existing config

## Workflow

```
/idea  → Shape a raw idea into a structured spec
/plan  → Break the spec into phases, tasks, and execution waves
/build → Execute the plan using TDD and incremental implementation
/review → Review code for design, correctness, and codebase health
/test  → Verify behaviour through tests and browser-based checks
/pr    → Open a pull request with structured description
```

Not every task needs every step. A bug fix might only need `/build` → `/test` → `/pr`.

## Skills

| Command | Skill | Purpose |
|---------|-------|---------|
| `/idea` | eko:idea-to-spec | Shape a raw idea into a structured spec |
| `/plan` | eko:spec-to-plan | Break spec into phases, waves, and sized tasks |
| `/build` | eko:plan-to-code | Execute plan phase by phase with parallel agents |
| `/build` | eko:tdd | RED → GREEN → REFACTOR per task |
| `/build` | eko:incremental-implementation | Thin vertical slices, test each before expanding |
| `/review` | eko:code-review | Seven-dimension review with severity-based checklist |
| `/test` | eko:verify-implementation | Bug reproduction and browser-based feature verification |
| `/pr` | eko:open-pr | Structured PR following repository template |

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- `jq` or `python3` (for merging hook config during setup)
