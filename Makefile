# =============================================================
# Handbook Makefile - stable markdown → LaTeX pipeline
# =============================================================

.RECIPEPREFIX := >

MAIN   = main
LATEX  = pdflatex
FLAGS  = -shell-escape -interaction=nonstopmode -synctex=1
OUT    = .build

export TEXINPUTS := $(CURDIR)/:

PANDOC_FLAGS = \
  --from=markdown+raw_tex+tex_math_dollars \
  --to=latex \
  --lua-filter=scripts/handbook.lua

.PHONY: all clean cleanall open

# -------------------------------------------------------------
# 1. Build _tex + input list safely (NO fragile string concat)
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
    done

# -------------------------------------------------------------
# 2. Inject into main.tex (SAFE awk version)
# -------------------------------------------------------------
_generate_main:
> @awk '\
    />>> GENERATED_BY_MAKEFILE <<< / { \
      while ((getline line < ".inputs.tex") > 0) print line; \
      close(".inputs.tex"); \
      next; \
    } \
    { print } \
  ' main.tex > main.tmp
> @mv main.tmp main.tex

# -------------------------------------------------------------
# 3. Compile
# -------------------------------------------------------------
all: _pandoc _generate_main
> @echo "Compiling..."
> @mkdir -p $(OUT)
> @$(LATEX) $(FLAGS) -output-directory=$(OUT) main.tex > /dev/null || true
> @$(LATEX) $(FLAGS) -output-directory=$(OUT) main.tex > /dev/null || true
> @cp $(OUT)/main.pdf .
> @echo "Done -> main.pdf"

# -------------------------------------------------------------
# CLEAN
# -------------------------------------------------------------
clean:
> @rm -rf $(OUT) _tex .inputs.tex main.tmp
> @echo "Cleaned"

cleanall: clean
> @rm -f main.pdf
> @echo "Removed PDF"

# -------------------------------------------------------------
# OPEN
# -------------------------------------------------------------
open:
> @xdg-open main.pdf 2>/dev/null || echo "Open manually"