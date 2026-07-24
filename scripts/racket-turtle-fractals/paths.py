"""Shared paths for racket-turtle-fractals build scripts."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
BOOK_SLUG = "racket-turtle-fractals"
BOOK_MD = ROOT / "manuscript/racket-turtle-fractals/book.md"
OUT_DIR = ROOT / "output/racket-turtle-fractals"
ASSETS = ROOT / "assets/epub"
COVER = ROOT / "images/cover.jpg"

TITLE = "自己相似形グラフィック入門"
SUBTITLE = "Racket タートルで学ぶフラクタルと再帰"
AUTHOR = "陸機雑学ファクトリー / Grok 4.5"
EPUB_BASENAME = "自己相似形グラフィック入門"

APPENDIX_C_MARKER = "rackunit"

DEFAULT_OUTPUT = {
    "epub-horizontal": OUT_DIR / f"{EPUB_BASENAME}-横書き.epub",
    "epub-vertical": OUT_DIR / f"{EPUB_BASENAME}-縦書き.epub",
    "docx": OUT_DIR / f"{EPUB_BASENAME}.docx",
}
