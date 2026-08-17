#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/DotRamon/apuntex.git"
REPO_DIR="$HOME/.cache/apuntex-repo"
SKILL_NAME="apuntex"
TARGET_DIR="$(pwd)"

usage() {
  cat <<EOF
Uso: install.sh [OPCIONES]

Instala Apuntex en el directorio de trabajo actual.

Opciones:
  --skill       Instalar solo la skill (modo /skill apuntex)
  --agent       Instalar el agente (modo default_agent)
  --command     Instalar el comando /tex
  --all         Instalar todo (skill + agent + comando) [por defecto]
  --config      Copiar .apuntexrc.json de ejemplo al proyecto
  --latex       Verificar si LaTeX está instalado y dar instrucciones
  --no-git      No clonar repo, usar version local
  --help        Mostrar esta ayuda

Ejemplos:
  bash install.sh                          # Instala todo
  bash install.sh --skill --config         # Solo skill + config
  bash install.sh --latex                  # Solo verificar LaTeX
  bash install.sh --all --config --latex   # Todo completo
EOF
}

install_skill() {
  echo "📦 Instalando skill..."
  mkdir -p "$TARGET_DIR/.opencode/skills/$SKILL_NAME"
  cp "$REPO_DIR/.opencode/skills/$SKILL_NAME/SKILL.md" "$TARGET_DIR/.opencode/skills/$SKILL_NAME/"
  mkdir -p "$TARGET_DIR/.opencode/skills/$SKILL_NAME/hooks"
  cp "$REPO_DIR/.opencode/skills/$SKILL_NAME/hooks/"*.md "$TARGET_DIR/.opencode/skills/$SKILL_NAME/hooks/" 2>/dev/null || true
  echo "   ✅ Skill instalada en .opencode/skills/$SKILL_NAME/"
}

install_agent() {
  echo "🤖 Instalando agente..."
  mkdir -p "$TARGET_DIR/.opencode/agent"
  cp "$REPO_DIR/.opencode/agent/$SKILL_NAME.md" "$TARGET_DIR/.opencode/agent/"
  echo "   ✅ Agente instalado en .opencode/agent/$SKILL_NAME.md"
}

install_command() {
  echo "⚡ Instalando comando..."
  mkdir -p "$TARGET_DIR/.opencode/command"
  cp "$REPO_DIR/.opencode/command/tex.md" "$TARGET_DIR/.opencode/command/"
  echo "   ✅ Comando instalado en .opencode/command/tex.md"
}

install_config() {
  echo "⚙️  Generando configuración..."
  if [ -f "$TARGET_DIR/.apuntexrc.json" ]; then
    echo "   ⚠️  .apuntexrc.json ya existe, saltando..."
  else
    cp "$REPO_DIR/config/user-config.example.json" "$TARGET_DIR/.apuntexrc.json"
    echo "   ✅ .apuntexrc.json creado (personalizar según tu proyecto)"
  fi
}

check_latex() {
  echo "🔍 Verificando LaTeX..."
  local found=0
  for cmd in latexmk xelatex pdflatex lualatex; do
    if command -v "$cmd" &>/dev/null; then
      echo "   ✅ $cmd encontrado: $(command -v "$cmd")"
      found=1
    fi
  done
  if [ $found -eq 0 ]; then
    echo "   ❌ No se encontró compilador LaTeX"
    echo ""
    echo "   Instala uno de estos paquetes:"
    echo "   • Linux (Debian/Ubuntu): sudo apt install texlive-latex-extra latexmk"
    echo "   • Linux (Arch):          sudo pacman -S texlive-most latexmk"
    echo "   • macOS:                 brew install --cask mactex"
    echo "   • Windows:               Descargar MiKTeX https://miktex.org/download"
    echo "                            (requiere Strawberry Perl para latexmk)"
    echo ""
    echo "   Guía completa: docs/INSTALACION_LATEX.md"
    return 1
  fi
}

clone_repo() {
  if [ -d "$REPO_DIR" ]; then
    echo "🔄 Actualizando repositorio local..."
    git -C "$REPO_DIR" pull --quiet 2>/dev/null || true
  else
    echo "📥 Clonando repositorio..."
    git clone --quiet "$REPO_URL" "$REPO_DIR"
  fi
}

cleanup() {
  if [ -d "$REPO_DIR" ]; then
    echo "🧹 Limpiando..."
    rm -rf "$REPO_DIR"
  fi
}

# --- Main ---
DO_SKILL=0
DO_AGENT=0
DO_COMMAND=0
DO_ALL=1
DO_CONFIG=0
DO_LATEX=0
USE_LOCAL=0

while [ $# -gt 0 ]; do
  case "$1" in
    --skill)   DO_SKILL=1; DO_ALL=0 ;;
    --agent)   DO_AGENT=1; DO_ALL=0 ;;
    --command) DO_COMMAND=1; DO_ALL=0 ;;
    --all)     DO_ALL=1 ;;
    --config)  DO_CONFIG=1 ;;
    --latex)   DO_LATEX=1 ;;
    --no-git)  USE_LOCAL=1 ;;
    --help)    usage; exit 0 ;;
    *)         echo "Opción desconocida: $1"; usage; exit 1 ;;
  esac
  shift
done

echo ""
echo "╔══════════════════════════════════════╗"
echo "║         Instalador Apuntex          ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Check opencode
if ! command -v opencode &>/dev/null && ! command -v npx &>/dev/null; then
  echo "⚠️  No se detectó opencode. Asegúrate de tenerlo instalado."
  echo ""
fi

# Clone or use local
if [ $USE_LOCAL -eq 0 ]; then
  clone_repo
fi

# Install components
if [ $DO_ALL -eq 1 ]; then
  install_skill
  install_agent
  install_command
else
  [ $DO_SKILL -eq 1 ]   && install_skill
  [ $DO_AGENT -eq 1 ]   && install_agent
  [ $DO_COMMAND -eq 1 ] && install_command
fi

# Config
[ $DO_CONFIG -eq 1 ] && install_config

# LaTeX check
[ $DO_LATEX -eq 1 ] && check_latex

# Cleanup
[ $USE_LOCAL -eq 0 ] && cleanup

echo ""
echo "✅ ¡Listo! Reinicia opencode para cargar la configuración."
echo ""
echo "Uso:"
echo "  /skill apuntex /ruta/imagen.png    # Modo Skill"
echo "  /tex /ruta/imagen.png              # Modo Comando"
echo "  default_agent: \"apuntex\"           # Modo Agent (en opencode.json)"
echo ""
