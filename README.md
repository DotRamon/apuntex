# Apuntex Protocol

Protocolo faseado para transcribir imágenes (fotos, escaneos, apuntes) a
LaTeX/Markdown, con aprobaciones en cada etapa.

**Autor**: DotRamon · **Licencia**: MIT

## Qué resuelve

Convierte imágenes de apuntes en documentos LaTeX compilables siguiendo un
protocolo estricto de 3 fases:

1. **Interpretación** → la imagen se analiza y se pide aprobación al usuario.
2. **Resolución** → se resuelve paso a paso y se estructura en LaTeX/Markdown.
3. **Compilación** → se generan `.tex`/`.md`/`.pdf` con compilación autónoma.

El valor no es una herramienta dedicada, sino **el protocolo faseado** con
control total del usuario.

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
├── .opencode/skills/apuntex/
│   ├── SKILL.md                 # La skill (name: apuntex)
│   └── hooks/                   # Templates de hooks
├── config/
│   ├── defaults.json            # Valores base
│   ├── user-config.example.json # Ejemplo de .apuntexrc.json
│   └── models.json              # Catálogo de modelos free
├── templates/
│   ├── latex_complete.tex
│   ├── latex_minimal.tex
│   └── markdown_academico.md
├── docs/
│   ├── INSTALACION.md
│   ├── PERSONALIZACION.md
│   ├── MODELOS.md
│   └── EJEMPLOS.md
└── README.md
```

## Instalación rápida

```bash
# Copiar la skill a tu proyecto
mkdir -p .opencode/skills
cp -r <ruta>/apuntex-protocolo/.opencode/skills/apuntex .opencode/skills/

# Generar config del proyecto (abrir opencode y:)
/skill apuntex --setup
```

Detalle en `docs/INSTALACION.md`.

## Uso

```
/skill apuntex /ruta/imagen.png
/skill apuntex /foto.png --formato=markdown
/skill apuntex /foto.png --fase=1
/skill apuntex --list-models
```

## Roadmap

- [ ] `--selftest` con fixtures de imágenes
- [ ] Soporte batch (múltiples imágenes)
- [ ] GitHub Actions CI para validar templates LaTeX
- [ ] Marketplace de dominios/templates
- [ ] Integración Git/Notion/Obsidian vía hooks

## Licencia

MIT — ver `LICENSE`.