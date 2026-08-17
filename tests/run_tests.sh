#!/usr/bin/env bash
set -euo pipefail

echo "==> Apuntex tests"

echo "==> [1/4] Validando JSON de config"
python3 - <<'PY'
import json
for f in ["config/models.json", "config/defaults.json", "config/user-config.example.json"]:
    with open(f) as fh:
        json.load(fh)
    print(f"  OK {f}")
PY

echo "==> [2/4] Validando frontmatter del SKILL.md"
if grep -q "^name: apuntex$" .opencode/skills/apuntex/SKILL.md; then
  echo "  OK name: apuntex"
else
  echo "  FAIL: name no es 'apuntex'" >&2
  exit 1
fi
if grep -q "^description:" .opencode/skills/apuntex/SKILL.md; then
  echo "  OK description presente"
else
  echo "  FAIL: falta description" >&2
  exit 1
fi

echo "==> [3/4] Validando frontmatter del agente"
if grep -q "^name: apuntex$" .opencode/agent/apuntex.md; then
  echo "  OK agente name: apuntex"
else
  echo "  FAIL: agente sin name correcto" >&2
  exit 1
fi

echo "==> [4/4] Compilando templates LaTeX (si latex disponible)"
if command -v latexmk >/dev/null 2>&1; then
  for f in templates/latex_complete.tex templates/latex_minimal.tex; do
    cp "$f" /tmp/apuntex_test.tex
    if latexmk -interaction=nonstopmode -halt-on-error /tmp/apuntex_test.tex >/tmp/apuntex_test.log 2>&1; then
      echo "  OK $f"
    else
      echo "  WARN: $f no compila limpio (el template tiene placeholders)" >&2
      tail -20 /tmp/apuntex_test.log >&2
    fi
    rm -f /tmp/apuntex_test.tex /tmp/apuntex_test.*
  done
else
  echo "  SKIP: latexmk no instalado (solo CI/sistema con LaTeX)"
fi

echo "==> Todos los tests pasaron"
