---
name: pruebas
description: Detecta el framework de pruebas del proyecto, ejecuta los tests y genera los que falten. Úsala cuando el usuario invoque /pruebas, pida "escribe tests", "corre las pruebas", "añade cobertura" o quiera verificar que el código funciona.
---

# Pruebas automáticas (/pruebas)

Detecta el framework de tests, ejecuta lo que haya y **escribe los tests que faltan**.

## 1. Detecta y corre lo existente
```bash
~/.claude/bin/pruebas.sh            # detecta el framework y ejecuta
~/.claude/bin/pruebas.sh detectar   # solo dice qué framework hay
```
Soporta: `npm test` (Node), `pytest` (Python), `cargo test` (Rust), `go test` (Go), `flutter test` (Flutter).

## 2. Lee el resultado
- ✅ Todo verde → informa y, si el usuario quiere, pasa a generar tests para lo no cubierto.
- ❌ Fallos → muestra el test que falla y la causa raíz; propón la corrección (no parchees el test para ocultar el fallo).

## 3. Genera los tests que faltan
1. Identifica funciones/módulos **sin cobertura** (delega la exploración al subagente `explorador` si el proyecto es grande).
2. Escribe tests siguiendo el **estilo y framework ya presentes** en el proyecto (mira los tests existentes antes de inventar uno nuevo).
3. Cubre: el caso normal, los **bordes** (vacío, nulo, límites) y los **errores** esperados.
4. Vuelve a correr con el helper y confirma que pasan.

## Reglas
- **Tests que prueban de verdad**: nada de `assert true` ni mocks que tapan el comportamiento real.
- Un test = un comportamiento; nombres descriptivos de lo que verifican.
- No bajes la exigencia del test para que "pase"; si el código está mal, arregla el código.
- Mantén los tests rápidos y deterministas (sin depender de red/reloj salvo que sea el objetivo).

## Resumen final
Tests ejecutados (pasan/fallan), cobertura añadida y cómo volver a correrlos (`~/.claude/bin/pruebas.sh`).
