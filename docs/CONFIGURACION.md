# Configuración de Uso — 3 Modos

Apuntex se puede usar de 3 formas según la preferencia de cada quien. Elige la
que más se ajuste a tu flujo. No necesitas usar más de una.

---

## Modo 1 — Skill (invocación explícita)

**Mejor para:** uso ocasional y controlado. Tú decides cuándo activar el protocolo.

```bash
# En el chat de opencode:
/skill apuntex /ruta/imagen.png
/skill apuntex foto.png --formato=markdown --fase=1
```

### Instalación

```bash
# Copiar la skill al proyecto
mkdir -p .opencode/skills
cp -r <repo>/.opencode/skills/apuntex .opencode/skills/
```

---

## Modo 2 — Agent por defecto (automático)

**Mejor para:** proyectos donde **todo** es transcripción. Cualquier mensaje
(incluida una imagen arrastrada) va directo al agente `apuntex`.

### Instalación

```bash
# Copiar el agente al proyecto
mkdir -p .opencode/agent
cp <repo>/.opencode/agent/apuntex.md .opencode/agent/
```

### Activar en `opencode.json` del proyecto

```json
{
  "$schema": "https://opencode.ai/config.json",
  "default_agent": "apuntex",
  "agent": {
    "apuntex": {
      "mode": "primary",
      "model": "opencode/mimo-v2.5-free"
    }
  }
}
```

> **Nota:** en este modo el agente atiende **todo** en el proyecto (preguntas,
> bash, etc.), siguiendo el protocolo faseado para imágenes.

---

## Modo 3 — Comando `/tex` (alias corto)

**Mejor para:** quienes quieren un atajo manual sin cambiar el agente por defecto.

### Instalación

```bash
mkdir -p .opencode/command
cp <repo>/.opencode/command/tex.md .opencode/command/
```

### Uso

```bash
/tex /ruta/imagen.png
/tex foto_pizarra.jpg --formato=markdown
```

El comando invoca automáticamente al agente `apuntex`.

---

## Tabla de decisión

| Tu caso de uso | Modo recomendado |
|----------------|------------------|
| Transcripción ocasional, invocada a demanda | **Skill** (`/skill apuntex`) |
| Proyecto 100% apuntes/transcripción | **Agent por defecto** |
| Quiero atajo manual corto | **Comando** `/tex` |
| Quiero compatibilidad multi-agente (Claude/Codex) | **Skill** (el protocolo es portable) |

---

## Configuración compartida

Los 3 modos leen la **misma** configuración del proyecto: `.apuntexrc.json`.
Ver `docs/PERSONALIZACION.md`.

## Recordatorio

Tras copiar cualquier archivo de configuración (skill/agent/command), **reiniciar
opencode** para que se cargue.