# Ejemplos de Uso

## Ejemplo 1 — Ecuación diferencial manuscrita (básico)

```bash
# En la raíz del proyecto con .apuntexrc.json configurado
/skill apuntex foto_pizarra.png
```

Flujo esperado:

1. **Fase 1** (mimo-v2.5-free): transcribe `y' + p(x)y = q(x)` con
   `[AMBIGUO: símbolo entre ∂ y δ]`.
2. **Fase 2** (deepseek-v4-flash-free): resolución con factor integrante,
   genera `latex_complete.tex`.
3. **Fase 3**: `latexmk` compila → `apuntes/ecuacion_diff.pdf`.

## Ejemplo 2 — Circuito eléctrico trifásico (con GeoGebra)

Proyecto configurado:

```json
{
  "geogebra": { "habilitado": true },
  "dominio_especifico": { "tipo": "ingenieria_electrica", "paquetes_extra": ["circuitikz", "siunitx"] }
}
```

```bash
/skill apuntex circuito_fasores.jpg
```

Flujo esperado:

1. **Fase 1**: identifica diagrama fasorial R-S-T y tensiones de fase.
2. **Fase 2**: usa `geogebra.eval_command` para construir vectores
   `Vector((0,0), (cos(60°), sin(60°)))`, verifica con CAS, exporta SVG.
3. **Fase 3**: compila LaTeX con `circuitikz`, guarda `construccion.ggb`.

## Ejemplo 3 — Solo Markdown

```bash
/skill apuntex teorema_tales.png --formato=markdown
```

Genera `apuntes/teorema_tales.md` con `$...$` y `$$...$$` y referencia al SVG.

## Ejemplo 4 — Usar config específica por invocación

```bash
/skill apuntex portico.png --config=.apuntexrc.estructuras.json
```

Permite cambiar de config sin modificar el archivo por defecto del proyecto.

## Ejemplo 5 — Solo Fase 1 (interpretación)

```bash
/skill apuntex apuntes_desordenados.jpg --fase=1
```

Devuelve el enunciado extraído y las incertidumbres, sin resolver ni compilar.

## Ejemplo 6 — Caso de prueba del protocolo

```bash
# Verificar que el flujo faseado funciona de punta a punta
/skill apuntex --selftest
```

> (Por implementar) Suites de fixtures bajo `tests/`.

## Plantilla de checklist por transcripción

- [ ] Fase 1: interpretación aprobada por el usuario
- [ ] Fase 2: resolución confirmada
- [ ] Fase 3: PDF generado sin errores
- [ ] Modelos según estrategia (multimodal → solo-texto)