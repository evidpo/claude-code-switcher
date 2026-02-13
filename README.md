# claude-code-switcher

Переключатель окружения для **Claude Code** между:

- **GLM (Z.ai)** — через `https://api.z.ai/api/anthropic`, модели **жёстко pinned на `glm-4.7`**
- **Claude (Anthropic)** — стандартный режим Claude Code

Главная идея: скрипты **НЕ копируют целиком** `~/.claude/settings.*.json` в `~/.claude/settings.json`.  
Они заменяют **только поле `env`** в `~/.claude/settings.json`, чтобы **не сносить остальные настройки** (например, `enabledPlugins`, MCP-конфиги и т.п.).

---

## Быстрый старт

### 1) Клонировать репозиторий
```bash
git clone https://github.com/evidpo/claude-code-switcher.git
cd claude-code-switcher
```

### 2) Установить команды
```bash
./install.sh
```

После установки будут доступны команды:
- `cc-glm` — включить GLM (Z.ai) **pinned `glm-4.7`**
- `cc-claude` — включить Claude (Anthropic)

---

## Где лежат файлы

Шаблоны:
- `~/.claude/settings.glm.json`
- `~/.claude/settings.claude.json`

Активный файл, который читает Claude Code:
- `~/.claude/settings.json`

> Важно: токен **не хранится в репозитории**. Он хранится локально у тебя в `~/.claude/settings.glm.json`.

---

## Использование

### Включить GLM (Z.ai)
```bash
cc-glm
```

Что происходит:
- берётся `env` из `~/.claude/settings.glm.json`
- принудительно выставляются модели:
  - `ANTHROPIC_DEFAULT_OPUS_MODEL=glm-4.7`
  - `ANTHROPIC_DEFAULT_SONNET_MODEL=glm-4.7`
  - `ANTHROPIC_DEFAULT_HAIKU_MODEL=glm-4.7-flash`
- принудительно включается:
  - `ENABLE_TOOL_SEARCH=1`
- в `~/.claude/settings.json` заменяется **только** поле `env` (прочие поля сохраняются)

### Включить Claude (Anthropic)
```bash
cc-claude
```

Что происходит:
- берётся `env` из `~/.claude/settings.claude.json`
- принудительно включается:
  - `ENABLE_TOOL_SEARCH=1`
- в `~/.claude/settings.json` заменяется **только** поле `env` (прочие поля сохраняются)

---

## Важно для TRAE / VS Code

После переключения режима сделай:
- **TRAE → Cmd+Shift+P → Developer: Reload Window**

(или просто перезапусти окно), чтобы расширение перечитало настройки.

---

## Почему `enabledPlugins` может быть пустым

Если раньше переключатель делал `cp settings.glm.json -> settings.json`, можно было потерять поле `enabledPlugins` (его просто перетирало).  

Текущая версия переключателя:
- **не удаляет** `enabledPlugins`
- **не восстанавливает** его, если оно уже было удалено раньше

Если поле уже отсутствует, оно обычно появляется снова после действий в UI плагинов Claude Code.

---

## Отладка

### Проверить, что `settings.json` — валидный JSON
```bash
python3 -m json.tool ~/.claude/settings.json >/dev/null && echo OK
```

### Проверить, что GLM включён и модели pinned на 4.7
```bash
python3 - <<'PY'
import json, os
p=os.path.expanduser("~/.claude/settings.json")
env=json.load(open(p,"r",encoding="utf-8")).get("env",{})
print("BASE_URL:", env.get("ANTHROPIC_BASE_URL"))
print("OPUS:", env.get("ANTHROPIC_DEFAULT_OPUS_MODEL"))
print("SONNET:", env.get("ANTHROPIC_DEFAULT_SONNET_MODEL"))
print("HAIKU:", env.get("ANTHROPIC_DEFAULT_HAIKU_MODEL"))
print("ENABLE_TOOL_SEARCH:", env.get("ENABLE_TOOL_SEARCH"))
PY
```

---

## Uninstall

Удаляет команды из `~/.local/bin`.  
Локальные файлы `~/.claude/settings.*` не удаляет (там могут быть твои настройки и токен).

```bash
./uninstall.sh
```
