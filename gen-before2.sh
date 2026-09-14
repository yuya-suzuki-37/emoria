#!/bin/bash
# Before画像をAfter参照付きで再生成(同一場所・同一被写体)
CODEX=~/.npm-global/bin/codex
cd "$(dirname "$0")"
mkdir -p logs

declare -a PAIRS=(
  "before-arch:arch-interior"
  "before-clinic:clinic-interior"
  "before-exec:ceo-working"
  "before-hotel:hotel-room"
  "before-recruit:recruit-team"
  "before-wedding:wedding-dress"
  "before-course:lecture-studio"
)

for pair in "${PAIRS[@]}"; do
  name="${pair%%:*}"; ref="${pair##*:}"
  out="assets/img/${name}.png"
  refimg="assets/img/${ref}.png"
  if [ -f "$out" ]; then echo "skip(exists) $name"; continue; fi
  if [ ! -f "$refimg" ]; then echo "MISSING REF $refimg"; continue; fi
  PROMPT="$(cat "prompts/before2/${name}.txt")

$(cat prompts/before2/_common.txt)"
  for try in 1 2 3; do
    echo "gen $name (ref=$ref) (try $try) $(date '+%H:%M:%S')"
    "$CODEX" exec --skip-git-repo-check -s workspace-write -i "$refimg" \
      -- "$PROMPT" > "logs/${name}-v2.log" 2>&1 < /dev/null
    [ -f "$out" ] && { echo "OK $name"; break; }
    echo "  retry $name ..."; sleep 6
  done
  [ -f "$out" ] || echo "FAILED $name"
done
echo "=== BEFORE2 DONE $(date '+%H:%M:%S') ==="
for pair in "${PAIRS[@]}"; do
  name="${pair%%:*}"
  if [ -f "assets/img/${name}.png" ]; then
    sips -s format jpeg -s formatOptions 85 "assets/img/${name}.png" --out "assets/img/${name}.jpg" >/dev/null 2>&1 && echo "JPEG化: $name"
  else
    echo "MISS $name"
  fi
done
echo "BEFORE2-ALL-COMPLETE"
