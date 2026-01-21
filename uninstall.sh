#!/bin/bash
set -euo pipefail
rm -f "$HOME/.local/bin/cc-glm" "$HOME/.local/bin/cc-claude" "$HOME/.local/bin/cc-status"
echo "Удалены команды из ~/.local/bin"
echo "Файлы ~/.claude/settings.* не удаляю (там могут быть твои настройки)."
