"""
post-render-copy-html.py

Quarto post-render script.
Copies pre-generated HTML files from research_data/data-xml-dtd/ into
docs/data/ so they are available as static pages in the Quarto site.

Run automatically by Quarto after `quarto render`.
Can also be run manually: python scripts/post-render-copy-html.py
"""

import shutil
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
SRC_DIR = PROJECT_ROOT / "research_data" / "data-xml-dtd"
DST_DIR = PROJECT_ROOT / "docs" / "data"

HTML_FILES = [
    "authors-ar6.html",
    "acronyms-ar6.html",
    "bibliographic-ar6.html",
    "corpus-ar6.html",
    "glossary-ar6.html",
]

DST_DIR.mkdir(parents=True, exist_ok=True)

errors = 0
for name in HTML_FILES:
    src = SRC_DIR / name
    if src.exists():
        shutil.copy2(src, DST_DIR / name)
        print(f"  [ok] Copied {name}")
    else:
        print(f"  [warn] Not found: {src} — run generate-html.ps1 first", file=sys.stderr)
        errors += 1

print(f"\npost-render: {len(HTML_FILES) - errors} copied, {errors} missing")
sys.exit(1 if errors else 0)
