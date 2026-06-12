---
name: ahorro
description: Auditoría de eficiencia de tokens de la sesión y configuración de Claude Code. Úsala cuando el usuario invoque /ahorro o pregunte por consumo de tokens, coste de la sesión o cómo optimizar el contexto.
---

# Auditoría de eficiencia de tokens

Cuando se invoque esta skill, realiza una auditoría rápida y devuelve un informe breve. No leas archivos enteros; usa comandos puntuales.

## Pasos

1. **Peso del contexto fijo** — mide lo que se carga en cada sesión:
   ```bash
   wc -c ~/.claude/CLAUDE.md ./CLAUDE.md 2>/dev/null
   ```
   Regla aproximada: 4 caracteres ≈ 1 token. Si el total supera ~8 KB (~2.000 tokens), señala qué secciones podrían moverse a una skill (carga bajo demanda).

2. **Servidores MCP activos** — revisa `mcpServers` en `~/.claude/settings.json` y `.mcp.json` del proyecto. Cada servidor añade sus definiciones de herramientas al contexto. Si hay alguno que claramente no aplica al trabajo actual, recomienda desactivarlo para la sesión.

3. **Estado de la conversación actual** — evalúa cualitativamente:
   - ¿Hay tareas no relacionadas mezcladas? → recomendar `/clear` al cambiar de tema.
   - ¿La tarea actual es larga y hay una pausa natural? → recomendar `/compact` ahora, con instrucción de qué conservar (p. ej. `/compact conserva las decisiones de diseño y los archivos modificados`).

4. **Hábitos** — si durante la sesión se han leído muchos archivos directamente en el contexto principal, recuerda que el subagente `explorador` existe para eso.

## Formato del informe

Máximo ~150 palabras:
- **Contexto fijo**: X KB (~Y tokens por sesión) — OK / recortable (qué).
- **MCP**: N servidores activos — cuáles sobran, si aplica.
- **Recomendación inmediata**: la única acción de mayor impacto ahora mismo.
