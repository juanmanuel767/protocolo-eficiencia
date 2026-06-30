---
name: commit
description: Genera un mensaje de commit claro y convencional analizando los cambios, y crea el commit. Úsala cuando el usuario invoque /commit, pida "haz commit", "guarda los cambios" o quiera un buen mensaje para sus cambios en git.
---

# Commit perfecto (/commit)

Analiza los cambios reales y redacta un mensaje de commit **claro, convencional y útil**, luego crea el commit.

## 1. Mira qué cambió
```bash
git status --short
git diff --staged   # si no hay nada en stage, mira: git diff
```
Si no hay nada en *stage* y el usuario quiere incluir todo, propón `git add -A` (confírmalo antes).

## 2. Redacta el mensaje (Conventional Commits)
Formato: `tipo(ámbito): resumen en imperativo`
- **tipos**: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`, `style`, `build`, `ci`.
- **resumen**: ≤ 50 caracteres, en imperativo ("añade", "corrige"), sin punto final.
- **cuerpo** (si aporta): el *porqué* del cambio, no el *qué* (eso ya está en el diff). Una línea en blanco lo separa del resumen.

Ejemplo:
```
feat(auth): añade inicio de sesión con Google

Permite autenticarse sin crear contraseña. Reduce la fricción
de registro detectada en las pruebas con usuarios.
```

## 3. Crea el commit
```bash
git commit -m "tipo(ámbito): resumen" -m "cuerpo opcional"
```

## Reglas
- **Un commit = un cambio lógico.** Si el diff mezcla cosas no relacionadas, sugiere separarlas en varios commits.
- **No hagas `git push`** salvo que el usuario lo pida explícitamente.
- Respeta el estilo de mensajes ya presente en `git log` si el repo tiene una convención propia.
- Antes de commitear, si hay riesgo de secretos, sugiere pasar `/seguridad`.

## Resumen final
El mensaje creado y el hash del commit. Recuerda que el push queda a decisión del usuario.
