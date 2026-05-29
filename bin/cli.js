#!/usr/bin/env node

import { readdir, readFile, cp, mkdir } from "node:fs/promises";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { checkbox, select } from "@inquirer/prompts";

const __dirname = dirname(fileURLToPath(import.meta.url));
const skillsDir = join(__dirname, "..", "skills");

function parseFrontmatter(content) {
  const match = content.match(/^---\n([\s\S]*?)\n---/);
  if (!match) return {};
  const raw = match[1];
  const name = raw.match(/^name:\s*(.+)$/m)?.[1]?.trim();
  const descLines = [];
  let capturing = false;
  for (const line of raw.split("\n")) {
    if (line.match(/^description:/)) {
      capturing = true;
      const inline = line.replace(/^description:\s*>-?\s*/, "").trim();
      if (inline) descLines.push(inline);
      continue;
    }
    if (capturing) {
      if (line.match(/^\S/) && !line.startsWith(" ")) break;
      descLines.push(line.trim());
    }
  }
  const description = descLines.join(" ").replace(/\s+/g, " ").trim();
  const firstSentence = description.split(/\.\s/)[0] + ".";
  return { name, description: firstSentence };
}

async function discoverSkills() {
  const entries = await readdir(skillsDir, { withFileTypes: true });
  const skills = [];
  for (const entry of entries) {
    if (!entry.isDirectory()) continue;
    const skillPath = join(skillsDir, entry.name, "SKILL.md");
    try {
      const content = await readFile(skillPath, "utf-8");
      const meta = parseFrontmatter(content);
      skills.push({
        dir: entry.name,
        name: meta.name || entry.name,
        description: meta.description || "",
      });
    } catch {
      continue;
    }
  }
  return skills.sort((a, b) => a.name.localeCompare(b.name));
}

async function copySkill(skillName, targetBase) {
  const src = join(skillsDir, skillName);
  const dest = join(targetBase, skillName);
  await mkdir(dest, { recursive: true });
  await cp(src, dest, { recursive: true });
}

async function main() {
  const skills = await discoverSkills();
  if (skills.length === 0) {
    console.log("No skills found.");
    process.exit(1);
  }

  const selected = await checkbox({
    message: "Select skills to install",
    choices: skills.map((s) => ({
      name: `${s.name} — ${s.description}`,
      value: s.dir,
    })),
  });

  if (selected.length === 0) {
    console.log("Nothing selected.");
    return;
  }

  const target = await select({
    message: "Where to install?",
    choices: [
      { name: ".claude/commands/", value: ".claude/commands" },
      { name: ".claude/agents/", value: ".claude/agents" },
    ],
  });

  const targetBase = join(process.cwd(), target);
  await mkdir(targetBase, { recursive: true });

  for (const dir of selected) {
    await copySkill(dir, targetBase);
    const skill = skills.find((s) => s.dir === dir);
    console.log(`  installed ${skill.name}`);
  }

  console.log(`\n${selected.length} skill(s) installed to ${target}/`);
}

main().catch((err) => {
  if (err.name === "ExitPromptError") process.exit(0);
  console.error(err);
  process.exit(1);
});
