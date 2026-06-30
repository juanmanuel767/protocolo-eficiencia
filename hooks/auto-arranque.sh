#!/usr/bin/env bash
# ───────────────────────────────────────────────────────────────
# Hook SessionStart del Protocolo de Eficiencia.
# Claude Code lo ejecuta al iniciar cada sesión.
#   1) Si el kit se ACABA de instalar → ordena mostrar el manual de
#      bienvenida UNA sola vez (luego borra el marcador).
#   2) Si el proyecto tiene memoria persistente → la carga siempre.
#   3) Si el proyecto NO está configurado → activa el protocolo (/arranque).
#   4) Si ya está todo configurado → guarda silencio.
# ───────────────────────────────────────────────────────────────
set -euo pipefail

CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
MARK_BIENVENIDA="$CLAUDE_DIR/.protocolo-bienvenida-pendiente"

# 1) Recién instalado → presentar el manual de bienvenida (una sola vez)
if [ -f "$MARK_BIENVENIDA" ]; then
  rm -f "$MARK_BIENVENIDA"
  cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "[Protocolo de Eficiencia: primera ejecución tras instalar] El kit acaba de instalarse en este equipo. ANTES de cualquier otra cosa, presenta al usuario el MANUAL DE BIENVENIDA: lee el archivo ~/.claude/protocolo-manual.md y muéstralo con tu estilo, bien formateado y en español, explicando para qué sirve cada pieza (subagentes explorador y revisor; skills /arranque, /ahorro, /memoria, /movil, /super, /ultra; la auto-activación y el ahorro de tokens) y cómo se usa cada una. Hazlo solo esta vez."
  }
}
JSON
  exit 0
fi

# 2) Proyecto con memoria persistente → cargarla siempre (no se le escapa nada)
if [ -f ".claude/memoria/INDICE.md" ]; then
  cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "[Protocolo de Eficiencia: memoria del proyecto detectada] Este proyecto tiene memoria persistente en .claude/memoria/. ANTES de trabajar, lee .claude/memoria/INDICE.md (mapa del proyecto), pendientes.md (tareas/bloqueos en curso), decisiones.md y convenciones.md. Consulta el INDICE para localizar archivos en vez de explorar a ciegas, y mantén la memoria al día con la skill /memoria: añade una línea en el momento en que tomes una decisión, detectes una convención, cambies un archivo importante o empieces/termines una tarea."
  }
}
JSON
  exit 0
fi

# 3) Proyecto ya configurado (sin memoria) → no molestar
if [ -f ".claude/settings.json" ] || [ -f ".claude/settings.local.json" ]; then
  exit 0
fi

# 4) Proyecto nuevo/sin configurar → activar el protocolo vía contexto
cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "[Protocolo de Eficiencia activo] Proyecto sin configurar detectado. Antes de trabajar, ejecuta la skill /arranque para prepararlo (allowlist de permisos de solo lectura, CLAUDE.md breve, detección de stack). Durante la sesión: delega exploraciones de >3 archivos al subagente 'explorador' (Haiku), usa 'revisor' para auditorías, lee de forma quirúrgica (Grep/Glob antes que leer entero) y evita narrar acciones rutinarias."
  }
}
JSON
