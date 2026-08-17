# Instalación de Apuntex

## Opción A — Sin copiar archivos (más ágil)

Solo agrega una línea en tu `opencode.json` del proyecto:

```json
{
  "skills": {
    "urls": ["https://raw.githubusercontent.com/DotRamon/apuntex/main/.opencode/skills/apuntex/SKILL.md"]
  }
}
```

Reinicia opencode. La skill se carga directo desde GitHub.
Limitación: solo funciona para la skill. Para agente/comando, usa la Opción B.

## Opción B — Instalador local (recomendada)

```bash
# Una línea desde la raíz del proyecto:
bash <(curl -fsSL https://raw.githubusercontent.com/DotRamon/apuntex/main/install.sh) --all --config --latex
```

O clonar y ejecutar:

```bash
git clone https://github.com/DotRamon/apuntex.git /tmp/apuntex
bash /tmp/apuntex/install.sh --all --config
rm -rf /tmp/apuntex
```

Opciones del instalador (`install.sh --help`):

| Opción | Qué instala |
|--------|-------------|
| `--skill` | Solo la skill (`/skill apuntex img.png`) |
| `--agent` | Solo el agente (modo automático) |
| `--command` | Solo el comando (`/tex img.png`) |
| `--all` | Todo: skill + agent + comando (por defecto) |
| `--config` | Copia `.apuntexrc.json` al proyecto |
| `--latex` | Verifica si LaTeX está instalado |

## Requisitos previos

| Dependencia | Necesaria | Notas |
|-------------|-----------|-------|
| Opencode reciente | Sí | Cualquier versión que soporte skills |
| LaTeX (`latexmk`/`xelatex`/`pdflatex`) | Sí | Verificar con `install.sh --latex` |
| `geogebra-mcp` | No (opcional) | Solo para construcciones geométricas | |

## Opción A — Instalación por proyecto (recomendada)

Cada proyecto que quiera usar Apuntex copia la skill en su carpeta `.opencode/`:

```bash
# Desde la raíz del proyecto destino
mkdir -p .opencode/skills
cp -r <ruta-repo>/apuntex/.opencode/skills/apuntex .opencode/skills/
```

Luego configurar el proyecto (ver `PERSONALIZACION.md`).

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