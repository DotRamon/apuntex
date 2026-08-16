---
hook: post_compilacion
trigger: on_success
---
# Hook post_compilacion

Recibido: {exito, archivos, log, tiempo_total}

## Acciones por defecto
1. Si éxito:
   - Copiar PDF a directorio de apuntes configurado por el proyecto.
   - (Opcional) Git commit + push si se configuró.
2. Notificar: "Transcripción completada: {{archivos.pdf}}"
3. Retornar: {accion: "archivado"}

## Personalización por proyecto
Cada usuario puede sobrescribir este hook en `.apuntex/hooks/post_compilacion.md`
para integrar Notion, Obsidian, subida a nube, etc.