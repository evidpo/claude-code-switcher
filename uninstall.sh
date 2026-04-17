#!/bin/bash
set -euo pipefail
rm -f "$HOME/.local/bin/cc-glm" \
      "$HOME/.local/bin/cc-claude" \
      "$HOME/.local/bin/cc-status" \
      "$HOME/.local/bin/claude-ollama"
echo "Удалены команды из ~/.local/bin."
echo "Файлы ~/.claude/settings.* и профиль ~/.claude-ollama/ не удаляю (там могут быть твои настройки, токены и история сессий)."
echo "Если хочешь снести Ollama-профиль целиком:  rm -rf ~/.claude-ollama"
