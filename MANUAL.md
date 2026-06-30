# 📖 Manual del Protocolo de Eficiencia

Bienvenido. Este kit añade a Claude Code **superpoderes** (ahorro de tokens, ingeniería avanzada y control de tu teléfono Android) y se activa solo. Aquí tienes qué hace cada pieza y cómo usarla.

---

## 🤖 Subagentes (trabajan solos, en segundo plano)

| Subagente | Para qué sirve | Beneficio |
|---|---|---|
| **explorador** (Haiku) | Lee y busca por el código base en contexto aislado. | **Ahorra dinero**: lee 20 archivos y devuelve solo conclusiones; esas lecturas no pesan en tu conversación. |
| **revisor** (Sonnet) | Revisa código, audita y compara enfoques. | Te devuelve solo los hallazgos ordenados por severidad; el trabajo intermedio se descarta. |

> Se invocan automáticamente cuando una tarea requiere leer >3 archivos. También puedes pedirlos: *"usa el explorador para localizar…"*.

---

## ⚡ Skills (comandos que escribes con `/`)

| Comando | Qué hace | Cuándo usarlo |
|---|---|---|
| **/arranque** | Prepara un proyecto nuevo: detecta el stack, crea permisos locales y un CLAUDE.md breve. | Lo primero al abrir un proyecto (se ofrece solo). |
| **/ahorro** | Audita cuánto gasta la sesión y te dice el ajuste de mayor impacto. | Cuando quieras reducir el consumo de tokens. |
| **/memoria** | **Memoria persistente del proyecto** (`.claude/memoria/`): mapa del código + decisiones, convenciones y pendientes. No olvida nada por grande que sea el proyecto; se carga sola cada sesión. | Proyectos grandes o de larga duración. |
| **/movil** | **Claude VE y CONTROLA tu Android por USB**: captura tu pantalla, toca, escribe, desliza, abre apps; también construye y prueba apps en el teléfono real. | Automatizar el móvil, probar apps, manos libres. |
| **/seguridad** | Auditoría **defensiva** antes de subir a git: secretos filtrados, archivos sensibles, dependencias vulnerables. | Siempre antes de un push o publicar. |
| **/commit** | Analiza el diff y redacta un mensaje de commit **convencional**; crea el commit (sin push). | Cada vez que guardas cambios. |
| **/pruebas** | Detecta el framework, corre los tests y **genera los que faltan**. | Verificar que el código funciona. |
| **/voz** | Da **voz** a EMMA: lee las respuestas en voz alta (manos libres, estilo JARVIS). | Trabajar sin mirar la pantalla. |
| **/super** | Modo máxima capacidad en un proyecto de **confianza**: trabaja sin interrupciones de permisos (bloqueando lo destructivo). | En tu propio código, para fluir sin fricción. |
| **/ultra** | Modo de **ingeniería avanzada**: análisis multi-perspectiva, código limpio, soluciones completas y verificadas. | Tareas complejas que exigen máxima calidad. |

---

## 🔄 Automático (sin que pidas nada)

- **Auto-activación**: al abrir un proyecto nuevo sin configurar, Claude ejecuta `/arranque` solo.
- **Reglas de eficiencia** (en `~/.claude/CLAUDE.md`): delegar exploraciones grandes, no narrar acciones rutinarias, lecturas quirúrgicas y resúmenes breves — en **todas** tus sesiones.

---

## 📱 Cómo usar `/movil` (ver y controlar tu teléfono)

1. Activa **Depuración USB** en el teléfono (Ajustes → Acerca del teléfono → toca 7× "Número de compilación" → Opciones de desarrollador → Depuración USB).
2. Conecta el cable y acepta el aviso.
3. Escribe `/movil` o pide: *"mira mi teléfono y abre WhatsApp"*. Claude capturará tu pantalla, la verá y actuará.

> `adb` queda instalado y autorizado por el instalador: cero fricción.

---

## 🧭 Buenas costumbres

- `/compact` en pausas de tareas largas; `/clear` al cambiar de tema.
- Sé específico en lo que pides: un encargo vago cuesta una expedición de lecturas.
- Desactiva los servidores MCP que no uses en la sesión.

---

**¿Listo?** Escribe `/movil` para que Claude vea tu teléfono, o abre un proyecto y deja que `/arranque` lo configure solo.
