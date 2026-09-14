# Build directives for a document that uses the HSRTReport template.
#
# Typst does not load fonts from a package, so the font path must point into
# the installed template.

TYPST ?= typst
PACKAGE ?= $(HOME)/.local/share/typst/packages/local/hsrtreport/1.0.0
FONTS := $(PACKAGE)/hsrtreport/assets/fonts
FLAGS := --font-path $(FONTS)
SRC ?= main.typ
OUT ?= build/main.pdf

.PHONY: all build watch clean

all: build

build:
	@mkdir -p $(dir $(OUT))
	$(TYPST) compile $(FLAGS) $(SRC) $(OUT)

watch:
	@mkdir -p $(dir $(OUT))
	$(TYPST) watch $(FLAGS) $(SRC) $(OUT)

clean:
	rm -rf build
