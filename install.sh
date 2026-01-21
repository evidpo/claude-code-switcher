#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$HOME/.local/bin" "$HOME/.claude"

install -m 755 "$REPO_DIR/bin/cc-glm" "$HOME/.local/bin/cc-glm"
install -m 755 "$REPO_DIR/bin/cc-claude" "$HOME/.local/bin/cc-claude"
if [ -f "$REPO_DIR/bin/cc-status" ]; then
  install -m 755 "$REPO_DIR/bin/cc-status" "$HOME/.local/bin/cc-status"
fi

install -m 600 "$REPO_DIR/templates/settings.claude.json" "$HOME/.claude/settings.claude.json"
install -m 600 "$REPO_DIR/templates/settings.glm.json" "$HOME/.claude/settings.glm.json"

echo
echo "Вставь токен Z.ai (не будет показан на экране) и нажми Enter:"
read -rs TOKEN
echo

if [ -n "$TOKEN" ]; then
  TOKEN="$TOKEN" python3 - <<'PY'
import json, os
p = os.path.expanduser("~/.claude/settings.glm.json")
with open(p, "r", encoding="utf-8") as f:
    data = json.load(f)
data["env"]["ANTHROPIC_AUTH_TOKEN"] = os.environ["TOKEN"]
with open(p, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
print("OK: токен записан в ~/.claude/settings.glm.json")
PY
else
  echo "ВНИМАНИЕ: токен пустой. Вставь токен в ~/.claude/settings.glm.json вручную."
fi

chmod 600 "$HOME/.claude/settings.glm.json" "$HOME/.claude/settings.claude.json"
echo
echo "Готово. Используй:"
echo "  cc-glm    -> включить GLM"
echo "  cc-claude -> включить Claude"
echo "После переключения: перезапусти TRAE или Developer: Reload Window."
