# Apuntex Protocol

[![CI](https://github.com/DotRamon/apuntex-protocolo/actions/workflows/ci.yml/badge.svg)](https://github.com/DotRamon/apuntex-protocolo/actions/workflows/ci.yml)

Protocolo faseado para transcribir imágenes (fotos, escaneos, apuntes) a
LaTeX/Markdown, con aprobaciones en cada etapa. Se usa como **Skill**, como
**Agent** o como **Comando**, según la preferencia de cada quien.

**Autor**: DotRamon · **Licencia**: MIT

## Qué resuelve

Convierte imágenes de apuntes en documentos LaTeX compilables siguiendo un
protocolo estricto de 3 fases:

1. **Interpretación** → la imagen se analiza y se pide aprobación al usuario.
2. **Resolución** → se resuelve paso a paso y se estructura en LaTeX/Markdown.
3. **Compilación** → se generan `.tex`/`.md`/`.pdf` con compilación autónoma.

El valor no es una herramienta dedicada, sino **el protocolo faseado** con
control total del usuario.

## 3 modos de uso

| Modo | Cuándo usarlo | Cómo |
|------|---------------|------|
| **Skill** | Uso ocasional, invocación explícita | `/skill apuntex /ruta/img.png` |
| **Agent** | Proyecto 100% transcripción | `default_agent: "apuntex"` en `opencode.json` |
| **Comando** | Atajo manual corto | `/tex /ruta/img.png` |

Detalle en `docs/CONFIGURACION.md`.

## Requisitos

- **Opencode** (o cualquier agente multimodal — ver `docs/AGENTES.md`).
- **LaTeX** instalado (`latexmk`/`xelatex`/`pdflatex`). Ver instalación por SO abajo.
- Modelo multimodal para la Fase 1: `opencode/mimo-v2.5-free`.

## Instalar LaTeX

La Fase 3 compila `.tex` → PDF, así que necesitas un compilador LaTeX en tu sistema.

<details>
<summary><b>Linux</b> (Debian/Ubuntu · Arch · Fedora)</summary>

```bash
# Debian / Ubuntu / Mint
sudo apt update
sudo apt install -y texlive-latex-recommended texlive-latex-extra latexmk
# completo (pesado): sudo apt install -y texlive-full

# Arch / Manjaro
sudo pacman -S texlive-most latexmk

# Fedora
sudo dnf install -y texlive-scheme-medium latexmk
# completo: sudo dnf install -y texlive-scheme-full
```
</details>

<details>
<summary><b>macOS</b> (Homebrew)</summary>

```bash
# Completo
brew install --cask mactex

# Ligero (BasicTeX + latexmk)
brew install --cask basictex
export PATH="/usr/local/texlive/$(ls /usr/local/texlive | tail -1)/bin/universal-darwin:$PATH"
sudo tlmgr install latexmk amsmath graphicx geometry babel-spanish
```
</details>

<details>
<summary><b>Windows</b> (MiKTeX · TeX Live · WSL2)</summary>

```text
MiKTeX (recomendada):
  1. Descargar https://miktex.org/download
  2. Instalar con "Install missing packages on the fly = Yes"
  3. Verificar: latexmk --version (CMD)

WSL2 (recomendada si ya usas Linux):
  - Seguir la guía de Debian/Ubuntu dentro de WSL2.
  - Abrir opencode dentro de WSL2 para que vea latexmk.

TeX Live nativo:
  - Descargar https://tug.org/texlive/
  - Añadir C:\texlive\<año>\bin\windows al PATH.
```
</details>

Verifica con `latexmk --version`. Guía completa: `docs/INSTALACION_LATEX.md`.

## Instalación rápida

```bash
# 1. Copiar la skill al proyecto
mkdir -p .opencode/skills
cp -r <ruta>/apuntex-protocolo/.opencode/skills/apuntex .opencode/skills/

# 2. (Opcional) Agente + comando
mkdir -p .opencode/agent .opencode/command
cp <ruta>/apuntex-protocolo/.opencode/agent/apuntex.md .opencode/agent/
cp <ruta>/apuntex-protocolo/.opencode/command/tex.md .opencode/command/

# 3. Config del proyecto (.apuntexrc.json)
#    Copiar desde config/user-config.example.json y editar

# 4. Reiniciar opencode para cargar la skill
```

Detalle en `docs/INSTALACION.md` y `docs/CONFIGURACION.md`.

## Configuración por proyecto

Apuntex se configura con `.apuntexrc.json` **en la raíz de cada proyecto**, no
de forma global. Ver `config/user-config.example.json` y `docs/PERSONALIZACION.md`.

## Modelos

Todos los modelos opencode `/*-free` son gratuitos. La estrategia recomendada:

| Fase | Modelo | Tipo |
|------|--------|------|
| 1 (imagen) | `opencode/mimo-v2.5-free` | Multimodal |
| 2 (texto) | `opencode/deepseek-v4-flash-free` | Solo texto |
| 3 (compilación) | `opencode/deepseek-v4-flash-free` | Solo texto |

Catálogo completo en `config/models.json` y `docs/MODELOS.md`.

## Estructura del repositorio

```
apuntex-protocolo/
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
│   ├── latex_complete.tex
│   ├── latex_minimal.tex
│   └── markdown_academico.md
├── docs/
│   ├── CONFIGURACION.md             # 3 modos de uso
│   ├── INSTALACION.md
│   ├── INSTALACION_LATEX.md         # LaTeX por SO
│   ├── AGENTES.md                   # Multi-agente
│   ├── PERSONALIZACION.md
│   ├── MODELOS.md
│   └── EJEMPLOS.md
├── tests/
│   ├── run_tests.sh                 # Validación automática
│   ├── test_casos_uso.md
│   └── prompts_fase1.md
├── .github/workflows/ci.yml         # CI en push/PR
└── README.md
```

## Uso

```
/skill apuntex /ruta/imagen.png        # Modo Skill
/skill apuntex foto.png --formato=markdown
/tex /ruta/imagen.png                  # Modo Comando (si instalado)
```

## Tests

```bash
bash tests/run_tests.sh
```

Valida JSON de config, frontmatter de skill/agente y compilación de templates.
Ejecutado también en CI (`.github/workflows/ci.yml`).

## Roadmap

- [ ] `--selftest` con fixtures de imágenes
- [ ] Soporte batch (múltiples imágenes)
- [ ] Marketplace de dominios/templates
- [ ] Integración Git/Notion/Obsidian vía hooks

## Licencia

MIT — ver `LICENSE`.