#!/usr/bin/env python3
"""Build a retailer-safe EPUB 3 from a publication master, then epubcheck it.

usage: build-epub.py SRC.md OUT.epub COVER.jpg "Title" ["Author"]

Fixes two pandoc defaults that break Kindle and stricter stores:
1. pandoc's built-in epub.css hardcodes a near-white background and charcoal
   text (grey wash on e-ink, fights dark mode) -> use epub-kindle.css instead.
2. pandoc emits <meta property="cover">, valid in neither EPUB 2 nor 3 ->
   rewrite it to name="cover", keeping mimetype first and uncompressed.
"""
import pathlib, shutil, subprocess, sys, zipfile

HERE = pathlib.Path(__file__).resolve().parent
src, out, cover, title = sys.argv[1:5]
author = sys.argv[5] if len(sys.argv) > 5 else "Saroj Anand"

subprocess.run([
    "pandoc", src, "-o", out,
    "--toc", "--toc-depth=1", "--split-level=1",
    f"--css={HERE / 'epub-kindle.css'}", f"--epub-cover-image={cover}",
    "--metadata", f"title={title}", "--metadata", f"author={author}",
], check=True)

tmp = out + ".tmp"
shutil.move(out, tmp)
with zipfile.ZipFile(tmp) as zin, zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as zout:
    names = zin.namelist()
    assert names[0] == "mimetype", names[0]
    zout.writestr(zipfile.ZipInfo("mimetype"), zin.read("mimetype"), zipfile.ZIP_STORED)
    for name in names[1:]:
        data = zin.read(name)
        if name.endswith(".opf"):
            data = data.replace(b'<meta property="cover"', b'<meta name="cover"')
        zout.writestr(name, data)
pathlib.Path(tmp).unlink()
print("built", out)

if shutil.which("epubcheck"):
    sys.exit(subprocess.run(["epubcheck", out]).returncode)
print("epubcheck not installed; run it before uploading")
