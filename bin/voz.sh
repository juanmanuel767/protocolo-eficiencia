#!/usr/bin/env bash
# ───────────────────────────────────────────────────────────────
# voz.sh — Da voz a EMMA: lee texto en voz alta con el motor TTS
# disponible en el sistema (español por defecto).
# Uso:  voz.sh hablar "La operación se completó, señor"
#       voz.sh motor          (muestra qué motor de voz hay)
# ───────────────────────────────────────────────────────────────
set -uo pipefail

hablar() {
  local t="$1"
  if   command -v spd-say   >/dev/null 2>&1; then spd-say -w -l es "$t"
  elif command -v espeak-ng >/dev/null 2>&1; then espeak-ng -v es "$t"
  elif command -v espeak    >/dev/null 2>&1; then espeak -v es "$t"
  elif command -v festival  >/dev/null 2>&1; then printf '%s\n' "$t" | festival --tts
  else
    echo "✗ No hay motor de voz instalado."
    echo "  → Instálalo:  sudo apt-get install -y espeak-ng"
    return 1
  fi
}

cmd="${1:-hablar}"; shift || true
case "$cmd" in
  hablar) hablar "$*";;
  motor)
    for e in spd-say espeak-ng espeak festival; do
      command -v "$e" >/dev/null 2>&1 && { echo "✓ Motor de voz: $e"; exit 0; }
    done
    echo "✗ Ningún motor TTS. Instala:  sudo apt-get install -y espeak-ng"; exit 1;;
  *) echo "uso: voz.sh hablar \"texto\"  |  voz.sh motor";;
esac
