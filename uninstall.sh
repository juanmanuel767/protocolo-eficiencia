#!/usr/bin/env bash
# ───────────────────────────────────────────────────────────────
# Desinstalador del Protocolo de Eficiencia para Claude Code
# Elimina agentes, skills, el bloque del snippet y el hook.
# Uso:  ./uninstall.sh
# ───────────────────────────────────────────────────────────────
set -euo pipefail

CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"
SETTINGS="$CLAUDE_DIR/settings.json"
HOOK_DST="$CLAUDE_DIR/hooks/auto-arranque.sh"
MARK_INI="# === protocolo-eficiencia (inicio) ==="
MARK_FIN="# === protocolo-eficiencia (fin) ==="

echo "→ Desinstalando de: $CLAUDE_DIR"

rm -f  "$CLAUDE_DIR/agents/explorador.md" "$CLAUDE_DIR/agents/revisor.md"
for s in ahorro arranque commit memoria movil pruebas seguridad super ultra voz; do
  rm -rf "$CLAUDE_DIR/skills/$s"
done
rm -f  "$CLAUDE_DIR/bin/movil.sh" "$CLAUDE_DIR/bin/seguridad.sh" \
       "$CLAUDE_DIR/bin/pruebas.sh" "$CLAUDE_DIR/bin/voz.sh"
rm -f  "$HOOK_DST"
rm -f  "$CLAUDE_DIR/protocolo-manual.md" "$CLAUDE_DIR/.protocolo-bienvenida-pendiente"
echo "  ✓ Agentes, skills, helper, manual y hook eliminados"

# Quitar el bloque de reglas (solo si se añadió con marcadores)
if [ -f "$CLAUDE_MD" ] && grep -qF "$MARK_INI" "$CLAUDE_MD"; then
  sed -i "/$MARK_INI/,/$MARK_FIN/d" "$CLAUDE_MD"
  echo "  ✓ Bloque de reglas eliminado de CLAUDE.md"
else
  echo "  · Reglas en CLAUDE.md: si las añadiste a mano, quítalas manualmente"
fi

# Quitar el hook de settings.json
if [ -f "$SETTINGS" ]; then
  python3 - "$SETTINGS" "$HOOK_DST" <<'PY'
import json, os, sys
path, hook_cmd = sys.argv[1], sys.argv[2]
with open(path) as f:
    data = json.load(f)
ss = data.get("hooks", {}).get("SessionStart", [])
for grp in ss:
    if isinstance(grp, dict):
        grp["hooks"] = [h for h in grp.get("hooks", []) if h.get("command") != hook_cmd]
data.get("hooks", {})["SessionStart"] = [g for g in ss if g.get("hooks")]
if not data.get("hooks", {}).get("SessionStart"):
    data.get("hooks", {}).pop("SessionStart", None)
# Quitar el permiso de adb que añadió el instalador
allow = data.get("permissions", {}).get("allow", [])
if "Bash(adb *)" in allow:
    allow.remove("Bash(adb *)")
    print("  ✓ Permiso de adb eliminado de settings.json")
with open(path, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
print("  ✓ Hook eliminado de settings.json")
PY
fi

echo ""
echo "✅ Desinstalación completada, señor."
