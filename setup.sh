#!/bin/bash
set -euo pipefail

REPO="ekoeditaa/skills"
BRANCH="master"
TARGET_DIR="$(pwd)"

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "Installing eko skills into $TARGET_DIR"

curl -sL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" | tar xz -C "$TMPDIR"
SRC="$TMPDIR/skills-$BRANCH"

if [ ! -d "$SRC/skills" ]; then
  echo "Error: failed to download skills repo"
  exit 1
fi

mkdir -p "$TARGET_DIR/.claude/commands"
cp "$SRC/.claude/commands/"*.md "$TARGET_DIR/.claude/commands/"
echo "  Copied commands: eko:idea, eko:plan, eko:build, eko:review, eko:test, eko:pr"

mkdir -p "$TARGET_DIR/.claude/skills"
cp -R "$SRC/skills/"* "$TARGET_DIR/.claude/skills/"
echo "  Copied skills"

mkdir -p "$TARGET_DIR/hooks"
cp "$SRC/hooks/load-agent-skills.sh" "$TARGET_DIR/hooks/"
chmod +x "$TARGET_DIR/hooks/load-agent-skills.sh"
echo "  Copied hook: load-agent-skills.sh"

SETTINGS="$TARGET_DIR/.claude/settings.json"
HOOK_ENTRY='{"matcher":"","hooks":[{"type":"command","command":"hooks/load-agent-skills.sh"}]}'

merge_hooks() {
  if command -v jq &>/dev/null; then
    merge_with_jq
  elif command -v python3 &>/dev/null; then
    merge_with_python
  else
    echo "Error: jq or python3 required for JSON merging"
    exit 1
  fi
}

merge_with_jq() {
  if [ ! -f "$SETTINGS" ]; then
    echo "$HOOK_ENTRY" | jq "{hooks: {SessionStart: [.]}}" > "$SETTINGS"
    echo "  Created .claude/settings.json with SessionStart hook"
    return
  fi

  local already_installed
  already_installed=$(jq '[.hooks.SessionStart // [] | .[].hooks[]? | .command] | any(. == "hooks/load-agent-skills.sh")' "$SETTINGS" 2>/dev/null || echo "false")

  if [ "$already_installed" = "true" ]; then
    echo "  Hooks: already configured, skipped"
    return
  fi

  local has_session_start
  has_session_start=$(jq 'has("hooks") and (.hooks | has("SessionStart"))' "$SETTINGS" 2>/dev/null || echo "false")

  if [ "$has_session_start" = "true" ]; then
    jq --argjson entry "$HOOK_ENTRY" '.hooks.SessionStart += [$entry]' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
  else
    jq --argjson entry "$HOOK_ENTRY" '.hooks //= {} | .hooks.SessionStart = [$entry]' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
  fi
  echo "  Merged SessionStart hook into .claude/settings.json"
}

merge_with_python() {
  python3 -c "
import json, sys, os

settings_path = '$SETTINGS'
entry = json.loads('$HOOK_ENTRY')

if not os.path.exists(settings_path):
    data = {}
else:
    with open(settings_path) as f:
        data = json.load(f)

hooks = data.setdefault('hooks', {})
session_start = hooks.setdefault('SessionStart', [])

already = any(
    h.get('command') == 'hooks/load-agent-skills.sh'
    for item in session_start
    for h in item.get('hooks', [])
)
if already:
    print('  Hooks: already configured, skipped')
    sys.exit(0)

session_start.append(entry)

with open(settings_path, 'w') as f:
    json.dump(data, f, indent=2)
print('  Merged SessionStart hook into .claude/settings.json')
"
}

merge_hooks

STATUSLINE_SRC="$SRC/statusline.sh"
STATUSLINE_DST="$HOME/.claude/statusline-eko-skills.sh"
SETTINGS_LOCAL="$TARGET_DIR/.claude/settings.local.json"

cp "$STATUSLINE_SRC" "$STATUSLINE_DST"
chmod +x "$STATUSLINE_DST"
echo "  Copied statusline script to $STATUSLINE_DST"

merge_statusline() {
  local sl_entry="{\"type\":\"command\",\"command\":\"bash $STATUSLINE_DST\"}"
  if command -v jq &>/dev/null; then
    if [ ! -f "$SETTINGS_LOCAL" ]; then
      echo "$sl_entry" | jq '{statusLine: .}' > "$SETTINGS_LOCAL"
    else
      jq --argjson sl "$sl_entry" '.statusLine = $sl' "$SETTINGS_LOCAL" > "$SETTINGS_LOCAL.tmp" && mv "$SETTINGS_LOCAL.tmp" "$SETTINGS_LOCAL"
    fi
  elif command -v python3 &>/dev/null; then
    python3 -c "
import json, os
path = '$SETTINGS_LOCAL'
entry = json.loads('$sl_entry')
data = {}
if os.path.exists(path):
    with open(path) as f:
        data = json.load(f)
data['statusLine'] = entry
with open(path, 'w') as f:
    json.dump(data, f, indent=2)
"
  else
    echo "Error: jq or python3 required for JSON merging"
    exit 1
  fi
  echo "  Configured statusline in .claude/settings.local.json"
}

merge_statusline

echo ""
echo "Done. Workflow: /idea -> /plan -> /build -> /review -> /fix -> /test -> /pr"
