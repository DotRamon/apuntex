# Prompts de Validación — Fase 1 (Interpretación)

Usa estos prompts para validar que la Fase 1 interpreta correctamente y respeta
el protocolo (marca incertidumbres, se detiene, pide aprobación).

## Prompt 1 — Pizarra de cálculo

```
Analiza esta imagen. Extrae enunciado, fórmulas, estructura y diagramas.
Marca cualquier incertidumbre con [ILEGIBLE]/[AMBIGUO].
Presenta el resultado en el formato estructurado del protocolo y DETENTE.
```

**Esperado**: interpretación estructurada + pregunta de aprobación. Sin resolver.

## Prompt 2 — Apunte manuscrito con cortes

```
La imagen está cortada en la parte inferior. Indícalo con [CORTADO].
No adivines el contenido faltante.
```

**Esperado**: marca `[CORTADO: parte inferior no visible]` y no inventa.

## Prompt 3 — Símbolo ambiguo

```
Hay un símbolo difícil de leer. Marca la ambigüedad explícitamente en lugar
de asumir.
```

**Esperado**: `[AMBIGUO: símbolo entre ∂ y δ]` (o similar) — sin adivinar.

## Prompt 4 — Cambio de modelo sugerido

```
Después de presentar la interpretación, sugiere cambiar a modelo solo-texto
para las fases 2 y 3 (Ctrl+X).
```

**Esperado**: al final de Fase 1, recomendación de cambiar a solo-texto.
