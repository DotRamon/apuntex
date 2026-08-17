# Uso con Otros Agentes

El protocolo Apuntex es **portable**: no depende de una plataforma específica.
Se puede replicar en cualquier agente que:

1. Acepte **imágenes** (modelo multimodal).
2. Pueda **escribir archivos** (`.tex`, `.md`).
3. Pueda **ejecutar comandos** (compilador LaTeX).

La skill nativa vive en `.opencode/skills/apuntex/SKILL.md` y el agente en
`.opencode/agent/apuntex.md`. Para otros agentes, copia el **protocolo faseado**
como instrucciones de sistema.

---

## Claude (Claude Desktop / Claude Code)

### Opción A — MCP + prompt de sistema

1. Instalar `geogebra-mcp` (opcional):
   ```bash
   npm install -g --prefix ~/.local @tiosavich/geogebra-mcp
   ```

2. Configurar MCP en `claude_desktop_config.json`:
   ```json
   {
     "mcpServers": {
       "geogebra": {
         "command": "geogebra-mcp",
         "env": { "GEOGEBRA_APP": "suite", "GEOGEBRA_HEADLESS": "true" }
       }
     }
   }
   ```

3. Añadir en las **Custom Instructions** el protocolo de 3 fases del
   `SKILL.md` (secciones 1-3). Adjuntar la imagen directamente en el chat.

### Opción B — Skills de Claude (CLAUDE.md)

Colocar un `CLAUDE.md` en el proyecto con el protocolo faseado abreviado:

```markdown
# Apuntex
Sigue el protocolo de 3 fases: (1) interpretar imagen y pedir aprobación,
(2) resolver y estructurar en LaTeX/Markdown y pedir confirmación,
(3) compilar con latexmk y listar archivos.
```

---

## Codex CLI (OpenAI)

1. Configurar el servidor MCP en el `opencode.json` / configuración de Codex:
   ```json
   {
     "mcpServers": {
       "geogebra": { "command": "geogebra-mcp" }
     }
   }
   ```

2. Añadir las fases del protocolo a `AGENTS.md` del proyecto (Codex lee los
   archivos `AGENTS.md`). El modelo `codex` (gpt-5) es multimodal: adjuntar la
   imagen directamente.

---

## Gemini CLI (Google)

1. Gemini es multimodal nativo: adjuntar la imagen directamente.
2. Añadir el protocolo faseado a las instrucciones de sistema o `AGENTS.md`.
3. Usar la integración del MCP si aplica.

---

## Cualquier LLM multimodal (genérico)

1. Adjuntar la imagen al chat.
2. Pegar el protocolo de 3 fases como instrucciones de sistema (contenido del
   `SKILL.md`).
3. El LLM interpreta, resuelve, y genera LaTeX; tú compilas o pides que genere
   el archivo con herramientas de escritura.

---

## Tabla comparativa

| Plataforma | Multimodal | MCP GeoGebra | Forma de instalación |
|------------|-----------|--------------|----------------------|
| **Opencode** | ✅ | ✅ | Skill/Agent/Command nativo |
| **Claude Code** | ✅ | ✅ | MCP + prompt/CLAUDE.md |
| **Codex CLI** | ✅ | ✅ | MCP + AGENTS.md |
| **Gemini CLI** | ✅ | — | Instrucciones de sistema |
| **Genérico** | ✅ | — | Pegar protocolo |

> La parte esencial que **no se puede externalizar** es el compilador LaTeX:
> debe estar instalado en el sistema donde corre el agente
> (ver `docs/INSTALACION_LATEX.md`).
