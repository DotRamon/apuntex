# Changelog

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