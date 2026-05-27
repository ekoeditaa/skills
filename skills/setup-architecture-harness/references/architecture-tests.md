# tests/architecture.test.ts template

Generate this file at `tests/architecture.test.ts`. The test reads `architecture.config.ts` to get all rules — no hardcoded values in the test file itself.

```ts
import { describe, it, expect } from "vitest";
import { cruise } from "dependency-cruiser";
import { architecture } from "../architecture.config";
import { readFileSync, readdirSync, statSync, existsSync } from "fs";
import { join, relative, sep, extname, basename } from "path";

function getAllFiles(dir: string, ext: string[] = [".ts", ".tsx"]): string[] {
  const results: string[] = [];
  if (!existsSync(dir)) return results;

  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const fullPath = join(dir, entry.name);
    if (entry.isDirectory()) {
      results.push(...getAllFiles(fullPath, ext));
    } else if (ext.includes(extname(entry.name))) {
      results.push(fullPath);
    }
  }
  return results;
}

function countLines(filePath: string): number {
  return readFileSync(filePath, "utf-8").split("\n").length;
}

function isKebabCase(name: string): boolean {
  const stem = name.replace(/\.(test|spec)/, "").replace(/\.[^.]+$/, "");
  return /^[a-z][a-z0-9]*(-[a-z0-9]+)*$/.test(stem);
}

function isExcludedFromLineCount(filePath: string): boolean {
  return architecture.rules.excludeFromLineCount.some((pattern) =>
    pattern.test(filePath)
  );
}

function getLayerIndex(layer: string): number {
  return architecture.layers.indexOf(layer as any);
}

function parseImportLayer(
  importPath: string,
  sourceFile: string
): { domain: string; layer: string } | null {
  const rel = relative(process.cwd(), importPath).split(sep);
  const rootParts = architecture.root.split("/");

  const rootIdx = rel.findIndex(
    (part, i) =>
      i + rootParts.length <= rel.length &&
      rel.slice(i, i + rootParts.length).join("/") === architecture.root
  );
  if (rootIdx === -1) return null;

  const afterRoot = rel.slice(rootIdx + rootParts.length);
  if (afterRoot.length < 2) return null;

  const domain = afterRoot[0];
  const layer = afterRoot[1];
  return { domain, layer };
}

function getFileDomainAndLayer(
  filePath: string
): { domain: string; layer: string } | null {
  const rel = relative(process.cwd(), filePath).split(sep);
  const rootParts = architecture.root.split("/");

  const rootIdx = rel.findIndex(
    (part, i) =>
      i + rootParts.length <= rel.length &&
      rel.slice(i, i + rootParts.length).join("/") === architecture.root
  );
  if (rootIdx === -1) return null;

  const afterRoot = rel.slice(rootIdx + rootParts.length);
  if (afterRoot.length < 2) return null;

  return { domain: afterRoot[0], layer: afterRoot[1] };
}

function getDomainFolders(): string[] {
  const domainsPath = join(process.cwd(), architecture.root);
  if (!existsSync(domainsPath)) return [];
  return readdirSync(domainsPath, { withFileTypes: true })
    .filter((d) => d.isDirectory())
    .map((d) => d.name);
}

describe("architecture", () => {
  const allDomainLayers = [
    ...architecture.layers,
    ...architecture.crossCutting,
  ];

  describe("dependency direction", () => {
    it("domain layers only import from earlier layers", async () => {
      const result = await cruise([architecture.root], {
        doNotFollow: { path: "node_modules" },
      });
      const violations: string[] = [];

      if (result.output && typeof result.output !== "string") {
        for (const mod of result.output.modules) {
          const source = getFileDomainAndLayer(mod.source);
          if (!source) continue;

          const sourceIdx = getLayerIndex(source.layer);
          if (sourceIdx === -1) continue;

          for (const dep of mod.dependencies) {
            const target = parseImportLayer(dep.resolved, mod.source);
            if (!target) continue;
            if (target.domain !== source.domain) continue;

            const isCrossCutting = (architecture.crossCutting as readonly string[]).includes(target.layer);
            if (isCrossCutting) continue;

            const targetIdx = getLayerIndex(target.layer);
            if (targetIdx === -1) continue;

            if (targetIdx >= sourceIdx) {
              violations.push(
                `VIOLATION: ${mod.source} (${source.layer}) imports from ${dep.resolved} (${target.layer}).\n` +
                `  Rule: "${source.layer}" (index ${sourceIdx}) can only import from layers with index < ${sourceIdx}.\n` +
                `  Allowed imports: [${architecture.layers.slice(0, sourceIdx).join(", ")}].\n` +
                `  Fix: Move the shared code to a lower layer, or restructure to remove this dependency.`
              );
            }
          }
        }
      }

      expect(violations, violations.join("\n\n")).toEqual([]);
    });

    it("cross-cutting layers do not import from domain layers", async () => {
      const crossCuttingPaths = architecture.crossCutting.map((cc) =>
        join(architecture.root, "**", cc)
      );
      if (crossCuttingPaths.length === 0) return;

      const result = await cruise([architecture.root], {
        doNotFollow: { path: "node_modules" },
      });
      const violations: string[] = [];

      if (result.output && typeof result.output !== "string") {
        for (const mod of result.output.modules) {
          const source = getFileDomainAndLayer(mod.source);
          if (!source) continue;
          if (!(architecture.crossCutting as readonly string[]).includes(source.layer)) continue;

          for (const dep of mod.dependencies) {
            const target = parseImportLayer(dep.resolved, mod.source);
            if (!target) continue;

            const targetIsDomainLayer = (architecture.layers as readonly string[]).includes(target.layer);
            if (targetIsDomainLayer) {
              violations.push(
                `VIOLATION: ${mod.source} (cross-cutting: ${source.layer}) imports from ${dep.resolved} (domain layer: ${target.layer}).\n` +
                `  Rule: Cross-cutting layers must not import from domain layers.\n` +
                `  Fix: Inject the dependency via a port/interface instead of importing directly.`
              );
            }
          }
        }
      }

      expect(violations, violations.join("\n\n")).toEqual([]);
    });
  });

  describe("boundary discipline", () => {
    it("cross-domain imports go through barrel exports only", async () => {
      const result = await cruise([architecture.root], {
        doNotFollow: { path: "node_modules" },
      });
      const violations: string[] = [];

      if (result.output && typeof result.output !== "string") {
        for (const mod of result.output.modules) {
          const source = getFileDomainAndLayer(mod.source);
          if (!source) continue;

          for (const dep of mod.dependencies) {
            const target = parseImportLayer(dep.resolved, mod.source);
            if (!target) continue;
            if (target.domain === source.domain) continue;

            const rel = relative(process.cwd(), dep.resolved).split(sep);
            const rootParts = architecture.root.split("/");
            const rootIdx = rel.findIndex(
              (part, i) =>
                i + rootParts.length <= rel.length &&
                rel.slice(i, i + rootParts.length).join("/") ===
                  architecture.root
            );
            const afterRoot = rel.slice(rootIdx + rootParts.length);

            if (afterRoot.length > 3 || (afterRoot.length === 3 && afterRoot[2] !== "index.ts")) {
              violations.push(
                `VIOLATION: ${mod.source} deep-imports from ${dep.resolved}.\n` +
                `  Rule: Cross-domain imports must go through the barrel export (index.ts).\n` +
                `  Expected import path: ${architecture.root}/${target.domain}/${target.layer}/index.ts\n` +
                `  Fix: Export the needed symbol from ${target.domain}/${target.layer}/index.ts, then import from there.`
              );
            }
          }
        }
      }

      expect(violations, violations.join("\n\n")).toEqual([]);
    });
  });

  describe("no circular dependencies between domains", () => {
    it("domains do not form import cycles", async () => {
      const result = await cruise([architecture.root], {
        doNotFollow: { path: "node_modules" },
      });
      const domainDeps = new Map<string, Set<string>>();

      if (result.output && typeof result.output !== "string") {
        for (const mod of result.output.modules) {
          const source = getFileDomainAndLayer(mod.source);
          if (!source) continue;

          for (const dep of mod.dependencies) {
            const target = parseImportLayer(dep.resolved, mod.source);
            if (!target) continue;
            if (target.domain === source.domain) continue;

            if (!domainDeps.has(source.domain))
              domainDeps.set(source.domain, new Set());
            domainDeps.get(source.domain)!.add(target.domain);
          }
        }
      }

      const violations: string[] = [];
      for (const [domainA, deps] of domainDeps) {
        for (const domainB of deps) {
          if (domainDeps.get(domainB)?.has(domainA)) {
            const key = [domainA, domainB].sort().join(" <-> ");
            const msg =
              `CIRCULAR DEPENDENCY: ${domainA} <-> ${domainB}.\n` +
              `  Rule: Domains must not form import cycles.\n` +
              `  Fix: Extract shared code into a new domain or into utils, then have both domains depend on that.`;
            if (!violations.some((v) => v.includes(key))) violations.push(msg);
          }
        }
      }

      expect(violations, violations.join("\n\n")).toEqual([]);
    });
  });

  describe("file naming", () => {
    it("all source files use kebab-case", () => {
      const files = getAllFiles(architecture.root);
      const violations: string[] = [];

      for (const file of files) {
        const name = basename(file);
        if (name === "index.ts" || name === "index.tsx") continue;
        if (!isKebabCase(name)) {
          violations.push(
            `VIOLATION: ${file} is not kebab-case.\n` +
            `  Rule: All filenames must be kebab-case (e.g. user-profile.ts, not UserProfile.ts).\n` +
            `  Fix: Rename to ${name.replace(/([a-z])([A-Z])/g, "$1-$2").toLowerCase()}.`
          );
        }
      }

      expect(violations, violations.join("\n\n")).toEqual([]);
    });
  });

  describe("file length", () => {
    it(`no file exceeds ${architecture.rules.maxFileLines} lines`, () => {
      const files = getAllFiles(architecture.root);
      const violations: string[] = [];

      for (const file of files) {
        if (isExcludedFromLineCount(file)) continue;
        const lines = countLines(file);
        if (lines > architecture.rules.maxFileLines) {
          violations.push(
            `VIOLATION: ${file} has ${lines} lines (max: ${architecture.rules.maxFileLines}).\n` +
            `  Rule: Files must not exceed ${architecture.rules.maxFileLines} lines.\n` +
            `  Fix: Split this file into smaller, focused modules within the same layer.`
          );
        }
      }

      expect(violations, violations.join("\n\n")).toEqual([]);
    });
  });

  describe("barrel exports", () => {
    it("every layer folder has an index.ts", () => {
      const domains = getDomainFolders();
      const violations: string[] = [];

      for (const domain of domains) {
        for (const layer of allDomainLayers) {
          const layerDir = join(process.cwd(), architecture.root, domain, layer);
          if (!existsSync(layerDir)) continue;

          const barrelPath = join(layerDir, "index.ts");
          if (!existsSync(barrelPath)) {
            violations.push(
              `VIOLATION: ${architecture.root}/${domain}/${layer}/ has no index.ts barrel.\n` +
              `  Rule: Every layer folder must have an index.ts that serves as its public interface.\n` +
              `  Fix: Create ${architecture.root}/${domain}/${layer}/index.ts and export the layer's public API from it.`
            );
          }
        }
      }

      expect(violations, violations.join("\n\n")).toEqual([]);
    });
  });
});
```

## Notes for generating this file

- Import `architecture` from the config file at the project root.
- The test uses dependency-cruiser's `cruise()` JS API directly — no CLI, no separate config file needed.
- All rule thresholds and layer orderings come from `architecture.config.ts`. The test file contains zero hardcoded architectural decisions.
- Error messages are prescriptive: they state the violation, the rule, and the fix. An agent should be able to resolve the issue from the error message alone.
- The `cruise()` call scans only the domains root, not the entire project. This keeps test runtime fast.
