#!/usr/bin/env python3
"""Normalize the name tables of the bundled fonts.

The vendor TTFs declare one font family per file ("Blender-Bold", "DIN Medium",
...). Typst selects a face by family plus weight and style, so it cannot find a
bold or an italic in such a set. This script rewrites the name and OS/2 tables
so that all faces of a typeface share one family name.

Run it against the vendor files after an update:

    nix run nixpkgs#python3Packages.fonttools -- ... # see Makefile target `fonts`
"""

import sys
from pathlib import Path

from fontTools.ttLib import TTFont

# file stem -> (family, typographic subfamily, weight class, italic)
FACES = {
    "Blender": {
        "Blender-Thin": ("Blender", "Thin", 100, False),
        "Blender-ThinItalic": ("Blender", "Thin Italic", 100, True),
        "Blender-Book": ("Blender", "Light", 300, False),
        "Blender-BookItalic": ("Blender", "Light Italic", 300, True),
        "Blender-Medium": ("Blender", "Regular", 400, False),
        "Blender-MediumItalic": ("Blender", "Italic", 400, True),
        "Blender-Strong": ("Blender", "SemiBold", 600, False),
        "Blender-Bold": ("Blender", "Bold", 700, False),
        "Blender-BoldItalic": ("Blender", "Bold Italic", 700, True),
    },
    "DIN": {
        "DIN-Regular": ("DIN", "Regular", 400, False),
        "DIN-Italic": ("DIN", "Italic", 400, True),
        "DIN-Medium": ("DIN", "Medium", 500, False),
        "DIN-Bold": ("DIN", "Bold", 700, False),
        "DIN-BoldItalic": ("DIN", "Bold Italic", 700, True),
        "DIN-Black": ("DIN", "Black", 900, False),
    },
}

RIBBI = {"Regular", "Italic", "Bold", "Bold Italic"}

FS_SELECTION_ITALIC = 1 << 0
FS_SELECTION_BOLD = 1 << 5
FS_SELECTION_REGULAR = 1 << 6

MAC = dict(platformID=1, platEncID=0, langID=0x0)
WIN = dict(platformID=3, platEncID=1, langID=0x409)


def set_name(font, value, name_id):
    for platform in (MAC, WIN):
        font["name"].setName(value, name_id, **platform)


def patch(path, family, subfamily, weight, italic):
    font = TTFont(path)

    if subfamily in RIBBI:
        legacy_family, legacy_subfamily = family, subfamily
    else:
        legacy_family = f"{family} {subfamily}"
        legacy_subfamily = "Italic" if italic else "Regular"

    full_name = family if subfamily == "Regular" else f"{family} {subfamily}"
    postscript_name = f"{family}-{subfamily.replace(' ', '')}"

    set_name(font, legacy_family, 1)
    set_name(font, legacy_subfamily, 2)
    set_name(font, full_name, 4)
    set_name(font, postscript_name, 6)
    set_name(font, family, 16)
    set_name(font, subfamily, 17)

    os2 = font["OS/2"]
    os2.usWeightClass = weight
    selection = os2.fsSelection & ~(
        FS_SELECTION_ITALIC | FS_SELECTION_BOLD | FS_SELECTION_REGULAR
    )
    if italic:
        selection |= FS_SELECTION_ITALIC
    if weight >= 700:
        selection |= FS_SELECTION_BOLD
    if not italic and weight < 700:
        selection |= FS_SELECTION_REGULAR
    os2.fsSelection = selection

    font["head"].macStyle = (2 if italic else 0) | (1 if weight >= 700 else 0)
    font["post"].italicAngle = font["post"].italicAngle if italic else 0.0

    font.save(path)
    print(f"patched {path.name}: {family} / {subfamily} / {weight}")


def main(root):
    for directory, faces in FACES.items():
        for stem, spec in faces.items():
            path = root / directory / f"{stem}.ttf"
            if not path.exists():
                print(f"missing {path}", file=sys.stderr)
                continue
            patch(path, *spec)


if __name__ == "__main__":
    main(Path(sys.argv[1] if len(sys.argv) > 1 else "hsrtreport/assets/fonts"))
