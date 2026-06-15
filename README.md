# Protocolo de Eficiencia para Claude Code

Sistema de ahorro de tokens para Claude Code en proyectos grandes. Reduce el consumo delegando la exploración de código a subagentes baratos con contexto aislado, recortando la narración innecesaria y manteniendo delgado el contexto fijo que se carga en cada sesión.

## Piezas

| Archivo | Destino | Qué hace |
|---|---|---|
| `agents/explorador.md` | `~/.claude/agents/` | Subagente de exploración con Haiku (~5× más barato). Devuelve solo conclusiones y rutas (`ruta:línea`), nunca volcados de archivos. |
| `agents/revisor.md` | `~/.claude/agents/` | Subagente de revisión con Sonnet. Hallazgos ordenados por severidad; el trabajo intermedio (diffs, lecturas, tests) se descarta fuera del contexto principal. |
| `skills/ahorro/SKILL.md` | `~/.claude/skills/ahorro/` | Comando `/ahorro`: audita el peso del contexto fijo, los MCP activos y recomienda la acción de mayor impacto. |
| `skills/arranque/SKILL.md` | `~/.claude/skills/arranque/` | Comando `/arranque`: prepara un proyecto nuevo (detecta el stack, crea `.claude/settings.json` local, genera un CLAUDE.md breve y ofrece grafo de conocimiento). |
| `CLAUDE-snippet.md` | pegar en `~/.claude/CLAUDE.md` | Reglas permanentes: delegar exploraciones >3 archivos, silencio entre herramientas, lecturas quirúrgicas, resúmenes breves. |

## Instalación

```bash
mkdir -p ~/.claude/agents ~/.claude/skills/ahorro ~/.claude/skills/arranque
cp agents/*.md ~/.claude/agents/
cp skills/ahorro/SKILL.md ~/.claude/skills/ahorro/
cp skills/arranque/SKILL.md ~/.claude/skills/arranque/
cat CLAUDE-snippet.md >> ~/.claude/CLAUDE.md
```

Opcional pero recomendado: añadir en `~/.claude/settings.json` una allowlist de comandos de solo lectura (`git status/log/diff`, `ls`, `grep`, `rg`, `find`, `wc`, `head`, `tail`) para eliminar las interrupciones de permisos durante la exploración.

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
