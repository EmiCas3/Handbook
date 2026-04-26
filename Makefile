# =============================================================

# Handbook Makefile (clean output)

# =============================================================

.RECIPEPREFIX := >

MAIN  = main
LATEX = pdflatex
FLAGS = -shell-escape -interaction=nonstopmode -synctex=1
OUT   = .build

.PHONY: all once watch clean cleanall open

all:

> @echo "Compiling (full build)..."
> @mkdir -p $(OUT)
> @$(LATEX) $(FLAGS) -output-directory=$(OUT) $(MAIN).tex >/dev/null
> @$(LATEX) $(FLAGS) -output-directory=$(OUT) $(MAIN).tex >/dev/null
> @cp $(OUT)/$(MAIN).pdf .
> @echo "Done -> $(MAIN).pdf"

once:

> @echo "Compiling (fast)..."
> @mkdir -p $(OUT)
> @$(LATEX) $(FLAGS) -output-directory=$(OUT) $(MAIN).tex >/dev/null
> @cp $(OUT)/$(MAIN).pdf .
> @echo "Done -> $(MAIN).pdf"

watch:

> @echo "Watching for changes... (Ctrl-C to stop)"
> @find . -name "*.md" -o -name "*.tex" | entr -c make once

clean:

> @rm -rf $(OUT)
> @rm -rf $(OUT) _markdown_cache
> @echo "Cleaned build files"

cleanall: clean

> @rm -f $(MAIN).pdf
> @echo "Removed PDF"

open: $(MAIN).pdf

> @xdg-open $(MAIN).pdf 2>/dev/null || echo "Open $(MAIN).pdf manually"

