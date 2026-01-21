# Claude Code (TRAE) — переключение GLM (Z.ai) ↔ Claude (Anthropic)

Этот набор скриптов позволяет быстро переключать провайдера в расширении **Claude Code for VS Code** (TRAE/форки VS Code) между:
- **GLM** через Z.ai (Anthropic-compatible endpoint),
- **Обычным Claude** (Anthropic, через логин расширения).

Переключение делается командами:
- `cc-glm` — включить GLM (Z.ai)
- `cc-claude` — включить Claude (Anthropic)

После переключения нужно:
- перезапустить TRAE **или**
- `Cmd+Shift+P → Developer: Reload Window`

---

## Как это работает

Claude Code читает настройки окружения из файла:

- `~/.claude/settings.json`

Мы храним два шаблона:

- `~/.claude/settings.glm.json` — содержит переменные для Z.ai: endpoint + токен + маппинг моделей на `glm-4.7...`
- `~/.claude/settings.claude.json` — очищает env (возврат на “родной Claude” через обычный логин расширения)

Команды просто копируют нужный шаблон в активный файл:

- `cc-glm`: `settings.glm.json` → `settings.json`
- `cc-claude`: `settings.claude.json` → `settings.json`

---

## Проверка, что включился GLM или Claude

Смотри на баннер (в терминале, где запущен Claude Code):

- GLM: `glm-4.7 · API Usage Billing`
- Claude: `Claude Pro` и модели Claude (Opus/Sonnet/Haiku)

Также можно сделать опциональную команду `cc-status` (см. ниже).

---

## Рекомендованные настройки TRAE / расширения

Чтобы расширение стабильно работало с кастомным endpoint, обычно лучше:
- включить `Claude Code: Use Terminal` = **ON**

---

## Безопасность

- Не публикуй токены в чатах/скринах/репозиториях.
- Держи файлы с токенами под правами `600`.
- Если токен засветился — перевыпусти токен на стороне провайдера и замени локально.

---

# Установка (вручную, без репозитория)

## 1) Подготовь каталоги
```bash
mkdir -p ~/.local/bin ~/.claude
```

## 2) Создай шаблон GLM (Z.ai)
```bash
cat > ~/.claude/settings.glm.json <<'JSON'
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.z.ai/api/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-4.7-flash",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-4.7",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-4.7"
  }
}
JSON
chmod 600 ~/.claude/settings.glm.json
```

Вставь токен:
```bash
nano ~/.claude/settings.glm.json
```
Найди строку:
```json
"ANTHROPIC_AUTH_TOKEN": ""
```
и вставь токен между кавычками.

## 3) Создай шаблон Claude (Anthropic)
```bash
cat > ~/.claude/settings.claude.json <<'JSON'
{
  "env": {}
}
JSON
chmod 600 ~/.claude/settings.claude.json
```

## 4) Создай команды переключения

### `cc-glm`
```bash
cat > ~/.local/bin/cc-glm <<'EOF'
#!/bin/bash
set -euo pipefail
cp "$HOME/.claude/settings.glm.json" "$HOME/.claude/settings.json"
chmod 600 "$HOME/.claude/settings.json" || true
echo "Switched to GLM (Z.ai). Перезапусти TRAE или Developer: Reload Window."
EOF
chmod 700 ~/.local/bin/cc-glm
```

### `cc-claude`
```bash
cat > ~/.local/bin/cc-claude <<'EOF'
#!/bin/bash
set -euo pipefail
cp "$HOME/.claude/settings.claude.json" "$HOME/.claude/settings.json"
chmod 600 "$HOME/.claude/settings.json" || true
echo "Switched to Claude (Anthropic). Перезапусти TRAE или Developer: Reload Window."
EOF
chmod 700 ~/.local/bin/cc-claude
```

## 5) (Опционально) `cc-status`
```bash
cat > ~/.local/bin/cc-status <<'EOF'
#!/bin/bash
set -euo pipefail
S="$HOME/.claude/settings.json"
if [ ! -f "$S" ]; then
  echo "Нет ~/.claude/settings.json"
  exit 0
fi
if grep -q 'api\.z\.ai/api/anthropic' "$S"; then
  echo "ACTIVE: GLM (Z.ai)"
else
  echo "ACTIVE: Claude (Anthropic)"
fi
EOF
chmod 700 ~/.local/bin/cc-status
```

## 6) Использование
Включить GLM:
```bash
cc-glm
```
Перезапусти TRAE / `Developer: Reload Window`.

Включить Claude:
```bash
cc-claude
```
Перезапусти TRAE / `Developer: Reload Window`.

---

# Как сделать отдельный репозиторий (чтобы “положить себе”)

## 1) Создай repo локально
```bash
mkdir -p ~/coding/claude-code-switcher
cd ~/coding/claude-code-switcher
git init
mkdir -p bin templates
```

## 2) Добавь файлы в repo

### `bin/cc-glm`
```bash
cat > bin/cc-glm <<'EOF'
#!/bin/bash
set -euo pipefail
cp "$HOME/.claude/settings.glm.json" "$HOME/.claude/settings.json"
chmod 600 "$HOME/.claude/settings.json" || true
echo "Switched to GLM (Z.ai). Перезапусти TRAE или Developer: Reload Window."
EOF
chmod 755 bin/cc-glm
```

### `bin/cc-claude`
```bash
cat > bin/cc-claude <<'EOF'
#!/bin/bash
set -euo pipefail
cp "$HOME/.claude/settings.claude.json" "$HOME/.claude/settings.json"
chmod 600 "$HOME/.claude/settings.json" || true
echo "Switched to Claude (Anthropic). Перезапусти TRAE или Developer: Reload Window."
EOF
chmod 755 bin/cc-claude
```

### `bin/cc-status` (опционально)
```bash
cat > bin/cc-status <<'EOF'
#!/bin/bash
set -euo pipefail
S="$HOME/.claude/settings.json"
if [ ! -f "$S" ]; then
  echo "Нет ~/.claude/settings.json"
  exit 0
fi
if grep -q 'api\.z\.ai/api/anthropic' "$S"; then
  echo "ACTIVE: GLM (Z.ai)"
else
  echo "ACTIVE: Claude (Anthropic)"
fi
EOF
chmod 755 bin/cc-status
```

### `templates/settings.glm.json` (ВАЖНО: без токена в репозитории!)
```bash
cat > templates/settings.glm.json <<'JSON'
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.z.ai/api/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-4.7-flash",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-4.7",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-4.7"
  }
}
JSON
```

### `templates/settings.claude.json`
```bash
cat > templates/settings.claude.json <<'JSON'
{
  "env": {}
}
JSON
```

## 3) Установщик `install.sh` (установка на новую машину одной командой)
```bash
cat > install.sh <<'EOF'
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
EOF
chmod 755 install.sh
```

## 4) `uninstall.sh` (удаление команд)
```bash
cat > uninstall.sh <<'EOF'
#!/bin/bash
set -euo pipefail
rm -f "$HOME/.local/bin/cc-glm" "$HOME/.local/bin/cc-claude" "$HOME/.local/bin/cc-status"
echo "Удалены команды из ~/.local/bin"
echo "Файлы ~/.claude/settings.* не удаляю (там могут быть твои настройки)."
EOF
chmod 755 uninstall.sh
```

## 5) Сохрани этот файл как `README.md`
Скопируй содержимое этого README и положи в `~/coding/claude-code-switcher/README.md`.

## 6) Первый коммит
```bash
git add .
git commit -m "Add GLM <-> Claude switcher for Claude Code"
```

## 7) (Опционально) Запушить на GitHub
1) Создай репозиторий на GitHub и скопируй его URL.
2) Выполни:
```bash
git remote add origin "$(pbpaste)"
git branch -M main
git push -u origin main
```
