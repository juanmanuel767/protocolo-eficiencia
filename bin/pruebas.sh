#!/usr/bin/env bash
# ───────────────────────────────────────────────────────────────
# pruebas.sh — Detecta el framework de tests del proyecto y los corre.
# Uso:  bin/pruebas.sh            (detecta y ejecuta)
#       bin/pruebas.sh detectar   (solo dice qué framework hay)
# ───────────────────────────────────────────────────────────────
set -uo pipefail
export PATH="$PATH:/snap/bin"
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
MODE="${1:-correr}"

detectar() {
  if [ -f package.json ] && grep -q '"test"' package.json; then echo "node:npm"; return; fi
  if [ -f pyproject.toml ] || [ -f pytest.ini ] || [ -f setup.cfg ] || [ -d tests ] || [ -d test ]; then
    command -v pytest >/dev/null 2>&1 && { echo "python:pytest"; return; }; fi
  [ -f Cargo.toml ] && { echo "rust:cargo"; return; }
  [ -f go.mod ] && { echo "go:gotest"; return; }
  [ -f pubspec.yaml ] && { echo "flutter:fluttertest"; return; }
  echo "ninguno"
}

FW="$(detectar)"
echo "🧪 Framework detectado: $FW"
[ "$MODE" = "detectar" ] && exit 0

case "$FW" in
  node:npm)            echo "→ npm test"; npm test;;
  python:pytest)       echo "→ pytest -q"; pytest -q;;
  rust:cargo)          echo "→ cargo test"; cargo test;;
  go:gotest)           echo "→ go test ./..."; go test ./...;;
  flutter:fluttertest) echo "→ flutter test"; flutter test;;
  *) echo "No detecté un framework de pruebas. Pídele a Claude que genere los tests con la skill /pruebas."; exit 1;;
esac
