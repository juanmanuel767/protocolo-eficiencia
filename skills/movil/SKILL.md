---
name: movil
description: Ver y controlar el teléfono Android del usuario por cable USB. Úsala cuando el usuario invoque /movil o quiera que Claude vea su pantalla, maneje el teléfono (tocar, escribir, deslizar, abrir apps, botones) o construya y pruebe una app directamente en su dispositivo real.
---

# Control del móvil por USB (/movil)

Claude **ve** y **controla** el teléfono Android del usuario conectado por cable, vía `adb`. Funciona en **cualquier Android** con depuración USB activada — no depende del puerto de depuración de las apps (que muchos teléfonos bloquean).

Dos capacidades, demostradas y robustas:
- 👁️ **VER**: capturar la pantalla y analizarla con visión.
- 🎮 **CONTROLAR**: tocar, escribir, deslizar, pulsar botones, abrir apps.

## 1. Verifica la conexión (una pasada)
```bash
export PATH="$PATH:/snap/bin"
adb devices
```
- **Vacío** → guía al usuario: Ajustes → *Acerca del teléfono* → toca 7× "Número de compilación" → *Opciones de desarrollador* → activa **Depuración USB** → conecta el cable → acepta el aviso. Si aun así no aparece, en la notificación USB del teléfono cambia el modo de "Solo carga" a **"Transferencia de archivos (MTP)"**.

## 2. VER la pantalla
```bash
adb exec-out screencap -p > /tmp/movil.png
```
Después lee `/tmp/movil.png` con la herramienta **Read** (visión nativa). Repite la captura cada vez que necesites ver el estado actual. La imagen tiene la **resolución real** del teléfono (p. ej. 1080×2392); usa esas coordenadas para tocar.

## 3. CONTROLAR
| Acción | Comando |
|---|---|
| Tocar en (X,Y) | `adb shell input tap X Y` |
| Escribir texto | `adb shell input text 'hola'` (espacios → `%s`) |
| Deslizar | `adb shell input swipe X1 Y1 X2 Y2 [ms]` |
| Inicio / Atrás / Recientes | `adb shell input keyevent KEYCODE_HOME` · `KEYCODE_BACK` · `KEYCODE_APP_SWITCH` |
| Abrir app | `adb shell monkey -p <paquete> -c android.intent.category.LAUNCHER 1` |
| Listar apps | `adb shell pm list packages` |

> Atajo: el helper `~/.claude/bin/movil.sh` envuelve todo esto — `movil.sh ver`, `movil.sh tap X Y`, `movil.sh texto "hola"`, `movil.sh inicio`, etc.

## Bucle ver → actuar → ver
1. **Captura** y mira la pantalla.
2. **Ejecuta una acción** (un toque/escritura a la vez).
3. **Vuelve a capturar** para confirmar el efecto. Repite hasta lograr el objetivo.

## Construir y probar una app (opcional, Flutter)
- Crear: `flutter create <nombre>`; instalar y abrir: `flutter run -d <device>` o `flutter build apk --debug && adb install -r build/app/outputs/flutter-apk/app-debug.apk`.
- **Hot reload** (`r`) si el teléfono lo permite. Si se queda en `Waiting for VM Service port...` (algunos OEM lo bloquean: Nubia/RedMagic, MIUI), **no insistas**: reinstala el APK y prueba la app con el bucle ver→controlar de arriba — igual de efectivo.

## Reglas de seguridad
- Es el teléfono **real** del usuario. **Confirma antes** de acciones sensibles: borrar, comprar, enviar mensajes, pagos, banca, cambiar ajustes del sistema.
- **Nunca** toques contraseñas, banca ni medios de pago sin permiso explícito en ese momento.
- Una acción a la vez; verifica con captura antes de la siguiente.
- Android por USB. iPhone requiere Mac + Xcode.

## Resumen al terminar
Qué se vio/hizo y cómo retomarlo (`movil.sh ver`).
