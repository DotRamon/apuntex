# Modelos Soportados

Catálogo completo en `config/models.json`. Aquí el resumen de los modelos
**free** de opencode.

## Multimodal (interpretación de imágenes)

| Modelo | Gratuito | Multimodal | Uso |
|--------|----------|------------|-----|
| `opencode/mimo-v2.5-free` | ✅ | ✅ | Fase 1: interpretación |

> **`mimo-v2.5-free` es el único modelo free de opencode con soporte
> multimodal confirmado para imágenes** (Xiaomi MiMo 2.5). Es el candidato
> natural para la Fase 1.

## Solo texto (resolución y compilación)

| Modelo | Gratuito | Velocidad | Uso |
|--------|----------|-----------|-----|
| `opencode/deepseek-v4-flash-free` | ✅ | Muy rápida | Fases 2 y 3 |
| `opencode/nemotron-3-ultra-free` | ✅ | Media | Resolución compleja |
| `opencode/nemotron-3.5-lightning-free` | ✅ | Muy rápida | Compilación/verificación LaTeX |
| `opencode/laguna-s-2.1-free` | ✅ | Rápida | Fases 2/3 |
| `opencode/hy3-free` | ✅ | Rápida | Tareas ligeras |
| `opencode/big-pickle` | ✅ | Media | Pruebas no críticas |

## Estrategia de cambio de modelo (multimodal → texto)

El protocolo recomienda:

1. **Fase 1** con modelo multimodal para ver la imagen.
2. Al aprobar, **cambiar a solo-texto** para las fases 2 y 3.

Esto ahorra cuota del proveedor multimodal y mantiene buena velocidad.

### Cómo cambiar en la TUI

```
Ctrl+X   →   selector de modelo   →   elegir modelo
```

### Verificar desde la línea de comandos

```bash
opencode models | grep "^opencode/"
```

Con esto se obtiene la lista actualizada de modelos free.

## Extensión a modelos de pago/con API

La skill no está limitada a opencode free. Cualquier modelo configurado en
`config/models.json` funciona siempre que acepte el rol adecuado:

- `multimodales[]` → Fase 1
- `solo_texto[]` → Fases 2/3

Añadir entradas nuevas al catálogo no requiere tocar el código de la skill.