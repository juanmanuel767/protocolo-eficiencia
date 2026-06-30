# Protocolo de Eficiencia para Claude Code

🌍 **Español** · [English](README.en.md)

Sistema de ahorro de tokens para Claude Code en proyectos grandes. Reduce el consumo delegando la exploración de código a subagentes baratos con contexto aislado, recortando la narración innecesaria y manteniendo delgado el contexto fijo que se carga en cada sesión.

## Piezas

| Archivo | Destino | Qué hace |
|---|---|---|
| `agents/explorador.md` | `~/.claude/agents/` | Subagente de exploración con Haiku (~5× más barato). Devuelve solo conclusiones y rutas (`ruta:línea`), nunca volcados de archivos. |
| `agents/revisor.md` | `~/.claude/agents/` | Subagente de revisión con Sonnet. Hallazgos ordenados por severidad; el trabajo intermedio (diffs, lecturas, tests) se descarta fuera del contexto principal. |
| `skills/ahorro/SKILL.md` | `~/.claude/skills/ahorro/` | Comando `/ahorro`: audita el peso del contexto fijo, los MCP activos y recomienda la acción de mayor impacto. |
| `skills/arranque/SKILL.md` | `~/.claude/skills/arranque/` | Comando `/arranque`: prepara un proyecto nuevo (detecta el stack, crea `.claude/settings.json` local, genera un CLAUDE.md breve y ofrece grafo de conocimiento). |
| `skills/movil/SKILL.md` | `~/.claude/skills/movil/` | Comando `/movil`: Claude **ve y controla** tu teléfono Android por USB (captura de pantalla + toques/escritura/deslizar). Funciona en cualquier Android; también construye y prueba apps en el dispositivo real. |
| `bin/movil.sh` | `~/.claude/bin/` | Helper de la skill `/movil`: `ver`, `tap`, `texto`, `desliza`, `inicio`, `atras`, `abrir`, `apps`. |
| `skills/memoria/SKILL.md` | `~/.claude/skills/memoria/` | Comando `/memoria`: **memoria persistente del proyecto** (`.claude/memoria/`) — índice-mapa del código + decisiones, convenciones y pendientes. Escala a cualquier tamaño (guarda resúmenes) y se carga sola en cada sesión. |
| `skills/seguridad/SKILL.md` + `bin/seguridad.sh` | `~/.claude/…` | Comando `/seguridad`: auditoría **defensiva** antes de subir a git — secretos/credenciales filtradas, archivos sensibles versionados y dependencias vulnerables. |
| `skills/commit/SKILL.md` | `~/.claude/skills/commit/` | Comando `/commit`: analiza el diff y redacta un mensaje **convencional** claro, luego crea el commit (sin push). |
| `skills/pruebas/SKILL.md` + `bin/pruebas.sh` | `~/.claude/…` | Comando `/pruebas`: detecta el framework (npm/pytest/cargo/go/flutter), corre los tests y **genera los que faltan**. |
| `skills/voz/SKILL.md` + `bin/voz.sh` | `~/.claude/…` | Comando `/voz`: da voz a EMMA — lee las respuestas en voz alta con el motor TTS del sistema (manos libres). |
| `skills/super/SKILL.md` | `~/.claude/skills/super/` | Comando `/super`: modo máxima capacidad en un proyecto de confianza — allowlist amplia para trabajar sin interrupciones de permisos, manteniendo bloqueados los comandos destructivos. |
| `skills/ultra/SKILL.md` | `~/.claude/skills/ultra/` | Comando `/ultra`: modo de ingeniería avanzada — análisis multi-perspectiva, descomposición, código limpio y modular, y entrega verificada lista para usar. |
| `CLAUDE-snippet.md` | pegar en `~/.claude/CLAUDE.md` | Reglas permanentes: delegar exploraciones >3 archivos, silencio entre herramientas, lecturas quirúrgicas, resúmenes breves. |

## Instalación (un solo comando)

```bash
git clone https://github.com/juanmanuel767/protocolo-eficiencia.git
cd protocolo-eficiencia
./install.sh
```

Eso es todo. El instalador es **idempotente** (seguro de ejecutar varias veces, no duplica nada) e instala:

- Los subagentes `explorador` y `revisor`.
- Las skills `/arranque`, `/ahorro`, `/movil`, `/super` y `/ultra`.
- Las reglas de eficiencia en `~/.claude/CLAUDE.md` (solo si no estaban ya).
- Un **hook de auto-activación** (`SessionStart`): al abrir cualquier **proyecto nuevo sin configurar**, Claude ejecutará `/arranque` automáticamente y aplicará el protocolo, sin que tengas que pedirlo.
- **`adb` instalado y autorizado** (`Bash(adb *)` en `settings.json`): la skill `/movil` queda lista para que Claude **vea y controle tu Android** por USB sin pedir permisos a cada paso.

Para revertir todo: `./uninstall.sh`.

> Reinicia Claude Code tras instalar para que cargue agentes, skills y el hook.

Opcional: fusionar `settings-snippet.json` en tu `~/.claude/settings.json` para una allowlist de comandos de solo lectura y eliminar interrupciones de permisos.

## Uso

| Comando | Cuándo |
|---|---|
| `/arranque` | Lo primero al abrir un proyecto nuevo. Lo deja configurado para máxima eficiencia. |
| `/ahorro` | En cualquier momento, para auditar el gasto de la sesión y recibir la recomendación de mayor impacto. |
| (automático) | Los subagentes `explorador` y `revisor` se invocan solos según las reglas del `CLAUDE-snippet.md`; también puedes pedirlos explícitamente. |

## Hábitos que completan el sistema

- `/compact` en pausas naturales de tareas largas; `/clear` al cambiar de tema.
- Prompts específicos: un encargo vago cuesta una expedición entera de lecturas.
- Desactivar servidores MCP que no apliquen al trabajo de la sesión.
- En proyectos grandes, generar un grafo de conocimiento (p. ej. graphify) y consultarlo en vez de releer archivos.

## Por qué funciona

- **Contexto aislado:** un subagente lee 20 archivos y devuelve 200 palabras; esas 20 lecturas nunca pesan en tu conversación principal.
- **Modelo por tarea:** explorar con Haiku y revisar con Sonnet cuesta una fracción de hacerlo todo con el modelo principal.
- **Contexto fijo delgado:** cada token del CLAUDE.md se paga en *cada* mensaje de *cada* sesión. Mantenerlo breve es el ahorro que más se multiplica.
