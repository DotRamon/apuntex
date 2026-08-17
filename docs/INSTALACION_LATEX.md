# Instalación de LaTeX por Sistema Operativo

El protocolo Apuntex necesita un compilador LaTeX en el sistema para la Fase 3
(generar PDFs). Elige la guía de tu SO.

> **¿Ya tienes LaTeX?** Verifica con: `latexmk --version` (Linux/Mac) o
> `latexmk --version` en CMD/PowerShell (Windows). Si responde, puedes saltarte
> esta sección.

---

## Linux

### Debian / Ubuntu / Mint

```bash
sudo apt update
sudo apt install -y texlive-latex-recommended texlive-latex-extra latexmk
# Para fuentes extra y más paquetes (pesado pero completo):
# sudo apt install -y texlive-full
```

### Arch / Manjaro

```bash
sudo pacman -S texlive-most latexmk
```

### Fedora

```bash
sudo dnf install -y texlive-scheme-medium latexmk
# o completo:
# sudo dnf install -y texlive-scheme-full
```

---

## macOS

### Recomendado: MacTeX (completo)

```bash
brew install --cask mactex
# ~5 GB, incluye latexmk. Luego reabrir la terminal.
```

### Alternativa ligera: BasicTeX + latexmk

```bash
brew install --cask basictex
# Instala solo lo esencial, agrega PATH:
export PATH="/usr/local/texlive/$(ls /usr/local/texlive | tail -1)/bin/universal-darwin:$PATH"

# Instalar latexmk y paquetes comunes:
sudo tlmgr update --self
sudo tlmgr install latexmk amsmath graphicx geometry babel-spanish
```

---

## Windows

### Opción A: MiKTeX (recomendada)

1. Descargar instalador: <https://miktex.org/download>
2. Instalar con opción "Install missing packages on the fly = Yes".
3. MiKTeX incluye `latexmk`. Al instalarlo, marca "Add to PATH" si se ofrece.
4. Verificar en CMD:
   ```cmd
   latexmk --version
   ```

### Opción B: TeX Live (WSL2 recomendado)

```bash
# Dentro de WSL2 (Linux), seguir la guía de Debian/Ubuntu anterior.
# Abrir opencode dentro de WSL2 para que vea latexmk.
```

### Opción C: TeX Live nativo en Windows

Descargar de <https://tug.org/texlive/> e instalar. Añadir
`C:\texlive\<año>\bin\windows` al PATH manualmente.

---

## Verificación final (todos los SO)

```bash
latexmk --version
xelatex --version   # opcional
```

Si ambos responden, la Fase 3 de Apuntex podrá compilar PDFs.

---

## Nota sobre compilador por defecto

El protocolo usa `latexmk` por defecto (detecta el motor automáticamente).
Puedes cambiarlo en `.apuntexrc.json`:

```json
{
  "preferencias": {
    "compilador": "xelatex"
  }
}
```

Opciones: `latexmk`, `xelatex`, `pdflatex`, `lualatex`.
