# architecture.config.ts template

Generate this file at the project root. Substitute `{{LAYERS}}`, `{{CROSS_CUTTING}}`, and `{{STARTER_DOMAIN}}` with the user's choices.

Default values:
- layers: `["types", "config", "repo", "service", "runtime", "ui"]`
- crossCutting: `["providers"]`
- shared: `["utils"]`

```ts
export const architecture = {
  root: "src/domains",
  sharedRoot: "src/utils",

  layers: {{LAYERS}},
  crossCutting: {{CROSS_CUTTING}},
  shared: ["utils"],

  rules: {
    maxFileLines: 500,
    requireBarrelExports: true,
    fileNaming: "kebab-case" as const,
    excludeFromLineCount: [/\.d\.ts$/, /\.generated\.ts$/],
  },
} as const;

export type Layer = (typeof architecture.layers)[number];
export type CrossCutting = (typeof architecture.crossCutting)[number];
```

## How the dependency graph works

The `layers` array defines a strict ordering. A layer at index `i` may only import from layers at index `0` through `i-1`. It may never import from layers at index `i+1` or higher.

For the default config:
- `types` (index 0): cannot import from any other domain layer
- `config` (index 1): can import from `types`
- `repo` (index 2): can import from `types`, `config`
- `service` (index 3): can import from `types`, `config`, `repo`
- `runtime` (index 4): can import from `types`, `config`, `repo`, `service`
- `ui` (index 5): can import from `types`, `config`, `repo`, `service`, `runtime`

Cross-cutting layers (`providers`) can be imported by any domain layer but must not themselves import from domain layers. They exist to provide cross-cutting concerns (auth, telemetry, feature flags) via dependency injection.

Shared code (`utils`) lives outside the domain boundary and is importable by anything.
