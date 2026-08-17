# Changelog

## 1.1.0

- Agente `apuntex` (`.opencode/agent/apuntex.md`, mode: primary).
- Comando `/tex` (`.opencode/command/tex.md`).
- Documentación de 3 modos de uso (`docs/CONFIGURACION.md`).
- Tests automatizados (`tests/run_tests.sh`) y CI (`tests/test_casos_uso.md`, `tests/prompts_fase1.md`).
- CI en GitHub Actions (`.github/workflows/ci.yml`).
- Guía de instalación de LaTeX por SO (Linux/macOS/Windows) — `docs/INSTALACION_LATEX.md`.
- Guía multi-agente (Claude, Codex, Gemini, genérico) — `docs/AGENTES.md`.
- README actualizado con badges, modos de uso y estructura.

## 1.0.0 (inicial)

- Protocolo faseado de 3 fases con aprobaciones (interpretación → resolución → compilación).
- Skill `apuntex` instalable por proyecto (`.opencode/skills/apuntex/`) o global.
- Configuración por proyecto via `.apuntexrc.json` (jerarquía: proyecto → global → defaults).
- Catálogo de modelos `config/models.json` con modelos free de opencode.
- Modelo multimodal recomendado: `opencode/mimo-v2.5-free`.
- Estrategia de cambio modal (multimodal Fase 1 → solo-texto Fases 2/3).
- Plantillas LaTeX (complete/minimal) y Markdown académico.
- Hooks extensibles por proyecto (6 puntos de extensión).
- Documentación: instalación, personalización, modelos, ejemplos.