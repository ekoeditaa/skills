Personal agent skills repository.

Workflow: `/idea` -> `/plan` -> `/build` -> `/review` -> `/fix` -> `/test` -> `/pr`

- Commands live in `.claude/commands/` as workflow entrypoints.
- Skills live in `skills/<skill-name>/SKILL.md` as reusable capabilities invoked by commands.
- All skills must follow the anatomy defined in `skills/TEMPLATE.md` (Boundaries, Rationalizations, Process, Gotchas, Verification).
