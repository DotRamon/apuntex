# Instalación de Apuntex

## Requisitos previos

| Dependencia | Necesaria | Notas |
|-------------|-----------|-------|
| Opencode reciente | Sí | Cualquier versión que soporte skills |
| LaTeX (`latexmk`/`xelatex`/`pdflatex`) | Sí | Verificar: `which latexmk xelatex pdflatex` |
| `geogebra-mcp` | No (opcional) | Solo para construcciones geométricas |

## Opción A — Instalación por proyecto (recomendada)

Cada proyecto que quiera usar Apuntex copia la skill en su carpeta `.opencode/`:

```bash
# Desde la raíz del proyecto destino
mkdir -p .opencode/skills
cp -r <ruta-repo>/apuntex/.opencode/skills/apuntex .opencode/skills/
```

Luego configurar el proyecto (ver `docs/PERSONALIZACION.md`).

## Opción B — Instalación global (fallback)

```bash
mkdir -p ~/.config/opencode/skills
cp -r <ruta-repo>/apuntex/.opencode/skills/apuntex ~/.config/opencode/skills/
```

## Paso 3 — Configuración inicial interactiva

Abrir opencode en el proyecto y ejecutar:

```
/skill apuntex --setup
```

Esto genera un `.apuntexrc.json` personalizado en la raíz del proyecto.

## Paso 4 — Reiniciar

**Importante:** salir y reiniciar opencode para que la skill se cargue.

## Verificar instalación

```
/skill apuntex --list-models
```

Debe listar los modelos free de opencode disponibles.

## (Opcional) GeoGebra MCP

Si se quiere soporte de construcciones geométricas:

```bash
npm install -g --prefix ~/.local @tiosavich/geogebra-mcp
# → genera ~/.local/bin/geogebra-mcp
```

Y en el `.apuntexrc.json` del proyecto:

```json
{
  "geogebra": {
    "habilitado": true,
    "ruta_mcp": "~/.local/bin/geogebra-mcp"
  }
}
```