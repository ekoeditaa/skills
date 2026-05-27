# AGENTS.md architecture section template

Append this section to `AGENTS.md`. Create the file if it doesn't exist. If an `## Architecture` section already exists, replace it.

Substitute `{{LAYERS}}` with the actual layer list from the config, `{{CROSS_CUTTING}}` with cross-cutting layers, and `{{DOMAINS_ROOT}}` with the root path.

---

```markdown
## Architecture

This codebase uses a layered domain architecture with mechanically enforced boundaries.

### Source of truth

All architectural rules are defined in `architecture.config.ts` at the project root. Read this file before making structural changes.

### Layer model

Code lives in `{{DOMAINS_ROOT}}/<domain-name>/`. Each domain is divided into layers with a strict dependency direction:

{{LAYERS_ARROW_DIAGRAM}}

Each layer can only import from layers to its left. Importing from a layer to the right is a build-breaking violation.

Cross-cutting layers ({{CROSS_CUTTING}}) can be imported by any domain layer but must never import from domain layers. They provide shared concerns like auth, telemetry, and feature flags via dependency injection.

Shared utilities live in `src/utils/` and are importable by anything.

### Rules enforced by `test:arch`

1. **Dependency direction**: no backward imports across layers within a domain.
2. **Boundary discipline**: cross-domain imports must go through the layer's `index.ts` barrel. No deep imports into another domain's internal files.
3. **No circular dependencies**: domains must not form import cycles.
4. **Kebab-case filenames**: all `.ts`/`.tsx` files must be kebab-case.
5. **Max 500 lines per file**: split large files into focused modules within the same layer.
6. **Barrel exports**: every layer folder must have an `index.ts`.

### How to fix common violations

**Backward import** (e.g. `types/` importing from `service/`):
Move the shared code to the lower layer, or restructure to remove the dependency.

**Deep cross-domain import** (e.g. importing `domains/auth/service/internal-helper.ts`):
Export the needed symbol from `domains/auth/service/index.ts`, then import from there.

**Circular dependency between domains**:
Extract shared code into a new domain or into `src/utils/`.

**File too long**:
Split into smaller, focused modules within the same layer.

### Adding a new domain

Create a folder under `{{DOMAINS_ROOT}}/` with kebab-case naming. Add layer subfolders matching the configured layers, each with an `index.ts` barrel.

### Adding a new layer

Update `architecture.config.ts` first. The position in the `layers` array determines its allowed dependencies. Then create the folder in each domain that needs it.
```

## Notes for generating this section

- `{{LAYERS_ARROW_DIAGRAM}}` should be rendered as the layers joined with ` → `, e.g.: `types → config → repo → service → runtime → ui`
- Keep the section self-contained. An agent reading only this section should understand all the rules and how to work within them.
- Do not reference the skill itself — the section should make sense to any agent, not just one running this skill.
