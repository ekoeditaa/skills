# Agents

This repo contains reusable agent skills. Each skill lives in `skills/<skill-name>/` with a `SKILL.md` as the entry point and optional `references/` for supporting files.

## Structure

```
skills/
  <skill-name>/
    SKILL.md              # Skill definition (follows the template)
    references/           # Optional supporting files linked from SKILL.md
      some-template.md
      some-config.md
```

## Creating a Skill

Read [SKILL-TEMPLATE.md](SKILL-TEMPLATE.md) before writing any skill. Every `SKILL.md` must include all required sections from the template:

1. **Frontmatter** with `name` and `description` (description includes trigger phrases after "Use when")
2. **When to Use** section with triggering conditions
3. **Process** section with numbered steps ending in a verify step
4. **Rationalizations** table with excuses and rebuttals
5. **Red Flags** list with observable failure symptoms
6. **Verification** checklist with concrete evidence of success

## Modifying a Skill

When editing an existing skill, preserve the template structure. If a section is missing, add it. If content doesn't fit a section, the template may need updating — propose a change to `SKILL-TEMPLATE.md` rather than silently deviating.

## Conventions

- Skill names are lowercase-hyphen-case
- One skill per directory
- Process steps are mechanical and judgment-free where possible
- Reference files are for large templates, configs, or code blocks that would bloat `SKILL.md`
- Keep `SKILL.md` under 200 lines when possible — split large content into `references/`

## Existing Skills

| Skill | Purpose |
|-------|---------|
| [setup-precommit](skills/setup-precommit/SKILL.md) | Linting, formatting, typechecking, and git hooks for TypeScript projects |
| [setup-architecture-harness](skills/setup-architecture-harness/SKILL.md) | Structural tests and dependency rules for layered domain architecture |
| [setup-agents-instructions](skills/setup-agents-instructions/SKILL.md) | Agent knowledge base with AGENTS.md, ARCHITECTURE.md, and coding guidelines |
