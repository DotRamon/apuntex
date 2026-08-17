# Apuntex

[![CI](https://github.com/DotRamon/apuntex/actions/workflows/ci.yml/badge.svg)](https://github.com/DotRamon/apuntex/actions/workflows/ci.yml)

**Asistente académico** que transcribe de forma fiel apuntes, fotos de pizarra
y escaneos a **LaTeX/Markdown**, y además los **resuelve explicando paso a paso**.

Convierte tus notas manuscritras, diagramas de circuito, ecuaciones de pizarra
o cualquier material visual en documentos LaTeX/Markdown listos para usar,
con la precisión de un tutor que no pierde ni una fórmula.

**Autor**: DotRamon · **Licencia**: MIT

---

## Tabla de contenido

- [Qué hace](#qué-hace)
- [Cómo funciona](#cómo-funciona)
- [Instalación](#instalación)
- [Uso](#uso)
- [Configuración](#configuración)
- [Modelos](#modelos)
- [Uso con otros agentes](#uso-con-otros-agentes)
- [Tests](#tests)
- [Roadmap](#roadmap)
- [Licencia](#licencia)

---

## Qué hace

Apuntex toma una imagen —foto de pizarra, escaneo de apuntes, captura de
ejercicio manuscrito, diagrama eléctrico— y:

1. **Transcribe fielmente** el enunciado, fórmulas, ecuaciones y estructura del apunte.
   Nunca adivina: si algo es ilegible o ambiguo, lo marca explícitamente.
2. **Resuelve y explica** paso a paso, actuando como tutor académico.
   Identifica saltos lógicos y los documenta con notas pedagógicas.
3. **Genera** documentos LaTeX o Markdown estructurados y compila el PDF.

Todo bajo **control total del usuario**: aprueba o corrige en cada etapa antes
de avanzar. No se genera nada sin tu OK.

### Ejemplo rápido

```
Tú: [arrastres foto de pizarra con ecuación diferencial]
Apuntex: "Enunciado extraído: y' + p(x)y = q(x). [AMBIGUO: símbolo entre ∂ y δ]"
Tú: "Aprobar"
Apuntex: [resuelve con factor integrante, genera LaTeX completo]
Tú: "Confirmar"
Apuntex: [compila PDF, genera ejercicio.pdf]
```

---

## Cómo funciona

Apuntex trabaja por **etapas**:

| Etapa | Qué hace | Control del usuario |
|-------|----------|---------------------|
| **Interpretación** | Analiza la imagen y transcribe el contenido | Aprueba o pide correcciones |
| **Resolución** | Resuelve el ejercicio paso a paso | Confirma formato y contenido |
| **Compilación** | Genera archivos y compila PDF | Lista de archivos generados |

Para construcciones geométricas, circuitos o diagramas complejos, Apuntex
puede usar **GeoGebra MCP** (opcional) para crear construcciones interactivas,
verificar con CAS y exportar imágenes vectoriales.

---

## Instalación

### Requisitos

| Requisito | Necesario | Notas |
|-----------|-----------|-------|
| **Opencode** | Sí | O cualquier agente multimodal (ver `docs/AGENTES.md`) |
| **LaTeX** | Sí | `latexmk`, `xelatex` o `pdflatex` en PATH |
| **Modelo multimodal** | Sí | `opencode/mimo-v2.5-free` para la interpretación |
| **GeoGebra MCP** | No | Solo para construcciones geométricas avanzadas |

### Instalación rápida

**Una línea** (desde la raíz del proyecto):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/DotRamon/apuntex/main/install.sh) --all --config --latex
```

Esto instala: skill + agente + comando + verifica LaTeX.

### Otras opciones de instalación

| Método | Uso |
|--------|-----|
| `install.sh --skill` | Solo la skill (`/skill apuntex img.png`) |
| `install.sh --agent` | Solo el agente (automático en el chat) |
| `install.sh --command` | Solo el comando (`/tex img.png`) |
| `install.sh --all --config` | Todo + archivo de configuración |
| `install.sh --latex` | Solo verificar si LaTeX está instalado |

### Desde GitHub sin clonar (solo skill)

Agrega esto a tu `opencode.json`:

```json
{
  "skills": {
    "urls": ["https://raw.githubusercontent.com/DotRamon/apuntex/main/.opencode/skills/apuntex/SKILL.md"]
  }
}
```

Reinicia opencode y listo.

### Instalar LaTeX

Apuntex necesita un compilador LaTeX para generar PDFs. Incluimos guías por SO:

| SO | Comando rápido |
|----|----------------|
| **Linux** | `sudo apt install texlive-latex-extra latexmk` |
| **macOS** | `brew install --cask mactex` |
| **Windows** | Instalar [MiKTeX](https://miktex.org/download) + [Strawberry Perl](https://strawberryperl.com/) |

Guía completa: `docs/INSTALACION_LATEX.md`

---

## Uso

Apuntex se puede usar de **3 formas** según tu preferencia:

### 1. En el chat directamente (Agent)

Si el agente está instalado como principal (`default_agent`), puedes:

- **Arrastrar una imagen** al chat y Apuntex inicia la interpretación.
- **Escribir** `/tex foto.png` y ejecuta el comando.

```json
{
  "default_agent": "apuntex"
}
```

### 2. Invocando la skill

```
/skill apuntex /ruta/imagen.png
/skill apuntex foto.png --formato=markdown
/skill apuntex foto.png --fase=1
```

### 3. Con el comando corto

```
/tex /ruta/imagen.png
```

### Parámetros disponibles

| Parámetro | Descripción | Ejemplo |
|-----------|-------------|---------|
| `--formato` | `latex` o `markdown` | `--formato=markdown` |
| `--fase` | Solo ejecutar una fase (1, 2 o 3) | `--fase=1` |
| `--config` | Ruta a configuración personalizada | `--config=.apuntexrc.json` |
| `--modelo-fase1` | Modelo para interpretación | `--modelo-fase1=opencode/mimo-v2.5-free` |

Detalle: `docs/CONFIGURACION.md`

---

## Configuración

Apuntex se configura **por proyecto** con un archivo `.apuntexrc.json` en la
raíz. No hay configuración global obligatoria.

```json
{
  "modelos": {
    "interpretacion": "opencode/mimo-v2.5-free",
    "resolucion_texto": "opencode/deepseek-v4-flash-free"
  },
  "preferencias": {
    "formato_salida": "latex",
    "directorio_salida": "./apuntex_output"
  },
  "geogebra": {
    "habilitado": false
  }
}
```

### Configurar por proyecto

1. Copiar el ejemplo: `cp config/user-config.example.json .apuntexrc.json`
2. Editar según tus necesidades.
3. Reiniciar opencode.

### Hooks personalizados

Puedes ejecutar acciones automáticas en cada etapa:

| Hook | Momento |
|------|---------|
| `pre_interpretacion` | Antes de analizar la imagen |
| `post_interpretacion` | Tras presentar la interpretación |
| `pre_resolucion` | Antes de resolver |
| `post_resolucion` | Tras generar el código |
| `pre_compilacion` | Antes de compilar |
| `post_compilacion` | Tras generar los archivos |

Detalle: `docs/PERSONALIZACION.md`

---

## Modelos

Apuntex funciona con modelos **gratuitos** de opencode:

| Modelo | Tipo | Uso |
|--------|------|-----|
| `opencode/mimo-v2.5-free` | Multimodal | Interpretación de imágenes |
| `opencode/deepseek-v4-flash-free` | Solo texto | Resolución y compilación |
| `opencode/nemotron-3-ultra-free` | Solo texto | Resolución compleja |
| `opencode/nemotron-3.5-lightning-free` | Solo texto | Compilación rápida |

### Estrategia de modelos

La **interpretación** (Fase 1) requiere un modelo que "vea" la imagen.
Una vez aprobada, la **resolución** y **compilación** (Fases 2 y 3) pueden
usar un modelo solo-texto más rápido y barato.

Para cambiar de modelo en la TUI: `Ctrl+X` → seleccionar modelo.

Catálogo completo: `docs/MODELOS.md` · `config/models.json`

---

## Uso con otros agentes

Apuntex es **portable**: funciona con cualquier agente que acepte imágenes.

| Plataforma | Cómo usarlo |
|------------|-------------|
| **Opencode** | Skill/Agent/Command nativo |
| **Claude Desktop** | System prompt con protocolo + MCP GeoGebra |
| **Codex CLI** | AGENTS.md con el protocolo |
| **Gemini CLI** | Instrucciones de sistema |
| **Cualquier LLM** | Pegar el protocolo del `SKILL.md` |

Detalle: `docs/AGENTES.md`

---

## Tests

```bash
bash tests/run_tests.sh
```

Valida: JSON de config, frontmatter de skill/agente, compilación de templates.
Ejecutado automáticamente en CI (`.github/workflows/ci.yml`).

---

## Estructura del repositorio

```
apuntex/
├── .opencode/
│   ├── skills/apuntex/
│   │   ├── SKILL.md                 # La skill (name: apuntex)
│   │   └── hooks/                   # Templates de hooks
│   ├── agent/apuntex.md             # Agente (mode: primary)
│   └── command/tex.md               # Comando /tex
├── config/
│   ├── defaults.json                # Valores base
│   ├── user-config.example.json     # Ejemplo de .apuntexrc.json
│   └── models.json                  # Catálogo de modelos free
├── templates/
│   ├── latex_complete.tex           # Template LaTeX completo
│   ├── latex_minimal.tex            # Template LaTeX mínimo
│   └── markdown_academico.md        # Template Markdown
├── tests/
│   ├── run_tests.sh                 # Validación automática
│   ├── test_casos_uso.md            # Casos de prueba
│   └── prompts_fase1.md             # Prompts de validación
├── docs/
│   ├── CONFIGURACION.md             # 3 modos de uso (Skill/Agent/Comando)
│   ├── INSTALACION.md               # Copiar skill/agent/command
│   ├── INSTALACION_LATEX.md         # LaTeX por SO (Linux/macOS/Windows)
│   ├── PERSONALIZACION.md           # .apuntexrc.json, hooks, dominios
│   ├── MODELOS.md                   # Modelos free y cambio multimodal→texto
│   ├── AGENTES.md                   # Uso con Claude, Codex, Gemini
│   └── EJEMPLOS.md                  # Casos reales de uso
├── install.sh                       # Instalador (una línea)
├── .github/workflows/ci.yml         # CI en push/PR
├── README.md                        # Este archivo
├── CHANGELOG.md                     # Historial de versiones
└── LICENSE                          # MIT
```

---

## Roadmap

- [ ] `--selftest` con fixtures de imágenes
- [ ] Soporte batch (múltiples imágenes)
- [ ] Marketplace de dominios/templates
- [ ] Integración Git/Notion/Obsidian vía hooks

---

## Licencia

MIT — ver `LICENSE`.

## Contribuir

Aportes son bienvenidos vía Issues y Pull Requests.