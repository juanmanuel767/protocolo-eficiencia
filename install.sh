#!/usr/bin/env bash
# ───────────────────────────────────────────────────────────────
# Instalador del Protocolo de Eficiencia para Claude Code
# UN SOLO COMANDO instala: agentes, skills, reglas y auto-activación.
# Idempotente: seguro de ejecutar varias veces (no duplica nada).
# Uso:  ./install.sh
# ───────────────────────────────────────────────────────────────
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"
SETTINGS="$CLAUDE_DIR/settings.json"
HOOK_DST="$CLAUDE_DIR/hooks/auto-arranque.sh"
MARK_INI="# === protocolo-eficiencia (inicio) ==="
MARK_FIN="# === protocolo-eficiencia (fin) ==="

echo "→ Instalando el Protocolo de Eficiencia en: $CLAUDE_DIR"

# 1) Agentes, skills y helpers (bin)
mkdir -p "$CLAUDE_DIR/agents" "$CLAUDE_DIR/skills" "$CLAUDE_DIR/hooks" "$CLAUDE_DIR/bin"
cp "$REPO_DIR"/agents/*.md "$CLAUDE_DIR/agents/"
cp -r "$REPO_DIR"/skills/* "$CLAUDE_DIR/skills/"
if [ -d "$REPO_DIR/bin" ]; then
  cp "$REPO_DIR"/bin/* "$CLAUDE_DIR/bin/"
  chmod +x "$CLAUDE_DIR"/bin/* 2>/dev/null || true
fi
echo "  ✓ Agentes (explorador, revisor), skills (ahorro, arranque, commit, memoria, movil, pruebas, seguridad, super, ultra, voz) y helpers copiados"

# 1b) adb — necesario para la skill /movil (ver y controlar el teléfono). Best-effort.
if command -v adb >/dev/null 2>&1; then
  echo "  ✓ adb ya está instalado ($(adb version 2>/dev/null | head -n1))"
elif command -v apt-get >/dev/null 2>&1; then
  echo "  → Instalando adb (Android platform-tools) con apt-get…"
  if sudo apt-get install -y adb >/dev/null 2>&1; then
    echo "  ✓ adb instalado"
  else
    echo "  ⚠ No se pudo instalar adb automáticamente. Instálalo a mano:  sudo apt-get install -y adb"
  fi
else
  echo "  ⚠ adb no encontrado. Instálalo para usar /movil (p. ej. paquete 'android-tools-adb' o 'platform-tools')."
fi

# 1c) Motor de voz para la skill /voz (best-effort, no crítico)
if command -v spd-say >/dev/null 2>&1 || command -v espeak-ng >/dev/null 2>&1 || command -v espeak >/dev/null 2>&1 || command -v festival >/dev/null 2>&1; then
  echo "  ✓ Motor de voz ya disponible (skill /voz)"
elif command -v apt-get >/dev/null 2>&1; then
  echo "  → Instalando motor de voz espeak-ng (skill /voz)…"
  if sudo apt-get install -y espeak-ng >/dev/null 2>&1; then
    echo "  ✓ espeak-ng instalado"
  else
    echo "  ⚠ No se pudo instalar espeak-ng. Para /voz:  sudo apt-get install -y espeak-ng"
  fi
else
  echo "  ⚠ Sin motor de voz. Para /voz instala 'espeak-ng' (o usa spd-say/festival)."
fi

# 2) Reglas en CLAUDE.md (idempotente: dedup por el encabezado del snippet)
touch "$CLAUDE_MD"
FINGERPRINT="$(head -n1 "$REPO_DIR/CLAUDE-snippet.md")"
if grep -qF "$FINGERPRINT" "$CLAUDE_MD"; then
  echo "  ✓ Las reglas ya estaban en CLAUDE.md — no se duplican"
else
  {
    printf '\n%s\n' "$MARK_INI"
    cat "$REPO_DIR/CLAUDE-snippet.md"
    printf '%s\n' "$MARK_FIN"
  } >> "$CLAUDE_MD"
  echo "  ✓ Reglas añadidas a CLAUDE.md"
fi

# 3) Hook de auto-activación en cada proyecto nuevo
cp "$REPO_DIR/hooks/auto-arranque.sh" "$HOOK_DST"
chmod +x "$HOOK_DST"
echo "  ✓ Hook de auto-activación copiado"

# 3b) Manual de bienvenida + marcador (el hook lo mostrará UNA vez al reiniciar)
cp "$REPO_DIR/MANUAL.md" "$CLAUDE_DIR/protocolo-manual.md"
: > "$CLAUDE_DIR/.protocolo-bienvenida-pendiente"
echo "  ✓ Manual de bienvenida instalado (se mostrará al reiniciar Claude Code)"

# 4) Registrar el hook en settings.json (merge seguro, idempotente)
[ -f "$SETTINGS" ] && cp "$SETTINGS" "$SETTINGS.bak.$(date +%s)"
python3 - "$SETTINGS" "$HOOK_DST" <<'PY'
import json, os, sys
path, hook_cmd = sys.argv[1], sys.argv[2]
data = {}
if os.path.exists(path) and os.path.getsize(path) > 0:
    with open(path) as f:
        data = json.load(f)
changed = False

# a) Hook SessionStart
hooks = data.setdefault("hooks", {})
ss = hooks.setdefault("SessionStart", [])
already = any(h.get("command") == hook_cmd
              for grp in ss if isinstance(grp, dict)
              for h in grp.get("hooks", []))
if not already:
    ss.append({"hooks": [{"type": "command", "command": hook_cmd}]})
    changed = True
    print("  ✓ Hook SessionStart registrado en settings.json")
else:
    print("  ✓ El hook ya estaba registrado en settings.json")

# b) Permiso para adb (skill /movil: ver y controlar el teléfono sin fricción)
perms = data.setdefault("permissions", {})
allow = perms.setdefault("allow", [])
if "Bash(adb *)" not in allow:
    allow.append("Bash(adb *)")
    changed = True
    print("  ✓ Permiso 'Bash(adb *)' añadido a settings.json (skill /movil)")
else:
    print("  ✓ El permiso de adb ya estaba en settings.json")

if changed:
    with open(path, "w") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
PY

echo ""
echo "✅ Instalación completada, señor. Un solo comando, todo listo."
echo "   • Reglas de eficiencia: activas en TODAS las sesiones (vía CLAUDE.md)"
echo "   • Auto-activación: al abrir cualquier proyecto nuevo, Claude ejecutará /arranque solo"
echo "   • Móvil: /movil deja a Claude VER y CONTROLAR tu Android por USB (adb ya autorizado)"
echo "   • Memoria: /memoria recuerda todo el proyecto (se carga sola si existe .claude/memoria/)"
echo "   • Antes de subir a git: /seguridad (fugas) · /commit (mensaje) · /pruebas (tests)"
echo "   • Comandos: /arranque · /ahorro · /memoria · /movil · /super · /ultra · /seguridad · /commit · /pruebas · /voz"
echo "   Reinicie Claude Code para cargar todo."
