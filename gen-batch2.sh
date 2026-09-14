#!/bin/bash
# 追加3枚(プロ品質)→Before7枚(素人風)を直列生成
CODEX=~/.npm-global/bin/codex
cd "$(dirname "$0")"
mkdir -p assets/img logs

gen() {
  local name="$1" pfile="$2" extra="$3"
  local out="assets/img/${name}.png"
  if [ -f "$out" ]; then echo "skip(exists) $name"; return; fi
  local PROMPT="$(cat "$pfile")

$(cat "$extra")"
  for try in 1 2 3; do
    echo "gen $name (try $try) $(date '+%H:%M:%S')"
    "$CODEX" exec --skip-git-repo-check -s workspace-write -- "$PROMPT" > "logs/${name}.log" 2>&1 < /dev/null
    [ -f "$out" ] && { echo "OK $name"; return; }
    echo "  retry $name ..."; sleep 6
  done
  echo "FAILED $name"
}

for n in recruit-interview wedding-detail lecture-monitor; do
  gen "$n" "prompts/${n}.txt" "prompts/_common.txt"
done
for n in before-arch before-clinic before-exec before-hotel before-recruit before-wedding before-course; do
  gen "$n" "prompts/before/${n}.txt" "prompts/before/_common-before.txt"
done
echo "=== BATCH2 DONE $(date '+%H:%M:%S') ==="
for n in recruit-interview wedding-detail lecture-monitor before-arch before-clinic before-exec before-hotel before-recruit before-wedding before-course; do
  [ -f "assets/img/${n}.png" ] && echo "OK   $n" || echo "MISS $n"
done
