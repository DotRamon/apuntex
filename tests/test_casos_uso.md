# Casos de Uso de Prueba

Estos casos documentan el comportamiento esperado del protocolo. Úsalos como
referencia para probar manualmente o como base para fixtures automatizados.

## Caso 1 — Ecuación diferencial manuscrita (básico)

- **Entrada**: foto de pizarra con `y' + p(x)y = q(x)`
- **Fase 1 esperada**: transcripción del enunciado; marcar `[AMBIGUO]` si el
  símbolo entre `∂`/`δ` no es legible.
- **Fase 2 esperada**: resolución con factor integrante; LaTeX completo.
- **Fase 3 esperada**: PDF generado sin errores.

## Caso 2 — Circuito eléctrico trifásico (GeoGebra)

- **Entrada**: diagrama fasorial R-S-T.
- **Config**: `.apuntexrc.json` con `geogebra.habilitado=true`, dominio
  `ingenieria_electrica`.
- **Fase 2 esperada**: construcción de vectores con `eval_command`, verificación
  CAS, export SVG.
- **Fase 3 esperada**: LaTeX con `circuitikz`, archivo `.ggb` guardado.

## Caso 3 — Demostración geométrica (Markdown)

- **Entrada**: figura del teorema de Tales.
- **Config**: `--formato=markdown`.
- **Fase 2 esperada**: Markdown con `$...$`/`$$...$$` y referencia al SVG.
- **Fase 3 esperada**: `.md` + SVG generados.

## Caso 4 — Modelo solo-texto en fases 2/3

- **Entrada**: cualquier imagen, con cambio de modelo en TUI (Ctrl+X).
- **Esperado**: Fase 1 con multimodal (`mimo-v2.5-free`), Fases 2/3 con
  solo-texto (`deepseek-v4-flash-free`), sin interrupción del flujo.

## Checklist por caso

- [ ] Fase 1: interpretación aprobada
- [ ] Fase 2: resolución confirmada
- [ ] Fase 3: PDF/archivos generados
- [ ] Cambio de modelo correcto (si aplica)