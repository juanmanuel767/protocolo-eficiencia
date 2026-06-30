#!/usr/bin/env bash
# ───────────────────────────────────────────────────────────────
# seguridad.sh — Auditoría DEFENSIVA local antes de subir a git.
# Busca secretos, archivos sensibles versionados y dependencias
# vulnerables. Solo lectura: no modifica nada. Uso: bin/seguridad.sh
# ───────────────────────────────────────────────────────────────
set -uo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
echo "🔒 Auditoría de seguridad en: $ROOT"
ISSUES=0

FILES="$(git ls-files 2>/dev/null)"
[ -z "$FILES" ] && FILES="$(find . -type f -not -path './.git/*')"

# 1) Secretos / credenciales en archivos rastreados
echo; echo "── 1. Secretos / credenciales ──"
PAT='(api[_-]?key|secret[_-]?key|password\s*=|passwd\s*=|BEGIN (RSA|OPENSSH|EC|DSA|PRIVATE) KEY|AKIA[0-9A-Z]{16}|xox[baprs]-[0-9A-Za-z-]+|ghp_[0-9A-Za-z]{36}|github_pat_[0-9A-Za-z_]{22,}|sk-[0-9A-Za-z]{20,}|AIza[0-9A-Za-z_-]{35})'
HITS="$(printf '%s\n' "$FILES" | xargs -d '\n' -r grep -InE "$PAT" 2>/dev/null \
        | grep -viE '(example|sample|mock|dummy|placeholder|fixture|\.lock|test[_/.])' )"
if [ -n "$HITS" ]; then
  echo "⚠ Posibles secretos (revisa antes de subir):"; echo "$HITS" | head -n 30; ISSUES=$((ISSUES+1))
else echo "✓ Sin secretos evidentes"; fi

# 2) Archivos sensibles versionados por git
echo; echo "── 2. Archivos sensibles en git ──"
SENS="$(printf '%s\n' "$FILES" | grep -iE '(^|/)(\.env(\..*)?|id_rsa|id_ed25519|.*\.pem|.*\.key|.*\.p12|.*\.pfx|credentials(\.json)?|\.npmrc|\.pypirc|\.aws/.*)$' || true)"
if [ -n "$SENS" ]; then
  echo "⚠ Archivos sensibles versionados (¡no deberían estar en git!):"; echo "$SENS"; ISSUES=$((ISSUES+1))
else echo "✓ Ningún archivo sensible versionado"; fi

# 3) ¿.gitignore protege .env y claves?
echo; echo "── 3. Protección en .gitignore ──"
if [ -f .gitignore ] && grep -qE '(^|/)\.env' .gitignore; then echo "✓ .gitignore cubre .env"
else echo "⚠ Recomendado: añade '.env' y '*.key' a .gitignore"; ISSUES=$((ISSUES+1)); fi

# 4) Dependencias vulnerables (según el stack)
echo; echo "── 4. Dependencias vulnerables ──"
if [ -f package.json ] && command -v npm >/dev/null 2>&1; then
  echo "→ npm audit"; npm audit 2>/dev/null | tail -n 15 || true
elif { [ -f requirements.txt ] || [ -f pyproject.toml ]; } && command -v pip-audit >/dev/null 2>&1; then
  echo "→ pip-audit"; pip-audit 2>/dev/null | tail -n 15 || true
elif [ -f Cargo.toml ] && cargo audit --version >/dev/null 2>&1; then
  echo "→ cargo audit"; cargo audit 2>/dev/null | tail -n 15 || true
else echo "· Sin auditor de dependencias disponible para este stack (opcional: npm / pip-audit / cargo-audit)"; fi

echo; echo "──────────────────────────────"
[ "$ISSUES" -eq 0 ] && echo "✅ Sin hallazgos. Listo para subir." || echo "⚠ $ISSUES categoría(s) con hallazgos. Revísalas antes del push."
