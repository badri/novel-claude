#!/usr/bin/env python3
"""Build a Notion Press print-ready interior PDF (5.5x8.5) from a book's markdown.

usage: build-print.py SRC.md OUT.pdf "Title" FIRST_HEADING [ISBN]
Everything in SRC before FIRST_HEADING (the ebook's own title/copyright) is
replaced by the print front matter below.
"""
import pathlib, re, subprocess, sys, tempfile

HERE = pathlib.Path(__file__).resolve().parent
src, out, title, first = sys.argv[1:5]
isbn = f"ISBN: {sys.argv[5]}" if len(sys.argv) > 5 else ""  # Notion Press assigns it

text = pathlib.Path(src).read_text()
text = text[text.index(f"\n{first}\n") + 1:]
# Ebook scene breaks are raw HTML, which LaTeX output drops.
text = re.sub(r'^<p (class="scenebreak"|style="text-align:center[^"]*")>.*</p>$', r"\\scenebreak", text, flags=re.M)
# An all-caps time line straight under a chapter head ("A YEAR BEFORE THE WEDDING").
text = re.sub(r"^(# [^\n]+\n\n)([A-Z][A-Z0-9 ,.’'—–-]+)\n",
              lambda m: m[1] + r"\dateline{" + m[2].title() + "}\n", text, flags=re.M)

front = rf"""
```{{=latex}}
\frontmatter\pagestyle{{empty}}
\vspace*{{5cm}}{{\centering\Huge {title}\par}}
\cleardoublepage
\vspace*{{3.5cm}}{{\centering\Huge {title}\par\vspace{{1.5cm}}\Large Saroj Anand\par}}
\newpage
\vspace*{{\fill}}{{\footnotesize\setlength{{\parindent}}{{0pt}}\setlength{{\parskip}}{{0.6em}}
\textit{{{title}}}

Copyright © 2026 Saroj Anand. All rights reserved.

No part of this book may be reproduced, stored in a retrieval system, or transmitted in any form or by any means without the prior written permission of the copyright holder, except for brief quotations in a review.

This is a work of fiction. Names, characters, places and incidents are either the product of the author's imagination or are used fictitiously. Any resemblance to actual persons, living or dead, or to actual events is entirely coincidental.

{isbn}

First paperback edition, 2026.\par}}
\cleardoublepage\mainmatter\pagestyle{{fancy}}
```
"""

with tempfile.NamedTemporaryFile("w", suffix=".md", delete=False) as f:
    f.write(front + "\n" + text)
with tempfile.NamedTemporaryFile("w", suffix=".tex", delete=False) as h:
    h.write((HERE / "print.tex").read_text()
            .replace("$title$", title).replace("$fontdir$", str(HERE / "fonts")))
subprocess.run([
    "pandoc", f.name, "-o", out, "--pdf-engine=xelatex",
    "--top-level-division=chapter",
    "-V", "documentclass=book", "-V", "classoption=openany,11pt",
    "-V", f"title-meta={title}", "-V", "author-meta=Saroj Anand",
    "-M", "title=", "--metadata", "lang=en-GB",
    "-H", h.name,
], check=True)
print("built", out)
