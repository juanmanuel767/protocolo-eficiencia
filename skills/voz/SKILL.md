---
name: voz
description: Da voz a EMMA — lee en voz alta las respuestas o confirmaciones usando el motor de texto a voz del sistema. Úsala cuando el usuario invoque /voz, pida "respóndeme hablando", "léelo en voz alta" o quiera operar con manos libres.
---

# Voz de EMMA (/voz)

Hace que EMMA **hable**: convierte texto en voz con el motor TTS del sistema (español por defecto). Útil para manos libres, confirmaciones y el factor JARVIS.

## Hablar
```bash
~/.claude/bin/voz.sh hablar "La operación se ha completado con éxito, señor"
~/.claude/bin/voz.sh motor      # comprueba qué motor de voz hay instalado
```
Usa el primer motor disponible: `spd-say` → `espeak-ng` → `espeak` → `festival`.
Si no hay ninguno: `sudo apt-get install -y espeak-ng`.

## Cómo usarlo en una sesión
- Cuando el usuario active `/voz`, **resume tus respuestas en voz** además de escribirlas: tras completar una acción, llama al helper con una frase corta y natural (sin markdown, sin asteriscos, sin listas) — coherente con el modo voz de EMMA.
- Para confirmaciones: `voz.sh hablar "Entendido, señor. Iniciando."`
- Mantén lo hablado **breve**; el detalle largo déjalo en el texto.

## Entrada por voz (dictado)
Claude Code no captura el micrófono directamente. Para dictar:
- Usa el dictado del sistema operativo, **o**
- Si tienes `whisper`/`whisper.cpp`, graba y transcribe a texto y pégalo. (Configuración avanzada, opcional.)

El valor inmediato y garantizado de esta skill es la **salida hablada** (EMMA responde con voz).

## Reglas
- En modo voz: frases concisas, naturales, **sin** markdown ni símbolos que no se pronuncian.
- No leas en voz alta secretos, contraseñas ni datos sensibles.
- Español por defecto; cambia de idioma solo si el usuario lo pide.

## Resumen final
Confirma que la voz quedó activa y cómo silenciarla (dejar de llamar al helper).
