#!/usr/bin/env python3
"""Draw a KDP paperback cover template that build-cover.py can read.

usage: kdp-cover-template.py PAGES OUT.pdf [cream|white] [TRIM_W TRIM_H]
Same conventions as Notion Press's template: dark vertical trim/spine guides,
pink safe zones, blue barcode box. Geometry is KDP's published spec: 0.125 in
bleed, spine = pages x 0.0025 in (cream) or 0.002252 in (white), text 0.125 in
inside trim, barcode 2 x 1.2 in placed 0.25 in from the spine and bottom trim.
"""
import sys, fitz

pages, out = int(sys.argv[1]), sys.argv[2]
paper = sys.argv[3] if len(sys.argv) > 3 else "cream"
tw, th = (float(sys.argv[4]), float(sys.argv[5])) if len(sys.argv) > 5 else (5.5, 8.5)
BLEED, SAFE = 0.125, 0.125
spine = pages * {"cream": 0.0025, "white": 0.002252}[paper]
W, H = 2 * (BLEED + tw) + spine, th + 2 * BLEED
pt = lambda inches: inches * 72

doc = fitz.open(); page = doc.new_page(width=pt(W), height=pt(H))
rect = lambda x0, y0, x1, y1, rgb: page.draw_rect(fitz.Rect(pt(x0), pt(y0), pt(x1), pt(y1)), color=None, fill=[c / 255 for c in rgb])
sx0, sx1 = BLEED + tw, BLEED + tw + spine
rect(BLEED + SAFE, BLEED + SAFE, sx0 - SAFE, H - BLEED - SAFE, (250, 189, 211))  # back safe
rect(sx1 + SAFE, BLEED + SAFE, W - BLEED - SAFE, H - BLEED - SAFE, (250, 189, 211))  # front safe
rect(sx0 - 0.25 - 2, H - BLEED - 0.25 - 1.2, sx0 - 0.25, H - BLEED - 0.25, (164, 219, 225))  # barcode
for x in (BLEED, sx0, sx1, W - BLEED):  # trim and spine guides, full height
    page.draw_line(fitz.Point(pt(x), 0), fitz.Point(pt(x), pt(H)), color=(0, 0, 0), width=1)
doc.save(out)
print(f"{out}: {W:.3f} x {H:.3f} in, spine {spine:.3f} in ({pages} pp, {paper})")
