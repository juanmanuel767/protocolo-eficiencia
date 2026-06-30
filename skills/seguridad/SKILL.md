---
name: seguridad
description: Auditoría de seguridad DEFENSIVA del proyecto antes de subir a git. Úsala cuando el usuario invoque /seguridad, vaya a hacer push/publicar, o pida revisar secretos, credenciales filtradas, archivos sensibles o dependencias vulnerables. Solo defensa del propio proyecto del usuario; nunca para atacar a terceros.
---

# Auditoría de seguridad defensiva (/seguridad)

Revisa el proyecto en busca de fugas y riesgos **antes de publicarlo**. Es defensa de los activos del usuario: detectar problemas propios, nunca atacar a nadie.

## 1. Escaneo automático
```bash
~/.claude/bin/seguridad.sh
```
El helper revisa, solo lectura:
1. **Secretos / credenciales** en archivos rastreados (API keys, tokens, claves privadas, AWS/GitHub/Google/Slack…).
2. **Archivos sensibles versionados** (`.env`, `*.pem`, `*.key`, `id_rsa`, `credentials`…).
3. **Protección en `.gitignore`** (que `.env` y claves estén ignorados).
4. **Dependencias vulnerables** (`npm audit` / `pip-audit` / `cargo audit` según el stack).

## 2. Interpreta y prioriza
Reporta los hallazgos **ordenados por gravedad**:
- 🔴 **Crítico**: un secreto real o un archivo sensible ya en git → hay que actuar ya.
- 🟡 **Medio**: dependencias vulnerables, falta de `.gitignore`.
- 🟢 **Bajo**: buenas prácticas a mejorar.

## 3. Corrige (con permiso del usuario)
- Secreto en el código → muévelo a una variable de entorno / `.env` (y `.env` al `.gitignore`).
- Archivo sensible ya versionado → quítalo del seguimiento: `git rm --cached <archivo>` y añádelo a `.gitignore`.
  > ⚠️ Si un secreto ya se subió a un remoto, **avisa al usuario de que debe rotarlo** (cambiar la clave): borrarlo del repo no basta, ya quedó expuesto.
- Dependencia vulnerable → propón la versión segura (`npm audit fix`, actualizar el paquete).

## Reglas
- **Solo defensa** del proyecto del usuario. Jamás generes exploits, malware ni técnicas ofensivas contra terceros.
- No imprimas el valor completo de un secreto en claro más de lo necesario para identificarlo.
- Confirma antes de modificar el historial de git o borrar archivos.

## Resumen final
Hallazgos por gravedad, qué se corrigió y qué queda pendiente (p. ej. "rota esta clave").
