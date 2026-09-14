# Build directives for the HSRTReport Typst template.

# Use a local typst if there is one, else run it through nix.
TYPST ?= $(shell command -v typst >/dev/null 2>&1 && echo typst || echo nix run nixpkgs\#typst --)
SRC ?= src/main.typ
OUT ?= build/main.pdf
FONTS := hsrtreport/assets/fonts
FLAGS := --root . --font-path $(FONTS)

.PHONY: all build watch open clean fonts help

all: build

## build: compile the document to $(OUT)
build:
	@mkdir -p $(dir $(OUT))
	$(TYPST) compile $(FLAGS) $(SRC) $(OUT)

## watch: recompile on every change
watch:
	@mkdir -p $(dir $(OUT))
	$(TYPST) watch $(FLAGS) $(SRC) $(OUT)

## open: open the compiled document
open: build
	xdg-open $(OUT)

## fonts: normalize the name tables of the bundled fonts
fonts:
	nix shell nixpkgs#python3Packages.fonttools nixpkgs#python3 \
		-c python3 tools/patch-fonts.py $(FONTS)

## clean: remove the build directory
clean:
	rm -rf build

## help: list the targets
help:
	@grep -E '^## ' $(MAKEFILE_LIST) | sed 's/## //'
