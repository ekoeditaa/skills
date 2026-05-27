# Skill Template

Every skill in this repo lives at `skills/<skill-name>/SKILL.md` and follows this structure. Copy this skeleton when creating a new skill.

## Skeleton

```markdown
---
name: lowercase-hyphen-name
description: >-
  One-paragraph description. First sentence says what it does.
  Second sentence starts with "Use when" and lists trigger phrases.
---

# Skill Title

One-line summary of what the skill does and why it exists.

## When to Use

Conditions that should trigger this skill. List the user phrases, codebase
signals, or situations where an agent should reach for this skill.

- "setup X"
- "add Y to my project"
- Codebase has Z but lacks W

## Process

Step-by-step procedure the agent follows. Each step is a ### heading.
Steps should be concrete and mechanical — an agent should be able to
follow them without judgment calls.

### 1. Step name

What to do, what to check, what to generate. Include file paths,
commands, and expected outputs where relevant.

### 2. Next step

Continue until the skill's job is done.

### N. Verify

Final step always verifies the result: run a command, check output,
confirm files exist. Report what was done and what was skipped.

## Rationalizations

Excuses the agent (or user) might reach for to skip steps or cut corners,
paired with rebuttals that explain why the step matters.

| Excuse | Rebuttal |
|--------|----------|
| "We can add tests later" | Tests enforce the structure from day one. Drift is silent and cumulative. |
| "This project is too small for X" | Small projects become large projects. The cost of adding X now is minutes; retrofitting it later is hours. |

## Red Flags

Signs that something went wrong during execution. If the agent observes
any of these, it should stop and investigate before continuing.

- Test suite fails after generation
- Generated file conflicts with existing config
- A step produces no output when output was expected

## Verification

Evidence the agent must collect before reporting success. Each item is
a concrete check, not a vibe.

- [ ] All generated files exist at expected paths
- [ ] Commands run without errors
- [ ] Test suite passes (if applicable)
- [ ] No conflicting configs left unresolved
```

## Section Reference

| Section | Purpose | Required |
|---------|---------|----------|
| Frontmatter | Name + description for skill registry. Description starts with what it does, then "Use when..." with trigger phrases. | Yes |
| Title + summary | One-line orientation | Yes |
| When to Use | Triggering conditions so agents know when to reach for this skill | Yes |
| Process | Numbered step-by-step procedure | Yes |
| Rationalizations | Excuses + rebuttals to prevent corner-cutting | Yes |
| Red Flags | Signs something went wrong mid-execution | Yes |
| Verification | Concrete evidence of success | Yes |

## Guidelines

- Keep the frontmatter `description` under 300 characters. It gets indexed by skill registries.
- Process steps should be mechanical. If a step requires creative judgment, break it into smaller sub-steps or add decision criteria.
- Every process ends with a verify step.
- Rationalizations are for the agent's benefit — they prevent the agent from talking itself out of doing the work properly.
- Red flags are for early termination. They should describe observable symptoms, not abstract concerns.
- Verification items are checkboxes. The agent ticks them off before reporting success.
- Reference files go in `skills/<skill-name>/references/` and are linked from the process steps.
