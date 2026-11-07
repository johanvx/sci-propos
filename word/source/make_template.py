"""Build the sci-propos Word report template (.dotx) with python-docx.

The styles follow the Typst package sci-propos-writing: serif body (Cambria,
which comes with Office), bold sans headings (Calibri), captions with the
label in bold sans, a three-line table style, page numbers centered at the
bottom. The document itself is a one-page style guide with placeholders.

usage (from this folder):
  uv run --with python-docx python make_template.py ../sci-propos-report.dotx [--paper a4|us-letter]
"""
import argparse, copy, os, re, shutil, tempfile, zipfile

from docx import Document
from docx.enum.section import WD_SECTION
from docx.enum.style import WD_STYLE_TYPE
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Cm, Inches, Pt, RGBColor

ap = argparse.ArgumentParser()
ap.add_argument("out")
ap.add_argument("--paper", default="a4", choices=["a4", "us-letter"])
args = ap.parse_args()

BODY, HEAD, CODE = "Cambria", "Calibri", "Consolas"
EA_BODY, EA_HEAD = "SimSun", "DengXian"       # East Asian fonts that come with Office
PRIMARY = RGBColor(0x00, 0x56, 0x1F)
TEXT = RGBColor(0x14, 0x14, 0x14)
MUTED = RGBColor(0x50, 0x50, 0x50)

doc = Document()
sec = doc.sections[0]
if args.paper == "a4":
    sec.page_width, sec.page_height = Cm(21), Cm(29.7)
    for side in ("left_margin", "right_margin", "top_margin", "bottom_margin"):
        setattr(sec, side, Cm(2.5))
else:
    sec.page_width, sec.page_height = Inches(8.5), Inches(11)
    for side in ("left_margin", "right_margin", "top_margin", "bottom_margin"):
        setattr(sec, side, Inches(1))


def fonts(style, latin, ea):
    rpr = style.element.get_or_add_rPr()
    rf = rpr.find(qn("w:rFonts"))
    if rf is None:
        rf = OxmlElement("w:rFonts")
        rpr.insert(0, rf)
    for k in ("w:ascii", "w:hAnsi", "w:cs"):
        rf.set(qn(k), latin)
    rf.set(qn("w:eastAsia"), ea)
    for k in ("w:asciiTheme", "w:hAnsiTheme", "w:eastAsiaTheme", "w:cstheme"):
        if rf.get(qn(k)) is not None:
            del rf.attrib[qn(k)]


def para_style(name, latin, ea, size, bold=False, color=TEXT, before=0, after=6, keep=False,
               base=None, italic=False, align=None, line=1.15):
    st = doc.styles[name] if name in [s.name for s in doc.styles] else doc.styles.add_style(name, WD_STYLE_TYPE.PARAGRAPH)
    if base:
        st.base_style = doc.styles[base]
    fonts(st, latin, ea)
    f = st.font
    f.size, f.bold, f.italic, f.color.rgb = Pt(size), bold, italic, color
    pf = st.paragraph_format
    pf.space_before, pf.space_after, pf.keep_with_next = Pt(before), Pt(after), keep
    pf.line_spacing = line
    if align is not None:
        pf.alignment = align
    return st


# Body: serif 11 pt, ragged right, space between paragraphs (Alley, Appendix D).
para_style("Normal", BODY, EA_BODY, 11, after=8)
para_style("Title", HEAD, EA_HEAD, 20, bold=True, after=6, keep=True, line=1.0)
# python-docx's default Title has a colored rule under it: remove it.
for b in doc.styles["Title"].element.findall(".//" + qn("w:pBdr")):
    b.getparent().remove(b)
para_style("Subtitle", HEAD, EA_HEAD, 13, after=10, keep=True)
for lvl, (size, before, after) in enumerate(((15, 18, 8), (12.5, 14, 6), (11, 12, 4)), start=1):
    st = para_style(f"Heading {lvl}", HEAD, EA_HEAD, size, bold=True, before=before, after=after, keep=True, line=1.0)
    # no theme color, no italics in level 3
    st.font.italic = False
para_style("Caption", BODY, EA_BODY, 9.9, color=TEXT, before=4, after=12)
para_style("Document Kind", HEAD, EA_HEAD, 10.5, bold=True, color=PRIMARY, after=4)
para_style("Byline", BODY, EA_BODY, 11, after=2)
para_style("Summary Heading", HEAD, EA_HEAD, 11.5, bold=True, before=14, after=4, keep=True)
para_style("Bibliography", BODY, EA_BODY, 10.5, after=4)
doc.styles["Bibliography"].paragraph_format.left_indent = Cm(0.8)
doc.styles["Bibliography"].paragraph_format.first_line_indent = Cm(-0.8)
para_style("Code", CODE, EA_BODY, 9.5, after=8, line=1.0)
doc.styles["Code"].paragraph_format.left_indent = Cm(0.3)
for name in ("List Bullet", "List Number"):
    para_style(name, BODY, EA_BODY, 11, after=3)

# Placeholders: green text in brackets, a character style.
ph_style = doc.styles.add_style("Placeholder", WD_STYLE_TYPE.CHARACTER)
ph_style.font.color.rgb = PRIMARY
lab = doc.styles.add_style("Caption Label", WD_STYLE_TYPE.CHARACTER)
fonts(lab, HEAD, EA_HEAD)
lab.font.bold = True

# A three-line table style: thick rule above the header, thin below it, thick at the end.
styles_el = doc.styles.element
tbl = OxmlElement("w:style")
tbl.set(qn("w:type"), "table")
tbl.set(qn("w:styleId"), "ThreeLine")
for tag, val in (("w:name", "Three-Line Table"), ("w:basedOn", "TableNormal"), ("w:uiPriority", "40")):
    e = OxmlElement(tag)
    e.set(qn("w:val"), val)
    tbl.append(e)
tbl.append(OxmlElement("w:qFormat"))


def borders(parent, spec):
    b = OxmlElement("w:tblBorders" if parent.tag.endswith("tblPr") else "w:tcBorders")
    for side, sz in spec:
        e = OxmlElement(f"w:{side}")
        e.set(qn("w:val"), "single" if sz else "nil")
        if sz:
            e.set(qn("w:sz"), str(sz))
            e.set(qn("w:space"), "0")
            e.set(qn("w:color"), "141414")
        b.append(e)
    parent.append(b)


ppr = OxmlElement("w:pPr")
sp = OxmlElement("w:spacing"); sp.set(qn("w:before"), "40"); sp.set(qn("w:after"), "40")
ppr.append(sp)
tbl.append(ppr)
rpr = OxmlElement("w:rPr"); szel = OxmlElement("w:sz"); szel.set(qn("w:val"), "20"); rpr.append(szel)
tbl.append(rpr)
tblpr = OxmlElement("w:tblPr")
borders(tblpr, (("top", 12), ("left", 0), ("bottom", 12), ("right", 0), ("insideH", 0), ("insideV", 0)))
mar = OxmlElement("w:tblCellMar")
for side, w in (("left", 100), ("right", 100)):
    e = OxmlElement(f"w:{side}"); e.set(qn("w:w"), str(w)); e.set(qn("w:type"), "dxa"); mar.append(e)
tblpr.append(mar)
tbl.append(tblpr)
first = OxmlElement("w:tblStylePr"); first.set(qn("w:type"), "firstRow")
frpr = OxmlElement("w:rPr"); frpr.append(OxmlElement("w:b")); first.append(frpr)
ftc = OxmlElement("w:tcPr")
borders(ftc, (("top", 12), ("bottom", 4)))
first.append(ftc)
tbl.append(first)
styles_el.append(tbl)

# Footer: centered page number.
fp = sec.footer.paragraphs[0]
fp.alignment = WD_ALIGN_PARAGRAPH.CENTER
run = fp.add_run()
for kind, text in (("begin", None), (None, "PAGE"), ("end", None)):
    if kind:
        fc = OxmlElement("w:fldChar"); fc.set(qn("w:fldCharType"), kind); run._r.append(fc)
    else:
        it = OxmlElement("w:instrText"); it.set(qn("xml:space"), "preserve"); it.text = text; run._r.append(it)
run.font.size = Pt(9.5)
run.font.color.rgb = MUTED


# ------------------------------------------------------------------ the style guide
def p(text, style="Normal"):
    para = doc.add_paragraph(style=style)
    for part in re.split(r"(\[[^\]]+\])", text):
        if not part:
            continue
        r = para.add_run(part)
        if part.startswith("["):
            r.style = doc.styles["Placeholder"]
    return para


def caption(label, text):
    para = doc.add_paragraph(style="Caption")
    r = para.add_run(label); r.style = doc.styles["Caption Label"]
    para.add_run(". " + text)
    return para


p("[Laboratory report]", "Document Kind")
p("A Specific Title: Name the Field, Then What Sets the Work Apart", "Title")
p("[Author one] and [Author two]", "Byline")
p("[Course or department] · [University]", "Byline")
p("[Date]", "Byline")
p("Summary", "Summary Heading")
p("[An informative summary: what was done, how, what was found (with numbers), and what it means. "
  "It stands on its own; write it last.]")
p("1  Introduction", "Heading 1")
p("[The first sentence orients the reader and takes a step. Then the scope and limits, why the work "
  "matters, the background, the objectives, and a map of the report.]")
p("2  Procedures", "Heading 1")
p("2.1  Apparatus", "Heading 2")
p("[A first-person narrative of what was done, enough for someone to repeat it.]")
p("3  Results and Discussion", "Heading 1")
p("[Refer to every figure and table before it appears, as in Table 1.] A table's caption goes above "
  "it; a figure's caption goes below.")
caption("Table 1", "[An identifying phrase]")
t = doc.add_table(rows=3, cols=3)
t.style = "Three-Line Table"
t.alignment = WD_TABLE_ALIGNMENT.CENTER
t.autofit = True
look = OxmlElement("w:tblLook")   # apply the header-row formatting of the style
look.set(qn("w:val"), "0020"); look.set(qn("w:firstRow"), "1"); look.set(qn("w:lastRow"), "0")
look.set(qn("w:firstColumn"), "0"); look.set(qn("w:lastColumn"), "0"); look.set(qn("w:noHBand"), "1"); look.set(qn("w:noVBand"), "1")
t._tbl.tblPr.append(look)
for i, row in enumerate((("Case", "Value", "Unit"), ("A", "1.00", "–"), ("B", "0.98", "–"))):
    for j, v in enumerate(row):
        cell = t.cell(i, j)
        cell.text = v
        cell.width = Cm(3)
        cp = cell.paragraphs[0]
        cp.alignment = WD_ALIGN_PARAGRAPH.LEFT if j == 0 else WD_ALIGN_PARAGRAPH.RIGHT
        cp.paragraph_format.space_after = Pt(2)
        cp.paragraph_format.space_before = Pt(2)
        if i == 0:
            for r in cp.runs:
                r.bold = True   # the style bolds it in Word; set directly so every viewer shows it
doc.add_paragraph()
p("4  Conclusions", "Heading 1")
p("[Each objective, and whether it was met. No new evidence; next steps if any.]")
p("References", "Heading 1")
p("[Author, A. B., and C. D. Author. Year. “Title of the article.” Journal 12 (3): 45–67.]", "Bibliography")

doc.core_properties.title = "sci-propos report template"
doc.core_properties.author = ""
tmp = tempfile.mkdtemp()
raw = os.path.join(tmp, "raw.docx")
doc.save(raw)

# .dotx: change the main content type.
with zipfile.ZipFile(raw) as zin, zipfile.ZipFile(args.out, "w", zipfile.ZIP_DEFLATED) as zout:
    for it in zin.infolist():
        data = zin.read(it.filename)
        if it.filename == "[Content_Types].xml" and args.out.endswith(".dotx"):
            data = data.replace(b"wordprocessingml.document.main+xml", b"wordprocessingml.template.main+xml")
        zout.writestr(it, data)
shutil.rmtree(tmp)
print("wrote", args.out)
