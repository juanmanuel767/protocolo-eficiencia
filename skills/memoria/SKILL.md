---
name: memoria
description: Memoria persistente del proyecto — Claude recuerda todo (mapa del código, decisiones, convenciones, pendientes) sin importar lo grande que sea el proyecto, sin que se le escape nada. Úsala cuando el usuario invoque /memoria, quiera que Claude no olvide el contexto de un proyecto grande, o pida construir/actualizar el índice del proyecto.
---

# Memoria persistente del proyecto (/memoria)

Da a Claude **memoria de largo plazo** de un proyecto: un índice-mapa de todo el código + notas de decisiones, convenciones y pendientes, guardado en `.claude/memoria/` y consultado en **cada sesión**. Funciona en proyectos de **cualquier tamaño** porque guarda **resúmenes** (no el contenido entero): un repo gigante se reduce a un mapa que sí cabe en contexto y se puede consultar sin releerlo.

## Estructura (`.claude/memoria/`)
```
INDICE.md        → mapa del proyecto: por módulo/carpeta, una línea por archivo clave (ruta → qué hace)
decisiones.md    → decisiones de diseño y su PORQUÉ (lo que el código no cuenta)
convenciones.md  → estilo, patrones, nombres, comandos de build/test del proyecto
pendientes.md    → tareas en curso, objetivos y bloqueos
glosario.md      → términos del dominio del proyecto
```

## 1. Construir el índice (primera vez)
- **Proyecto grande (>30 archivos)**: delega al subagente **explorador** (Haiku) que recorra el repo y devuelva, por módulo, **una línea por archivo importante** (`ruta → propósito`). Así el coste es mínimo y no inflas el contexto principal.
- Si existe `graphify-out/`, úsalo como fuente: ya es un grafo del proyecto.
- Escribe el resultado en `INDICE.md`, **agrupado por carpeta/módulo**.

## 2. Mantenerla viva — la clave para que "no se le escape nada"
**En el momento** en que ocurra, añade UNA línea:
- Tomas una decisión de diseño → `decisiones.md` (qué y por qué).
- Detectas una convención o comando del proyecto → `convenciones.md`.
- Empiezas/terminas una tarea o te topas con un bloqueo → `pendientes.md`.
- Creas/cambias/borras un archivo importante → actualiza su línea en `INDICE.md`.
No lo dejes para el final: la memoria que se actualiza al vuelo es la que no pierde nada.

## 3. Consultar ANTES de explorar
Antes de leer archivos a ciegas, mira `INDICE.md` para saber **dónde** vive lo que buscas. Evitas releer el proyecto entero y el contexto no se degrada.

## Escala a cualquier tamaño
- Guarda **resúmenes, no volcados**. 5.000 archivos → 5.000 líneas de índice: consultable, nunca se relee completo.
- Si el índice crece demasiado, **divídelo por módulo**: `INDICE.md` apunta a `INDICE-<modulo>.md` (carga solo el que necesites).
- Combínala con `graphify` para proyectos enormes: el grafo hace el trabajo pesado, la memoria guarda el porqué y los pendientes.

## Reglas
- La memoria vive en el repo (`.claude/memoria/`): se versiona con git y **viaja con el proyecto** (cualquiera que lo clone hereda la memoria).
- **Una línea por entrada**; conciso. La memoria barata de mantener es la única que se mantiene.
- Guarda el **porqué** y el **dónde**, no lo que el código ya dice de forma obvia.
- Al inicio de sesión, el hook avisa si el proyecto tiene memoria: léela antes de trabajar.

## Resumen al terminar
Qué se indexó/actualizó y dónde quedó.
