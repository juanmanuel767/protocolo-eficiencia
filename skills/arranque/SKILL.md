---
name: arranque
description: Prepara un proyecto nuevo para máxima eficiencia de tokens. Úsala cuando el usuario invoque /arranque al empezar a trabajar en un proyecto. Configura CLAUDE.md local, permisos del proyecto y grafo de conocimiento.
---

# Arranque de proyecto eficiente

Cuando se invoque, prepara el proyecto actual para sacar el máximo provecho del Protocolo de Eficiencia. Trabaja en silencio entre pasos y entrega un resumen breve al final.

## Pasos

1. **Detecta el tipo de proyecto** con una sola pasada:
   ```bash
   ls -A; test -f package.json && echo TIPO:node; test -f requirements.txt -o -f pyproject.toml && echo TIPO:python; test -f Cargo.toml && echo TIPO:rust; test -f go.mod && echo TIPO:go; test -d .git && echo GIT:si
   ```

2. **Crea `.claude/settings.json` local** con la allowlist de comandos de solo lectura comunes más los del stack detectado. No dupliques los permisos globales; añade solo los específicos del proyecto:
   - node → `Bash(npm *)`, `Bash(npx *)`, `Bash(node *)`, `Bash(yarn *)`, `Bash(pnpm *)`
   - python → `Bash(python *)`, `Bash(python3 *)`, `Bash(pip *)`, `Bash(pytest*)`, `Bash(ruff*)`
   - rust → `Bash(cargo *)`
   - go → `Bash(go *)`
   Si el archivo ya existe, fusiona sin borrar lo previo (lee primero).

3. **Genera el CLAUDE.md del proyecto** si no existe. Crea uno breve (máximo ~500 tokens) con: nombre y propósito en una frase, stack detectado, comandos de build/test, y una sección "Notas" vacía para que el usuario la complete. Si ya existe, no lo toques; solo indícalo.

4. **Ofrece el grafo de conocimiento.** Si el proyecto tiene más de ~10 archivos de código y no existe `graphify-out/`, recomienda ejecutar `/graphify` (no lo ejecutes automáticamente: puede ser costoso). Si ya existe `graphify-out/`, indícalo como disponible.

5. **Verifica.** Valida el JSON de settings con `jq empty`.

## Resumen final (máximo ~120 palabras)

- **Tipo de proyecto**: detectado / desconocido.
- **CLAUDE.md**: creado / ya existía.
- **Permisos locales**: N reglas añadidas para el stack.
- **Grafo**: disponible / recomendado ejecutar `/graphify` / no necesario.
- **Listo**: una frase de cierre. Si recomendaste `/graphify` o completar las "Notas" del CLAUDE.md, recuérdalo aquí.
