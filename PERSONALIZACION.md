# Personalización por Proyecto

Apuntex se configura **por proyecto** mediante un archivo `.apuntexrc.json`
en la raíz del proyecto. Nada de configuración global obligatoria.

## Jerarquía de carga

1. `.apuntexrc.json` en la raíz del proyecto → **tiene prioridad total**
2. `~/.config/apuntex/apuntexrc.json` → fallback global personal
3. `config/defaults.json` de la skill → valores base

## Referencia de opciones

```json
{
  "modelos": {
    "interpretacion": "opencode/mimo-v2.5-free",
    "resolucion_texto": "opencode/deepseek-v4-flash-free",
    "compilacion": "opencode/deepseek-v4-flash-free"
  },
  "preferencias": {
    "formato_salida": "latex",              // latex | markdown | ambos
    "estilo_latex": "complete",             // complete | minimal
    "incluir_diagramas": true,
    "compilador": "latexmk",                // latexmk | xelatex | pdflatex
    "max_intentos_compilacion": 5,
    "limpiar_auxiliares": true,
    "directorio_salida": "./apuntex_output"
  },
  "geogebra": {
    "habilitado": false,
    "ruta_mcp": "~/.local/bin/geogebra-mcp",
    "app": "suite",
    "headless": true,
    "exportar_svg": true,
    "escala_png": 3
  },
  "dominio_especifico": {
    "tipo": "general",                      // general | ingenieria_electrica | matematicas_puras | fisica_teorica | mecanica_racional
    "paquetes_extra": ["geometry"]
  },
  "hooks_personalizados": {
    "pre_interpretacion": ".apuntex/hooks/pre_interpretacion.md"
  }
}
```

## Hooks por proyecto

Los hooks viven en `.apuntex/hooks/` dentro del proyecto y se referencian en la
configuración. Cada hook es un archivo markdown con frontmatter `hook:` y
`trigger:`, seguido de instrucciones para el agente.

| Hook | Momento | Ejemplo de uso |
|------|---------|----------------|
| `pre_interpretacion` | Antes de Fase 1 | Validar/redimensionar imagen |
| `post_interpretacion` | Tras presentar Fase 1 | Archivar interpretación |
| `pre_resolucion` | Antes de Fase 2 | Añadir restricciones |
| `post_resolucion` | Tras presentar Fase 2 | Guardar código |
| `pre_compilacion` | Antes de Fase 3 | Inyectar estilos |
| `post_compilacion` | Tras compilar | Copiar PDF, subir a Git/Notion |

See `.opencode/skills/apuntex/hooks/` para los templates de referencia.

## Dominios

Establecer `dominio_especifico.tipo` para cambiar el paquete base de LaTeX y
las convenciones de notación. Ver `SKILL.md:7` para la tabla completa.

## Cambio de modelo en TUI

Durante una sesión con imagen, el protocolo recomienda:

```
Fase 1 (imagen)          → opción multimodal (opencode/mimo-v2.5-free)
Fase 2/3 (texto+LaTeX)   → solo-texto (opencode/deepseek-v4-flash-free)
```

Cambio con `Ctrl+X` en la TUI de opencode. Detalles en `MODELOS.md`.