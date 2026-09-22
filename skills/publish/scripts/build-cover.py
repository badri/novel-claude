#!/usr/bin/env python3
"""Build a Notion Press full-wrap paperback cover PDF, laid out on the book's own template.

usage: build-cover.py FRONT.jpg BLURB.txt OUT.pdf "TITLE" TEMPLATE.pdf TEXTBOX
TEXTBOX is where the front art's own lettering sits, as fractions of the art:
"x0,y0,x1,y1". The art is scaled and placed so that box lands inside the
template's front safe zone; any panel the art no longer covers is filled by
smearing the art's edge pixels outward.
TEMPLATE.pdf is the per-book file from Notion Press (step 2 -> Cover Design ->
Download Template). Page size, trim and spine lines, the pink safe zones and the
blue barcode box are all read off it, so the cover always matches their spec.
"""
import pathlib, subprocess, sys, tempfile
from PIL import Image, ImageDraw, ImageFont, ImageFilter

DPI = 300
front_path, blurb_path, out, title, template, textbox = sys.argv[1:7]
tx0, ty0, tx1, ty1 = map(float, textbox.split(","))
px = lambda inches: round(inches * DPI)

with tempfile.TemporaryDirectory() as tmp:
    subprocess.run(["pdftoppm", "-r", str(DPI), "-png", "-singlefile", template, f"{tmp}/t"], check=True)
    tpl = Image.open(f"{tmp}/t.png").convert("RGB")
W, H = tpl.size
info = subprocess.run(["pdfinfo", template], capture_output=True, text=True, check=True).stdout
page_w_pt = float(info.split("Page size:")[1].split()[0])
t = tpl.load()

def runs(xs):  # group consecutive integers -> list of (first, last)
    out = []
    for x in xs:
        if out and x == out[-1][1] + 1: out[-1][1] = x
        else: out.append([x, x])
    return out

# Dashed trim/spine guides: columns that are dark in many places.
guides = [(a + b) // 2 for a, b in runs([x for x in range(W)
          if sum(t[x, y][0] < 100 for y in range(0, H, 4)) > H / 24])]
trim_l, spine_x0, spine_x1, trim_r = guides
def box(color, x_lo, x_hi):  # bounding box of one template colour between two x limits
    xs = [x for x in range(x_lo, x_hi, 2) if any(t[x, y] == color for y in range(0, H, 8))]
    ys = [y for y in range(0, H, 2) if any(t[x, y] == color for x in range(x_lo, x_hi, 8))]
    return xs[0], ys[0], xs[-1], ys[-1]
PINK, BLUE = (250, 189, 211), (164, 219, 225)
back_safe, front_safe = box(PINK, 0, spine_x0), box(PINK, spine_x1, W)
barcode = box(BLUE, 0, spine_x0)
front_x0 = spine_x1
spine_w = spine_x1 - spine_x0

art = Image.open(front_path).convert("RGB")
# Back and spine: one flat dark colour taken from the art. A blurred, darkened
# photo here posterised into blotches in print preview (8-bit banding in the darks).
bg = tuple(int(c * 0.45) for c in art.resize((1, 1), Image.LANCZOS).getpixel((0, 0)))
cover = Image.new("RGB", (W, H), bg)

# Front: largest scale that keeps the lettering inside the safe zone (never
# larger than needed to cover the panel), lettering centred in the zone.
MARGIN = px(0.12)  # Notion Press's checker flagged lettering placed right on the safe line
sx0, sy0, sx1, sy1 = (front_safe[0] + MARGIN, front_safe[1] + MARGIN,
                      front_safe[2] - MARGIN, front_safe[3] - MARGIN)
panel_w = W - front_x0
cover_scale = max(panel_w / art.width, H / art.height)
scale = min(cover_scale, (sx1 - sx0) / ((tx1 - tx0) * art.width), (sy1 - sy0) / ((ty1 - ty0) * art.height))
fw, fh = round(art.width * scale), round(art.height * scale)
art = art.resize((fw, fh), Image.LANCZOS)
left = round((sx0 + sx1) / 2 - (tx0 + tx1) / 2 * fw) - front_x0
top_ = round((sy0 + sy1) / 2 - (ty0 + ty1) / 2 * fh)
# Fill the panel the art no longer covers by smearing its outermost pixels
# outward (then blurring the smear). Mirroring was tried and showed reversed
# lettering wherever the art's type runs close to its edge.
import numpy as np
pad = [(max(0, top_), max(0, H - top_ - fh)), (max(0, left), max(0, panel_w - left - fw)), (0, 0)]
a = np.asarray(art)[max(0, -top_):fh - max(0, top_ + fh - H), max(0, -left):fw - max(0, left + fw - panel_w)]
smear = Image.fromarray(np.pad(a, pad, mode="edge")).filter(ImageFilter.GaussianBlur(90))
# Feather the art into the smear over 60px so there is no hard seam.
f = 60
mask = Image.new("L", (a.shape[1], a.shape[0]), 0)
ImageDraw.Draw(mask).rectangle([f, f, a.shape[1] - f, a.shape[0] - f], fill=255)
mask = mask.filter(ImageFilter.GaussianBlur(f / 2))
edges = [pad[1][0], pad[0][0], pad[1][1], pad[0][1]]  # only feather sides that border a smear
for side, amount in enumerate(edges):
    if amount == 0:
        box = [(0, 0, f, a.shape[0]), (0, 0, a.shape[1], f), (a.shape[1] - f, 0, a.shape[1], a.shape[0]), (0, a.shape[0] - f, a.shape[1], a.shape[0])][side]
        mask.paste(255, box)
smear.paste(Image.fromarray(a), (pad[1][0], pad[0][0]), mask)
cover.paste(smear, (front_x0, 0))

fonts = pathlib.Path(__file__).resolve().parent / "fonts"
font = lambda name, size: ImageFont.truetype(str(fonts / f"EBGaramond-{name}.otf"), size)
draw = ImageDraw.Draw(cover)
ink = (240, 236, 228)

# Spine: title and author, reading top to bottom (English convention).
spine_font = font("SemiBold", min(int(spine_w * 0.6), 64))
label = f"{title.upper()}      SAROJ ANAND"
tw, th = draw.textbbox((0, 0), label, font=spine_font)[2:]
strip = Image.new("RGBA", (tw, th + 20), (0, 0, 0, 0))
ImageDraw.Draw(strip).text((0, 0), label, font=spine_font, fill=ink)
strip = strip.rotate(-90, expand=True)
cover.paste(strip, (spine_x0 + (spine_w - strip.width) // 2, (H - strip.height) // 2), strip)

# Back: blurb at the largest size (11.5pt down) that fits above the barcode space,
# centred vertically in that space.
x0, top, x1, _ = back_safe
barcode_top = barcode[1] - px(0.15)

def layout(size):
    body, lead = font("Regular", size), round(size * 1.4)
    lines, y = [], 0
    for para in pathlib.Path(blurb_path).read_text().strip().split("\n\n"):
        line = ""
        for word in para.split():
            trial = f"{line} {word}".strip()
            if draw.textlength(trial, font=body) > x1 - x0:
                lines.append((y, line)); y += lead; line = word
            else:
                line = trial
        lines.append((y, line)); y += lead + size // 2
    return body, lines, y

for size in range(48, 30, -1):
    body, lines, height = layout(size)
    if height <= barcode_top - top:
        break
else:
    sys.exit("blurb does not fit on the back cover")
y0 = top + (barcode_top - top - height) // 2
for y, line in lines:
    draw.text((x0, y0 + y), line, font=body, fill=ink)

# Lossless PNG inside a PDF page of the template's exact size (PIL's PDF writer
# would JPEG-compress it).
import fitz, io
page_h_pt = float(info.split("Page size:")[1].split()[2])
buf = io.BytesIO(); cover.save(buf, "PNG")
doc = fitz.open(); page = doc.new_page(width=page_w_pt, height=page_h_pt)
page.insert_image(page.rect, stream=buf.getvalue())
doc.save(out, deflate=True)
print(f"built {out}: {W / DPI:.3f} x {H / DPI:.3f} in, spine {spine_w / DPI:.3f} in")
