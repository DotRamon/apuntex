---
hook: pre_interpretacion
trigger: always
---
# Hook pre_interpretacion

Recibido: {imagen_path, config, modelo_activo}

## Acciones por defecto
1. Validar que la imagen existe y es legible.
2. Si la imagen excede 10 MB → sugerir al usuario redimensionar/comprimir.
3. Registrar: "Iniciando transcripción de {{imagen_path}} con {{modelo_activo}}"
4. Retornar: {continuar: true}