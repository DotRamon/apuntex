---
name: apuntex
description: Asistente academico que transcribe de forma fiel apuntes e imagenes (fotos, escaneos, pizarrones) a LaTeX/Markdown y los resuelve explicando paso a paso. Usar cuando el usuario suba o refiera una imagen, foto de pizarra, escaneo o ejercicio manuscrito y quiera convertirlo a un documento LaTeX o Markdown compilable.
license: MIT
compatibility: opencode, claude-code, codex-cli
metadata:
  author: DotRamon
  version: 1.0.0
tags: transcripcion, latex, markdown, multimodal, ingenieria, matematicas
---

# Apuntex — Protocolo de Transcripción Imagen → LaTeX

> Proyecto: `apuntex` · Autor: **DotRamon** · Versión 1.0.0 · Licencia MIT

## Qué hace esta skill

Apuntex es un **asistente académico**: transcribe de forma fiel **imágenes**
(fotos de pizarra, escaneos, apuntes manuscritos, diagramas) a documentos
**LaTeX** o **Markdown** estructurados y compilables, y además los **resuelve
explicando paso a paso**.

El valor **no es una herramienta específica**, sino la **transcripción fiel
más resolución tutorial** con control total del usuario: aprueba o corrige en
cada etapa.

---

## 0. Configuración por Proyecto (obligatoria leer)

### 0.1 Jerarquía de configuración

La skill se configura **por proyecto**, no de forma global. Al iniciar, el agente debe:

1. Buscar `.apuntexrc.json` en la **raíz del proyecto actual** (CWD / worktree root).
2. Si no existe, buscar `.apuntexrc.json` en `~/.config/apuntex/` (fallback global del usuario).
3. Si no existe, usar `config/defaults.json` de este repositorio.

El archivo del proyecto **tiene prioridad total** y se carga primero.
Leer siempre `config/defaults.json` como base y hacer merge con el `.apuntexrc.json`.

### 0.2 Archivos de configuración

| Archivo | Ubicación | Propósito |
|---------|-----------|-----------|
| `config/defaults.json` | Repositorio de la skill | Valores base (no editar) |
| `.apuntexrc.json` | **Raíz de cada proyecto** | Personalización por proyecto |
| `~/.config/apuntex/apuntexrc.json` | Global del usuario | Fallback personal |
| `.apuntex/hooks/*.md` | Raíz del proyecto | Hooks personalizados por proyecto |

### 0.3 Flujo de arranque (Fase 0)

```
1. Localizar .apuntexrc.json (proyecto → global → defaults)
2. Cargar config de modelos (config/models.json)
3. Detectar modelo actual en la TUI:
   - Si es multimodal  → preparar Fase 1
   - Si es solo-texto  → avisar que la interpretación de imagen requerirá
                          cambiar a multimodal (Ctrl+X) o descripción textual
4. Confirmar con el usuario qué imagen procesar y con qué parámetros
```

### 0.4 Ejemplo de `.apuntexrc.json` mínima

```json
{
  "modelos": {
    "interpretacion": "opencode/mimo-v2.5-free",
    "resolucion_texto": "opencode/deepseek-v4-flash-free",
    "compilacion": "opencode/deepseek-v4-flash-free"
  },
  "preferencias": {
    "formato_salida": "latex",
    "estilo_latex": "minimal",
    "directorio_salida": "./apuntes"
  },
  "geogebra": { "habilitado": false },
  "dominio_especifico": {
    "tipo": "general",
    "paquetes_extra": ["amsmath", "geometry"]
  }
}
```

---

## 1. FASE 1 — Interpretación y Alineación (obligatorio)

### Instrucciones al agente

1. **Analizar la imagen directamente** con el modelo multimodal activo.
   No usar bash, PIL, ni OCR: la capacidad multimodal del modelo es suficiente.
2. Extraer y transcribir:
   - Enunciado completo del ejercicio/problema.
   - Todas las fórmulas, ecuaciones y expresiones matemáticas.
   - Texto manuscrito o impreso.
   - Estructura (secciones, pasos numerados, sub-ejercicios).
   - Diagramas (tipo: circuito, geometría, gráfico, esquema) y elementos clave.
3. Marcar incertidumbres explícitamente, nunca adivinar:

```
[ILEGIBLE: posible variable de contorno]
[AMBIGUO: símbolo entre ∂ y δ]
[CORTADO: parte inferior de imagen no visible]
```

4. Presentar interpretación en formato estructurado:

```
ENUNCIADO EXTRAÍDO: ...
FÓRMULAS IDENTIFICADAS: ...
ESTRUCTURA DEL EJERCICIO: ...
DIAGRAMAS: ...
INCERTIDUMBRES: ...
```

5. **DETENERSE** y solicitar aprobación:

> "¿Es correcta esta interpretación? Responde **aprobar** para continuar,
> o indica las correcciones."

- **Aprobar** → Fase 2.
- **Corregir** → aplicar cambios y volver a presentar.
- **Abortar** → finalizar sin generar nada.

### Nota sobre el modelo

Si la Fase 1 se hace con un modelo multimodal (ej. `opencode/mimo-v2.5-free`) y la
Fase 2/3 con solo-texto, **indicar al usuario que cambie de modelo en la TUI
(Ctrl+X)** al aprobar la Fase 1, para ahorrar cuota del proveedor multimodal.
Esta transición es una recomendación del protocolo, no un requisito técnico.

---

## 2. FASE 2 — Resolución y Estructuración (tras aprobación)

### Instrucciones al agente

1. **Resolver paso a paso** el ejercicio interpretado en Fase 1:
   - Actuar como tutor académico, no copiar pasos.
   - Identificar saltos lógicos en el material original y explicarlos.
   - Añadir notas: "Aquí se aplica la ley de Kirchhoff…", "Este paso usa la
     identidad trigonométrica…".
2. **Formato de salida** (según configuración):
   - `latex` → código `.tex` compilable (template `latex_complete.tex` o `latex_minimal.tex`).
   - `markdown` → documento con delimitadores `$...$` y `$$...$$`.
   - `ambos` → generar ambos formatos.
3. **Integración GeoGebra (opcional, si `geogebra.habilitado=true`)**:
   - `geogebra.eval_command` para construcciones geométricas/fasores.
   - `geogebra.solve/factor/simplify/derivative/integral` para verificar CAS.
   - `geogebra.get_latex` para incrustar resultados verificados.
   - `geogebra.export_png` (escala 2-3) o `export_svg` para diagramas.
   - `geogebra.save_ggb` para guardar construcción editable.
   - **Si no hay GeoGebra disponible → generar TikZ/circuitikz manual sin fallar.**
4. **DETENERSE** y solicitar confirmación:

> "¿La resolución y el formato cumplen tus expectativas? Confirma para
> compilar y crear el archivo final, o indica cambios."

- **Confirmar** → Fase 3.
- **Modificar** → aplicar cambios y volver a presentar.
- **Abortar** → finalizar.

---

## 3. FASE 3 — Compilación y Generación de Archivos (tras confirmación)

### Instrucciones al agente

1. **Solo tras confirmación explícita** de la Fase 2.
2. Determinar directorio de salida (`preferencias.directorio_salida`,
   por defecto `./apuntex_output`).
3. Escribir archivos con permisos `write`:
   - `<nombre>.tex` (si formato latex/ambos).
   - `<nombre>.md` (si formato markdown/ambos).
   - Imágenes exportadas (`.png`/`.svg`) y `.ggb` si se usó GeoGebra.
4. **Compilación autónoma**:
   - Ejecutar el compilador configurado (`latexmk`, `xelatex`, `pdflatex`).
   - Ante error: leer `<nombre>.log`, corregir el `.tex`, recompilar.
   - Repetir hasta PDF limpio o alcanzar `max_intentos_compilacion` (default 5).
5. Informar al usuario, listando todos los archivos generados:

```
Archivos generados:
  ./apuntex_output/ejercicio.tex
  ./apuntex_output/ejercicio.pdf
  ./apuntex_output/diagrama_1.svg
  ./apuntex_output/construccion.ggb
```

---

## 4. Cambio de Modelos (Multimodal ↔ Solo-Texto)

Consulta `config/models.json` para el catálogo completo.

### Recomendación de transición

| Fase | Modelo recomendado | Por qué |
|------|--------------------|---------|
| Fase 1 (imagen) | `opencode/mimo-v2.5-free` | Único free de opencode con soporte multimodal confirmado |
| Fase 2 (texto/LaTeX) | `opencode/deepseek-v4-flash-free` | Rápido, gratis, buen texto + código |
| Fase 3 (compilación) | `opencode/deepseek-v4-flash-free` | LaTeX + bash sin desperdiciar cuota multimodal |

### Cómo cambiar en la TUI

```
Ctrl+X  → abre selector de modelo → elegir el modelo solo-texto o multimodal
```

### Modelos free de opencode disponibles

```
opencode/big-pickle
opencode/deepseek-v4-flash-free
opencode/hy3-free
opencode/laguna-s-2.1-free
opencode/mimo-v2.5-free        ← MULTIMODAL
opencode/nemotron-3-ultra-free
opencode/nemotron-3.5-lightning-free
```

---

## 5. Extensiones y Hooks

Los hooks viven en la raíz del proyecto (`.apuntex/hooks/`) y se cargan si
están referenciados en `.apuntexrc.json`.

| Hook | Momento | Permite |
|------|---------|---------|
| `pre_interpretacion` | Antes de Fase 1 | Validar imagen, redimensionar, loguear |
| `post_interpretacion` | Tras presentar Fase 1 | Guardar interpretación, métricas |
| `pre_resolucion` | Antes de Fase 2 | Añadir contexto o restricciones |
| `post_resolucion` | Tras presentar Fase 2 | Guardar código, estilos |
| `pre_compilacion` | Antes de Fase 3 | Inyectar paquetes, ajustar template |
| `post_compilacion` | Tras compilar | Copiar PDF, subir a Git/Notion/Obsidian |

Formato de cada hook (ver `.opencode/skills/apuntex/hooks/`):

```markdown
---
hook: post_compilacion
trigger: on_success
---
Recibido: {exito, archivos, log, tiempo}
Acciones:
  1. Si exito → copiar PDF a ~/Documentos/Apuntes/{{fecha}}/
  2. Retornar: {accion: "archivado"}
```

---

## 6. Comandos

```
/skill apuntex /ruta/imagen.png
/skill apuntex /foto.png --config=.apuntexrc.json --modelo-fase1=opencode/mimo-v2.5-free
/skill apuntex /foto.png --fase=1               # Solo interpretar
/skill apuntex /foto.png --formato=markdown
/skill apuntex --setup                          # Crear .apuntexrc.json interactivo
/skill apuntex --list-models                    # Listar modelos free disponibles
```

---

## 7. Dominios predefinidos (en desarrollo)

| Dominio | Paquetes base | Extra (ejemplo) |
|---------|---------------|-----------------|
| `general` | amsmath, graphicx, geometry | — |
| `ingenieria_electrica` | + circuitikz, siunitx | fasores, trifásica |
| `matematicas_puras` | + amssymb, mathtools, tikz-cd | demostraciones |
| `fisica_teorica` | + physics | notación vectorial |
| `mecanica_racional` | + tikz, babel | diagramas de cuerpo libre |

Establecer con `dominio_especifico.tipo` en `.apuntexrc.json`.

---

## 8. Instalación (resumen)

1. Clonar o copiar este repositorio a `.opencode/skills/apuntex/` del proyecto
   o a `~/.config/opencode/skills/apuntex/`.
2. Verificar dependencias: `latexmk`/`xelatex`/`pdflatex` en PATH.
3. (Opcional) Instalar `geogebra-mcp` en `~/.local/bin/geogebra-mcp`.
4. Reiniciar opencode para cargar la skill.
5. Ejecutar `--setup` para generar su `.apuntexrc.json`.

Detalle completo en `docs/INSTALACION.md`.