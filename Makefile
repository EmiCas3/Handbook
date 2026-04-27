# =============================================================
# Handbook Makefile - stable markdown → LaTeX pipeline
# =============================================================

.RECIPEPREFIX := >

MAIN   = main
LATEX  = pdflatex
FLAGS  = -shell-escape -interaction=nonstopmode -synctex=1
OUT    = .build

export TEXINPUTS := $(CURDIR)/:

# -------------------------------------------------------------
# FIXED PANDOC FLAGS (IMPORTANT)
# -------------------------------------------------------------
PANDOC_FLAGS = \
  --from=markdown+raw_tex+tex_math_dollars+fenced_code_blocks+lists_without_preceding_blankline \
  --to=latex \
  --lua-filter=scripts/handbook.lua

.PHONY: all clean cleanall open

# -------------------------------------------------------------
# 1. Build _tex + .inputs.tex
# -------------------------------------------------------------
_pandoc:
> @rm -rf _tex .inputs.tex
> @mkdir -p _tex
> @: > .inputs.tex

> @find . -name "*.md" -not -path "./_tex/*" | sort | while IFS= read -r f; do \
      rel="$${f#./}"; \
      dir=$$(dirname "$$rel"); \
      base=$$(basename "$$rel" .md); \
      out="_tex/$$dir/$$base.tex"; \
      mkdir -p "_tex/$$dir"; \
      echo "Pandoc: $$f -> $$out"; \
      pandoc $(PANDOC_FLAGS) "$$f" -o "$$out"; \
      echo "\\input{$$out}" >> .inputs.tex; \
      echo "\\clearpage" >> .inputs.tex; \
    done

# remove last unwanted \clearpage
> @sed -i '$$d' .inputs.tex

# -------------------------------------------------------------
# 2. Compile
# -------------------------------------------------------------
all: _pandoc
> @echo "Compiling..."
> @mkdir -p $(OUT)

> @$(LATEX) $(FLAGS) -output-directory=$(OUT) $(MAIN).tex > /dev/null || true
> @$(LATEX) $(FLAGS) -output-directory=$(OUT) $(MAIN).tex > /dev/null || true

> @cp $(OUT)/$(MAIN).pdf .
> @echo "Done -> $(MAIN).pdf"

# -------------------------------------------------------------
# CLEAN
# -------------------------------------------------------------
clean:
> @rm -rf $(OUT) _tex .inputs.tex
> @echo "Cleaned"

cleanall: clean
> @rm -f $(MAIN).pdf
> @echo "Removed PDF"

# -------------------------------------------------------------
# OPEN
# -------------------------------------------------------------
open:
> @xdg-open $(MAIN).pdf 2>/dev/null || echo "Open manually"