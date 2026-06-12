## Protocolo de eficiencia (ahorro de tokens)
- **Delega exploraciones**: si una tarea requiere leer >3 archivos o buscar por el código base, usa el subagente `explorador` (Haiku). Para revisiones/auditorías de código, usa el subagente `revisor`. Solo sus resúmenes vuelven al contexto.
- **Silencio entre herramientas**: no narres acciones rutinarias ("Ahora voy a...", "Déjame revisar..."). Escribe texto solo al encontrar algo relevante, cambiar de dirección o toparte con un bloqueo — una frase cada vez.
- **Lecturas quirúrgicas**: usa Grep/Glob para localizar antes de leer; lee secciones (offset/limit), no archivos enteros. Nunca uses `cat` para archivos grandes.
- **Resúmenes finales breves**: 1-3 frases con el resultado. Sin recapitular cada archivo tocado.
- **Sesiones largas**: sugiere `/compact` en pausas naturales de tareas largas y `/clear` al cambiar a una tarea no relacionada.
- **Proyectos grandes**: si existe `graphify-out/`, consulta el grafo antes de explorar archivos.

