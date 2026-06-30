# Registro de cambios

## [0.8.0] — 2026-06-29
### Añadido
- **Skill `/seguridad`** + `bin/seguridad.sh`: auditoría defensiva local antes de subir a git — escanea secretos/credenciales, archivos sensibles versionados, protección de `.gitignore` y dependencias vulnerables (npm/pip/cargo). Solo lectura.
- **Skill `/commit`**: analiza el diff y redacta un mensaje de commit convencional (`tipo(ámbito): resumen`), luego crea el commit. No hace push.
- **Skill `/pruebas`** + `bin/pruebas.sh`: detecta el framework (npm, pytest, cargo, go, flutter), ejecuta los tests y guía la generación de los que faltan.
- **Skill `/voz`** + `bin/voz.sh`: salida hablada (TTS) para EMMA usando el motor del sistema (spd-say/espeak-ng/espeak/festival).
- `install.sh` instala el motor de voz `espeak-ng` si falta (best-effort).

## [0.7.0] — 2026-06-29
### Añadido
- **Skill `/memoria`** (`skills/memoria/`): memoria persistente del proyecto en `.claude/memoria/` (índice-mapa del código + decisiones, convenciones, pendientes y glosario). Guarda **resúmenes, no volcados**, así que escala a proyectos de cualquier tamaño sin releerlos. Se versiona con git y viaja con el repo.
- **Auto-carga de memoria**: el hook `SessionStart` detecta `.claude/memoria/INDICE.md` y obliga a Claude a leer la memoria antes de trabajar — para que no se le escape nada del proyecto.

## [0.6.0] — 2026-06-29
### Cambiado
- **Skill `/movil` reenfocada**: de "hot reload de Flutter" a **"Claude ve y controla tu Android por USB"** (captura de pantalla con `adb exec-out screencap` + control con `adb shell input`: tocar, escribir, deslizar, botones, abrir apps). Funciona en **cualquier Android**, sin depender del puerto de servicio VM que muchos teléfonos (Nubia/RedMagic, MIUI) bloquean. El hot reload queda como extra opcional.
- **`bin/movil.sh`** reescrito como helper de control (`ver`, `tap`, `texto`, `desliza`, `inicio`, `atras`, `recientes`, `abrir`, `apps`, `estado`).
### Añadido
- **Configuración de un solo comando para `/movil`**: `install.sh` ahora instala `adb` si falta (best-effort vía apt), copia los helpers a `~/.claude/bin/` y **autoriza `Bash(adb *)`** en `settings.json` — la habilidad queda lista de fábrica, sin fricción de permisos.
- `uninstall.sh` revierte el helper y el permiso de `adb`.

## [0.5.0] — 2026-06-28
### Añadido
- **Skill `/super`** (`skills/super/`): modo máxima capacidad para proyectos de confianza — configura una allowlist amplia (git, gestores de paquetes, build, test) para trabajar sin fricción de permisos, dejando fuera a propósito los comandos destructivos (sudo, rm, push, credenciales).
- **Skill `/ultra`** (`skills/ultra/`): modo de ingeniería avanzada de alto rendimiento (análisis multi-perspectiva, descomposición, código limpio, control de calidad y entrega lista para aplicar).

## [0.4.0] — 2026-06-28
### Añadido
- **Skill `/movil`** (`skills/movil/`): desarrollo de apps móviles en vivo con Flutter hot reload — construir/editar una app y verla cambiar en el teléfono Android real al instante. Incluye `bin/movil.sh` (lanzador que detecta el dispositivo y arranca `flutter run`).
- `install.sh` ahora copia todas las skills de forma genérica (futuras incluidas).

## [0.3.0] — 2026-06-28
### Añadido
- **Auto-activación** (`hooks/auto-arranque.sh`): hook `SessionStart` que detecta proyectos nuevos sin configurar y hace que Claude ejecute `/arranque` y aplique el protocolo automáticamente.
- `install.sh` ahora instala TODO con un solo comando, incluido el registro del hook en `settings.json` (merge seguro e idempotente).
### Cambiado
- `uninstall.sh` también elimina el hook y su entrada en `settings.json`.

## [0.2.0] — 2026-06-28
### Añadido
- `install.sh` — instalador **idempotente** que no duplica el snippet en `CLAUDE.md` (corrige el problema de `cat >>` al reinstalar).
- `uninstall.sh` — desinstalador limpio (elimina agentes, skills y el bloque de reglas vía marcadores).
- `LICENSE` — licencia MIT.
- `settings-snippet.json` — allowlist de permisos de solo lectura, lista para copiar.

### Cambiado
- README: la instalación ahora recomienda `./install.sh` en lugar de los comandos manuales.

## [0.1.0] — versión inicial
- Subagentes `explorador` (Haiku) y `revisor` (Sonnet).
- Skills `/ahorro` y `/arranque`.
- `CLAUDE-snippet.md` con las reglas permanentes de eficiencia.
