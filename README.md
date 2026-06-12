# Protocolo de Eficiencia para Claude Code

Sistema de ahorro de tokens para Claude Code en proyectos grandes. Reduce el consumo delegando la exploración de código a subagentes baratos con contexto aislado, recortando la narración innecesaria y manteniendo delgado el contexto fijo.

## Piezas

| Archivo | Destino | Qué hace |
|---|---|---|
| `agents/explorador.md` | `~/.claude/agents/` | Subagente de exploración con Haiku (~5× más barato). Devuelve solo conclusiones y rutas, nunca volcados de archivos. |
| `agents/revisor.md` | `~/.claude/agents/` | Subagente de revisión con Sonnet. Hallazgos por severidad; el trabajo intermedio se descarta fuera del contexto principal. |
| `skills/ahorro/SKILL.md` | `~/.claude/skills/ahorro/` | Skill `/ahorro`: audita el peso del contexto fijo, los MCP activos y recomienda la acción de mayor impacto. |
| `CLAUDE-snippet.md` | pegar en `~/.claude/CLAUDE.md` | Reglas permanentes: delegar exploraciones >3 archivos, silencio entre herramientas, lecturas quirúrgicas, resúmenes breves. |

## Instalación

```bash
mkdir -p ~/.claude/agents ~/.claude/skills/ahorro
cp agents/*.md ~/.claude/agents/
cp skills/ahorro/SKILL.md ~/.claude/skills/ahorro/
cat CLAUDE-snippet.md >> ~/.claude/CLAUDE.md
```

Opcional: añadir en `~/.claude/settings.json` una allowlist de comandos de solo lectura (`git status/log/diff`, `ls`, `grep`, `rg`, `find`, `wc`, `head`, `tail`) para eliminar interrupciones de permisos.

## Hábitos que completan el sistema

- `/compact` en pausas naturales de tareas largas; `/clear` al cambiar de tema.
- Prompts específicos: un encargo vago cuesta una expedición entera de lecturas.
- Desactivar servidores MCP que no apliquen al trabajo de la sesión.
- En proyectos grandes, generar un grafo de conocimiento (p. ej. graphify) y consultarlo en vez de releer archivos.
