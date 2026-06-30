#!/usr/bin/env bash
# ───────────────────────────────────────────────────────────────
# movil.sh — Ver y controlar un teléfono Android por USB (adb)
# Uso:
#   movil.sh ver                    → captura la pantalla en /tmp/movil.png
#   movil.sh tap X Y                → toca en (X,Y)
#   movil.sh texto "hola mundo"     → escribe texto
#   movil.sh desliza X1 Y1 X2 Y2 [ms]
#   movil.sh inicio | atras | recientes
#   movil.sh abrir <paquete>        → lanza una app
#   movil.sh apps                   → lista los paquetes instalados
#   movil.sh estado                 → ¿hay teléfono conectado?
# ───────────────────────────────────────────────────────────────
set -euo pipefail
export PATH="$PATH:/snap/bin"

command -v adb >/dev/null || { echo "✗ adb no instalado. Ejecuta el install.sh del kit."; exit 1; }

DEV="$(adb devices | awk 'NR>1 && $2=="device"{print $1; exit}')"
if [ -z "$DEV" ]; then
  echo "✗ No hay teléfono conectado."
  echo "  → Activa 'Depuración USB' en el teléfono y conecta el cable; acepta el aviso."
  echo "  → Si no aparece, cambia el modo USB a 'Transferencia de archivos (MTP)'."
  echo "  → Verifica con: adb devices"
  exit 1
fi

cmd="${1:-ver}"; shift || true
case "$cmd" in
  ver)        adb -s "$DEV" exec-out screencap -p > /tmp/movil.png && echo "/tmp/movil.png";;
  tap)        adb -s "$DEV" shell input tap "$@";;
  texto)      adb -s "$DEV" shell input text "${*// /%s}";;
  desliza)    adb -s "$DEV" shell input swipe "$@";;
  inicio)     adb -s "$DEV" shell input keyevent KEYCODE_HOME;;
  atras)      adb -s "$DEV" shell input keyevent KEYCODE_BACK;;
  recientes)  adb -s "$DEV" shell input keyevent KEYCODE_APP_SWITCH;;
  abrir)      adb -s "$DEV" shell monkey -p "$1" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1;;
  apps)       adb -s "$DEV" shell pm list packages;;
  estado)     echo "✓ Teléfono conectado: $DEV";;
  *)          echo "Comando desconocido: '$cmd'. Usa: ver|tap|texto|desliza|inicio|atras|recientes|abrir|apps|estado"; exit 1;;
esac
