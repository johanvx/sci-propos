"""Finish a pptxgenjs deck as a sci-propos PowerPoint file or template.

  * applies the theme colors and fonts (Latin and East Asian),
  * puts the logo box on the slide master (top right on every layout) and a
    centered one on the Title layout, which hides the master's (--no-logo: none),
  * colors list bullets with the primary color,
  * names the master and renames pptxgenjs' empty layout to "Blank",
  * turns the "locator" placeholder into a footer (Insert › Header & Footer
    › Footer fills it: "2 Results ·", before the slide number), and gives it
    and the slide number the same inset-free, centered text box,
  * replaces the broken PNG fallbacks pptxgenjs writes for SVG pictures,
  * optionally appends " / N" to the slides' numbers (--total): N stops at the
    last regular slide, so backup slides show their number alone,
  * saves as a template (.potx) when the output name ends in .potx.

usage:
  python3 finish.py in.pptx out.(pptx|potx) --theme theme.json
                    [--total [--total-n N]] [--no-logo]

N is --total-n if given; otherwise the number of slides before the first
section named like "Appendix" or "Backup" (also Annexe, Anhang, 附录, 附錄);
otherwise all slides. Layouts never get a static total.
"""
import argparse, json, os, re, shutil, subprocess, sys, tempfile, zipfile

ap = argparse.ArgumentParser(description="Finish a pptxgenjs deck as a sci-propos PowerPoint file.")
ap.add_argument("src")
ap.add_argument("dst")
ap.add_argument("--theme", required=True, help="theme JSON, as exported from style.js THEME")
ap.add_argument("--total", action="store_true", help='append " / N" to slide numbers')
ap.add_argument("--total-n", type=int, default=None, help="N for --total (default: slides before the backup section)")
ap.add_argument("--no-logo", action="store_true", help="no logo placeholder on the master and the Title layout")
args = ap.parse_args()

th = json.load(open(args.theme, encoding="utf-8"))
F = 960 / 841.89
EMU = lambda pt: int(round(pt * F * 12700))   # Typst pt -> EMU
PRIMARY = th["colors"]["accent1"]
BACKUP = re.compile(r"^\s*(appendix|appendices|backup|backups|back-up|annexes?|anhang|附录|附錄|备用|備用)", re.I)


def logo_xml(shape_id, x, y, w, h):
    color = '<a:solidFill><a:schemeClr val="accent1"/></a:solidFill>'
    return (
        f'<p:sp><p:nvSpPr><p:cNvPr id="{shape_id}" name="Logo (replace with your logo)" descr="Logo placeholder"/>'
        '<p:cNvSpPr/><p:nvPr userDrawn="1"/></p:nvSpPr>'
        f'<p:spPr><a:xfrm><a:off x="{EMU(x)}" y="{EMU(y)}"/><a:ext cx="{EMU(w)}" cy="{EMU(h)}"/></a:xfrm>'
        f'<a:prstGeom prst="rect"><a:avLst/></a:prstGeom><a:noFill/><a:ln w="{EMU(0.5)}">{color}</a:ln></p:spPr>'
        '<p:txBody><a:bodyPr wrap="none" lIns="45720" tIns="0" rIns="45720" bIns="0" anchor="ctr"><a:noAutofit/></a:bodyPr><a:lstStyle/>'
        f'<a:p><a:pPr algn="ctr"/><a:r><a:rPr lang="en-US" sz="{round(11 * F * 100)}">{color}<a:latin typeface="+mn-lt"/></a:rPr><a:t>[Logo]</a:t></a:r></a:p>'
        '</p:txBody></p:sp>'
    )


tmp = tempfile.mkdtemp()
with zipfile.ZipFile(args.src) as z:
    z.extractall(tmp)
    names = z.namelist()


def read(name):
    return open(os.path.join(tmp, name), encoding="utf-8").read()


def rw(name, fn):
    s = read(name)
    open(os.path.join(tmp, name), "w", encoding="utf-8").write(fn(s))


# ------------------------------------------------------------------ theme
def theme(s):
    order = ["dk1", "lt1", "dk2", "lt2", "accent1", "accent2", "accent3", "accent4", "accent5", "accent6", "hlink", "folHlink"]
    clr = "".join(f'<a:{k}><a:srgbClr val="{th["colors"][k]}"/></a:{k}>' for k in order)
    s = re.sub(r'<a:clrScheme name="[^"]*">.*?</a:clrScheme>', f'<a:clrScheme name="{th["name"]}">{clr}</a:clrScheme>', s, flags=re.S)
    for tag, face in (("majorFont", th["headFontFace"]), ("minorFont", th["bodyFontFace"])):
        s = re.sub(rf'(<a:{tag}><a:latin typeface=")[^"]*"', rf'\g<1>{face}"', s)
        s = re.sub(rf'(<a:{tag}>.*?<a:ea typeface=")[^"]*"', rf'\g<1>{th.get("eaFontFace", "")}"', s, count=1, flags=re.S)
    s = re.sub(r'<a:fontScheme name="[^"]*"', f'<a:fontScheme name="{th["name"]}"', s)
    return re.sub(r'(<a:theme [^>]*name=")[^"]*"', rf'\g<1>{th["name"]}"', s, count=1)


for n in names:
    if re.match(r"ppt/theme/theme\d+\.xml$", n):
        rw(n, theme)

# ------------------------------------------------------------------ bullets, master, layouts
bu_clr = f'<a:buClr><a:srgbClr val="{PRIMARY}"/></a:buClr>'


def color_bullets(s):
    # bullets in the primary color (not the invisible zero-width ones); numbers keep the text color
    s = re.sub(r'(?<!</a:buClr>)(<a:buChar char="(?!​|&#x200B;)[^"]*"/>)', bu_clr + r"\1", s)
    s = re.sub(r'(?<!<a:buClrTx/>)(<a:buAutoNum [^>]*/>)', r"<a:buClrTx/>\1", s)
    return s


def master(s):
    s = re.sub(r'<p:cSld(?: name="[^"]*")?>', f'<p:cSld name="{th["name"]}">', s, count=1)
    s = color_bullets(s)
    if not args.no_logo:
        s = s.replace("</p:spTree>", logo_xml(900, 700.59, 12, 101.3, 26) + "</p:spTree>", 1)
    return s


rw("ppt/slideMasters/slideMaster1.xml", master)

# The locator: the body placeholder whose prompt is LOCATOR_PROMPT (pptxgenjs
# doesn't keep placeholder names) becomes a footer placeholder; slides that
# fill it point at it by its index.
LOCATOR_PROMPT = "<a:t>2 Section ·</a:t>"
LOCATOR_IDX = set()


def to_footer(s):
    def fix(m):
        sp = m.group(0)
        if LOCATOR_PROMPT not in sp:
            return sp
        sp = re.sub(r'(<p:cNvPr id="\d+" name=")[^"]*"', r'\1Footer locator"', sp, count=1)
        idx = re.search(r'<p:ph\s[^>]*idx="(\d+)"', sp)
        if idx:
            LOCATOR_IDX.add(idx.group(1))
        return re.sub(r'(<p:ph\s[^>]*)type="body"', r'\1type="ftr"', sp)
    return re.sub(r"<p:sp>.*?</p:sp>", fix, s, flags=re.S)


FOOT_BODY = '<a:bodyPr wrap="none" lIns="0" tIns="0" rIns="0" bIns="0" anchor="ctr"><a:noAutofit/></a:bodyPr>'


def foot_body(s):
    """Give the locator and the slide number the same text box (no insets, centered
    vertically), so their text sits on one line whatever the renderer."""
    def fix(m):
        sp = m.group(0)
        if 'type="sldNum"' not in sp and 'type="ftr"' not in sp:
            return sp
        return re.sub(r"<a:bodyPr\b[^>]*?(/>|>.*?</a:bodyPr>)", FOOT_BODY, sp, count=1, flags=re.S)
    return re.sub(r"<p:sp>.*?</p:sp>", fix, s, flags=re.S)


def slide_footer(s):
    def fix(m):
        sp = m.group(0)
        idx = re.search(r'<p:ph\s[^>]*idx="(\d+)"', sp)
        if idx and idx.group(1) in LOCATOR_IDX:
            return re.sub(r'(<p:ph\s[^>]*)type="body"', r'\1type="ftr"', sp)
        return sp
    return re.sub(r"<p:sp>.*?</p:sp>", fix, s, flags=re.S)

for n in names:
    if not re.match(r"ppt/slideLayouts/slideLayout\d+\.xml$", n):
        continue
    s = read(n)
    name = re.search(r'<p:cSld name="([^"]*)"', s).group(1)
    if name == "DEFAULT":
        s = s.replace('<p:cSld name="DEFAULT"', '<p:cSld name="Blank"', 1)
    if name in ("Title", "Title with Image", "Focus", "Black") and "showMasterSp" not in s:
        s = re.sub(r"<p:sldLayout ", '<p:sldLayout showMasterSp="0" ', s, count=1)
    if name == "Title" and not args.no_logo:
        s = s.replace("</p:spTree>", logo_xml(901, 356.6, 28, 128.7, 33.8) + "</p:spTree>", 1)
    if name == "Title with Image" and not args.no_logo:
        s = s.replace("</p:spTree>", logo_xml(901, 40, 28, 128.7, 33.8) + "</p:spTree>", 1)
    s = foot_body(to_footer(s))
    # layouts keep the live slide-number field only: never a static total
    open(os.path.join(tmp, n), "w", encoding="utf-8").write(color_bullets(s))

# ------------------------------------------------------------------ slides, in presentation order
for n in names:
    if re.match(r"ppt/slides/slide\d+\.xml$", n):
        rw(n, lambda t: foot_body(slide_footer(t)))
rw("ppt/slideMasters/slideMaster1.xml", foot_body)

pres = read("ppt/presentation.xml")
pres_rels = read("ppt/_rels/presentation.xml.rels")
rid_target = dict(re.findall(r'Id="(rId\d+)"[^>]*Target="(slides/slide\d+\.xml)"', pres_rels))
rid_target.update({a: b for b, a in re.findall(r'Target="(slides/slide\d+\.xml)"[^>]*Id="(rId\d+)"', pres_rels)})
order = []  # (slide id, part name)
for sid, rid in re.findall(r'<p:sldId id="(\d+)" r:id="(rId\d+)"', pres):
    order.append((sid, "ppt/" + rid_target[rid]))

n_slides = len(order)
total_n = args.total_n
if total_n is None:
    for m in re.finditer(r'<p14:section name="([^"]*)"[^>]*>\s*<p14:sldIdLst>(.*?)</p14:sldIdLst>', pres, re.S):
        if BACKUP.match(m.group(1)):
            first = re.search(r'<p14:sldId id="(\d+)"', m.group(2))
            if first:
                total_n = [sid for sid, _ in order].index(first.group(1))
            break
if total_n is None:
    total_n = n_slides


def add_total(t):
    return re.sub(r'(<a:fld [^>]*type="slidenum"[^>]*>.*?</a:fld>)',
                  lambda m: m.group(1) + f'<a:r><a:rPr lang="en-US" dirty="0"/><a:t> / {total_n}</a:t></a:r>', t, flags=re.S)


for i, (_, part) in enumerate(order, start=1):
    rw(part, lambda t: add_total(color_bullets(t)) if args.total and i <= total_n else color_bullets(t))

# ------------------------------------------------------------------ SVG pictures: real PNG fallbacks
def svg_to_png(svg, png):
    """Rasterize an SVG at 3x with the first converter found. True on success."""
    tries = [
        ["rsvg-convert", "-z", "3", "-o", png, svg],
        ["inkscape", svg, "--export-type=png", f"--export-filename={png}", "--export-dpi=288"],
        ["node", "-e", "require('sharp')(process.argv[1],{density:288}).png().toFile(process.argv[2])"
         ".catch(e=>{console.error(e);process.exit(1)})", svg, png],
    ]
    for cmd in tries:
        if shutil.which(cmd[0]) is None:
            continue
        try:
            subprocess.run(cmd, check=True, capture_output=True, timeout=120)
            with open(png, "rb") as f:
                if f.read(8) == b"\x89PNG\r\n\x1a\n":
                    return True
        except Exception:
            pass
    return False


fixed, broken = 0, 0
for n in names:
    m = re.match(r"ppt/slides/(slide\d+\.xml)$", n)
    if not m:
        continue
    rels_name = f"ppt/slides/_rels/{m.group(1)}.rels"
    if rels_name not in names:
        continue
    xml, rels = read(n), read(rels_name)
    targets = dict(re.findall(r'Id="(rId\d+)"[^>]*Target="([^"]+)"', rels))
    for png_rid, svg_rid in re.findall(r'<a:blip r:embed="(rId\d+)".*?<asvg:svgBlip [^>]*r:embed="(rId\d+)"', xml, re.S):
        png = os.path.normpath(os.path.join(tmp, "ppt/slides", targets[png_rid]))
        svg = os.path.normpath(os.path.join(tmp, "ppt/slides", targets[svg_rid]))
        with open(png, "rb") as f:
            if f.read(8) == b"\x89PNG\r\n\x1a\n":
                continue  # already a real PNG
        if svg_to_png(svg, png):
            fixed += 1
        else:
            broken += 1
if fixed:
    print(f"replaced {fixed} SVG fallback picture(s) with PNG renders")
if broken:
    print(f"warning: {broken} SVG picture(s) keep a broken PNG fallback; install rsvg-convert "
          "(librsvg), Inkscape, or Node's sharp, or insert PNG pictures instead", file=sys.stderr)

# ------------------------------------------------------------------ template and write
if args.dst.endswith(".potx"):
    rw("[Content_Types].xml", lambda s: s.replace(
        "application/vnd.openxmlformats-officedocument.presentationml.presentation.main+xml",
        "application/vnd.openxmlformats-officedocument.presentationml.template.main+xml"))

if os.path.exists(args.dst):
    os.remove(args.dst)
with zipfile.ZipFile(args.dst, "w", zipfile.ZIP_DEFLATED) as z:
    for n in ["[Content_Types].xml"] + [n for n in names if n != "[Content_Types].xml"]:
        z.write(os.path.join(tmp, n), n)
shutil.rmtree(tmp)
if args.total:
    print(f'slide numbers: " / {total_n}" on slides 1–{total_n}' + (f", number alone on {total_n + 1}–{n_slides}" if total_n < n_slides else ""))
print("wrote", args.dst)
