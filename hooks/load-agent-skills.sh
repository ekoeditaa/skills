#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
META_SKILL="$SCRIPT_DIR/../.claude/skills/using-agent-skills/SKILL.md"

if [ -f "$META_SKILL" ]; then
  cat "$META_SKILL"
fi
