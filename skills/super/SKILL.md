---
name: super
description: Modo máxima capacidad para un proyecto de CONFIANZA. Úsala cuando el usuario invoque /super y quiera que Claude trabaje sin interrupciones de permisos (allowlist amplia para git, gestores de paquetes, build, test y operaciones de archivos del proyecto), manteniendo bloqueados los comandos peligrosos.
---

# Modo máxima capacidad (/super)

Configura el proyecto **actual** para que Claude opere con la mínima fricción de permisos: una allowlist amplia adaptada al stack, escrita en `.claude/settings.json` local. Diseñada para **proyectos de confianza** (código propio o de tu equipo).

> ⚠️ **Advierte al usuario antes de aplicar:** esto reduce las confirmaciones de permisos. Úsalo solo en proyectos donde confíe en el código. NO lo apliques en repos ajenos sin revisar.

## Pasos

1. **Confirma que es un proyecto de confianza.** Si hay cualquier duda (repo clonado de terceros, código desconocido), recomienda NO aplicarlo y detente.

2. **Detecta el stack** con una sola pasada:
   ```bash
   ls -A; test -f package.json && echo node; test -f pyproject.toml -o -f requirements.txt && echo python; test -f Cargo.toml && echo rust; test -f go.mod && echo go; test -d .git && echo git
   ```

3. **Crea/fusiona `.claude/settings.json`** (lee primero si existe, no borres lo previo) con esta allowlist base + la del stack:

   **Base (siempre):**
   `Bash(git *)`, `Bash(ls*)`, `Bash(cd*)`, `Bash(cat*)`, `Bash(grep*)`, `Bash(rg*)`, `Bash(find*)`, `Bash(wc*)`, `Bash(head*)`, `Bash(tail*)`, `Bash(mkdir*)`, `Bash(touch*)`, `Bash(cp*)`, `Bash(mv*)`, `Bash(echo*)`, `Bash(sed*)`, `Bash(awk*)`, `Edit`, `Write`, `Read`, `Grep`, `Glob`

   **Según stack:**
   - node → `Bash(npm *)`, `Bash(npx *)`, `Bash(node *)`, `Bash(yarn *)`, `Bash(pnpm *)`, `Bash(jest*)`, `Bash(vitest*)`, `Bash(eslint*)`, `Bash(tsc*)`
   - python → `Bash(python *)`, `Bash(python3 *)`, `Bash(pip *)`, `Bash(pytest*)`, `Bash(ruff*)`, `Bash(mypy*)`, `Bash(black*)`
   - rust → `Bash(cargo *)`, `Bash(rustc*)`
   - go → `Bash(go *)`, `Bash(gofmt*)`
   - flutter → `Bash(flutter *)`, `Bash(dart *)`, `Bash(adb *)`

4. **NUNCA incluyas en la allowlist** (deben seguir pidiendo confirmación):
   - `Bash(sudo *)`, `Bash(rm *)`, `Bash(rm -rf*)`, `Bash(chmod *)`, `Bash(chown *)`
   - `Bash(curl *)`, `Bash(wget *)` apuntando fuera, ni `... | bash`/`| sh`
   - Nada que toque `~/.ssh`, `.env`, credenciales, claves, ni `git push`/`git reset --hard`.
   Estos se quedan fuera **a propósito**: la potencia no vale una catástrofe.

5. **Valida** el JSON: `python3 -c "import json;json.load(open('.claude/settings.json'))"`.

## Resumen final (máx. ~100 palabras)
- **Proyecto**: confianza confirmada / detenido por seguridad.
- **Stack**: detectado.
- **Allowlist**: N reglas añadidas; destructivas excluidas a propósito.
- **Efecto**: Claude ya trabaja con mínima fricción aquí. Reinicia la sesión si las reglas no aplican de inmediato.
