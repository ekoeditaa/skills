#!/usr/bin/env bash
input=$(cat)
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // .cwd')

branch=$(git -C "$project_dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
uncommitted=$(git -C "$project_dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')

plan_file=$(find "$project_dir/.eko/plans" -maxdepth 1 -name "*.md" 2>/dev/null | head -1)
if [ -n "$plan_file" ]; then
  plan_name=$(basename "$plan_file" .md)
else
  plan_name=""
fi

review_file=$(find "$project_dir/.eko/reviews" -maxdepth 1 -name "*.md" 2>/dev/null | head -1)
if [ -n "$review_file" ]; then
  review_name=$(basename "$review_file" .md)
else
  review_name=""
fi

remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

parts=()

if [ -n "$branch" ]; then
  git_part="$branch"
  if [ "$uncommitted" -gt 0 ]; then
    git_part="$git_part | $uncommitted uncommitted"
  fi
  parts+=("$git_part")
fi

if [ -n "$plan_name" ]; then
  parts+=("plan: $plan_name")
fi

if [ -n "$review_name" ]; then
  parts+=("review: pending fix")
fi

if [ -n "$remaining" ]; then
  parts+=("ctx: $(printf '%.0f' "$remaining")% left")
fi

output=""
for i in "${!parts[@]}"; do
  if [ "$i" -gt 0 ]; then
    output="$output | "
  fi
  output="$output${parts[$i]}"
done

echo "$output"
