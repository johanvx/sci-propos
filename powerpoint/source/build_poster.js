// Build a sci-propos poster template for PowerPoint: one slide at the
// poster's real size, laid out like the sci-propos-poster Typst package
// (sentence title, orienting picture with highlights, sections headed by
// their message over large figures, a bottom band with QR code, contact,
// references, acknowledgments and logos).
// Usage: SP_STYLE=sans|serif node build_poster.js <a0|48x36|16:9> <assets-dir> <out.pptx>
// Sizes are real points: the slide is the poster, so 30 pt on screen is 30 pt
// on paper.
const path = require("path");
const pptxgen = require("pptxgenjs");
const S = require("./style.js");
const { FONT, COLOR } = S;

const SIZES = {
  "a0": { w: 841 / 25.4, h: 1189 / 25.4, cols: 2, orient: "band", name: "A0 portrait (841 × 1189 mm)" },
  "48x36": { w: 48, h: 36, cols: 3, orient: "column", name: "48 × 36 in landscape" },
  "16:9": { w: 48, h: 27, cols: 4, orient: "column", name: "16:9 e-poster (48 × 27 in)" },
};
const key = process.argv[2];
const assets = process.argv[3];
const out = process.argv[4];
const P = SIZES[key];
if (!P) throw new Error("size must be a0, 48x36 or 16:9");

// The Typst package's ladder (A0), scaled by the square root of the area.
const s = Math.sqrt((P.w * 25.4 * P.h * 25.4) / (841 * 1189));
const Z = { title: 84, authors: 38, affiliation: 30, highlight: 40, heading: 44, body: 30, caption: 24, small: 21 };
for (const k in Z) Z[k] = Math.round(Z[k] * s);
const mm = (v) => v / 25.4;
const M = mm(40 * s), G = mm(30 * s);       // margin and column gutter, in inches
const ptIn = (pt) => pt / 72;
const lineH = (pt, n, lead = 1.2) => ptIn(pt) * lead * n;

const pres = new pptxgen();
pres.defineLayout({ name: "POSTER", width: P.w, height: P.h });
pres.layout = "POSTER";
pres.title = "sci-propos poster template";
pres.theme = { headFontFace: FONT.head, bodyFontFace: FONT.body };

const W = P.w - 2 * M;
const txt = (o) => ({ fontFace: FONT.body, color: COLOR.text, margin: 0, valign: "top", ...o });

// The master: title, authors and affiliation as placeholders, at the top.
const titleH = lineH(Z.title, 2, 1.1);
const yAuthors = M + titleH + ptIn(Z.title) * 0.3;
const yAff = yAuthors + lineH(Z.authors, 1);
const headerBottom = yAff + lineH(Z.affiliation, 1);
pres.defineSlideMaster({
  title: "Poster",
  background: { color: "FFFFFF" },
  objects: [
    { placeholder: { options: txt({ name: "title", type: "title", x: M, y: M, w: W, h: titleH, fontSize: Z.title, bold: true, valign: "bottom", align: "left", fit: "none" }),
      text: "[A sentence that states the main finding, in plain words]" } },
    { placeholder: { options: txt({ name: "authors", type: "body", x: M, y: yAuthors, w: W, h: lineH(Z.authors, 1), fontSize: Z.authors, bold: true, align: "left" }),
      text: "[First Author]¹, [Second Author]²" } },
    { placeholder: { options: txt({ name: "affiliation", type: "body", x: M, y: yAff, w: W, h: lineH(Z.affiliation, 1), fontSize: Z.affiliation, color: "3C3C3C", align: "left" }),
      text: "¹[Department, University, City] · ²[Organization, City]" } },
  ],
});

const slide = pres.addSlide({ masterName: "Poster" });
slide.addText("[A sentence that states the main finding, in plain words]", { placeholder: "title", align: "left" });
slide.addText([
  { text: "[First Author]" }, { text: "1", options: { superscript: true } },
  { text: ", [Second Author]" }, { text: "2", options: { superscript: true } },
], { placeholder: "authors" });
slide.addText([
  { text: "1", options: { superscript: true } }, { text: "[Department, University, City] · " },
  { text: "2", options: { superscript: true } }, { text: "[Organization, City]" },
], { placeholder: "affiliation" });

// Bottom band.
const qr = mm(70 * s);
const bandH = qr;
const bandTop = P.h - M - bandH;
slide.addShape("line", { x: M, y: bandTop - G * 0.8, w: W, h: 0, line: { color: "BEBEBE", width: 1.2 * s }, objectName: "Band rule" });
slide.addImage({ path: path.join(assets, "qr-example-org.png"), x: M, y: bandTop, w: qr, h: qr, altText: "QR code (replace with your own)" });
const small = txt({ fontSize: Z.small, color: "282828" });
slide.addText([
  { text: "[Paper, data and code]", options: { bold: true, color: COLOR.primary, fontSize: Z.caption, breakLine: true } },
  { text: "Contact", options: { bold: true, breakLine: true } },
  { text: "[Name] · [email@example.org]" },
], { ...small, x: M + qr + G * 0.7, y: bandTop, w: mm(150 * s), h: bandH, valign: "middle", objectName: "Contact" });
const refX = M + qr + G * 0.7 + mm(150 * s) + G;
const logoW = mm(150 * s), logoH = mm(40 * s);
slide.addText([
  { text: "References", options: { bold: true, breakLine: true } },
  { text: "[1] [Author, title, journal volume, pages (year).]", options: { breakLine: true } },
  { text: " ", options: { breakLine: true, fontSize: Z.small * 0.5 } },
  { text: "Acknowledgments", options: { bold: true, breakLine: true } },
  { text: "[Funding agency, grant number.]" },
], { ...small, x: refX, y: bandTop, w: P.w - M - logoW - G - refX, h: bandH, valign: "middle", objectName: "References and acknowledgments" });
slide.addShape("rect", { x: P.w - M - logoW, y: bandTop + (bandH - logoH) / 2, w: logoW, h: logoH, fill: { color: "FFFFFF" }, line: { color: "969696", width: 1 }, objectName: "Logos (replace)" });
slide.addText("[Logos]", { ...txt({ fontSize: Z.small, color: COLOR.primary }), x: P.w - M - logoW, y: bandTop + (bandH - logoH) / 2, w: logoW, h: logoH, align: "center", valign: "middle" });

// The orienting block: a picture and two or three highlights.
const tint = "EDF3EF";   // primary at 93 % lightness
const pointsRuns = (n) => ["[First key result, with its number]", "[Second key result]", "[What it means, or what comes next]"].slice(0, n).map((t, i, a) => ({
  text: t, options: { bullet: { characterCode: "2192", indent: Z.highlight * 1.1 }, color: COLOR.text, breakLine: i < a.length - 1, paraSpaceAfter: Z.highlight * 0.35 },
}));
function picture(x, y, w, h, label) {
  slide.addShape("rect", { x, y, w, h, fill: { color: "E1E1E1" }, line: { type: "none" }, objectName: "Picture placeholder" });
  slide.addText(label, { ...txt({ fontSize: Z.caption, color: "464646" }), x, y, w, h, align: "center", valign: "middle" });
}
let top = headerBottom + G * 1.1;
const pad = M * 0.6;
if (P.orient === "band") {
  const h = mm(140 * s) + 2 * M * 0.5;
  slide.addShape("rect", { x: M, y: top, w: W, h, fill: { color: tint }, line: { type: "none" }, objectName: "Orienting band" });
  const gw = (W - 2 * pad - G * 1.5) * 1.1 / 2.1;
  picture(M + pad, top + M * 0.5, gw, mm(140 * s), "[Orienting picture]");
  slide.addText(pointsRuns(3), { ...txt({ fontSize: Z.highlight }), x: M + pad + gw + G * 1.5, y: top + M * 0.5, w: W - 2 * pad - gw - G * 1.5, h: mm(140 * s), valign: "middle" });
  top += h + G * 1.1;
}

// Columns of sections.
const colW = (W - (P.cols - 1) * G) / P.cols;
const colH = bandTop - G * 1.6 - top;
const charsPerLine = (pt) => (colW * 72) / (pt * 0.5);
const linesOf = (t, pt) => Math.max(1, Math.ceil(t.length / charsPerLine(pt)));
const SECTIONS = [
  { head: "[The question, and why it matters, in one sentence]", body: "[Two or three sentences a non-specialist can follow: the problem, the gap, and what this work tried.]", fig: "[Figure that shows the problem]", cap: "[What to notice in this figure.]", weight: 1 },
  { head: "[What was done, stated as a result where possible]", body: "[The method in a few sentences; the details go behind the QR code.]", fig: "[Set-up or method diagram]", cap: "[Call out the parts that matter.]", weight: 0.9 },
  { head: "[The main result, as a sentence with its number]", body: null, fig: "[The largest figure: the evidence]", cap: "[Axes, units, and what the reader should see.]", weight: 1.6 },
  { head: "[What the result means, or what comes next]", body: "[One short paragraph. End with the next step or an invitation to talk.]", fig: null, weight: 0 },
];
// Which sections go in which column (the orienting block takes the top of
// the first column on landscape posters).
const PLAN = { "a0": [[0, 1], [2, 3]], "48x36": [["orient", 0], [1], [2, 3]], "16:9": [["orient"], [0], [1], [2, 3]] }[key];
const gap = ptIn(Z.heading) * 1.1;
PLAN.forEach((items, c) => {
  const x = M + c * (colW + G);
  // Heights: text first, then the figures share what is left, by weight.
  const textH = (it) => {
    if (it === "orient") return 0;
    const sct = SECTIONS[it];
    return lineH(Z.heading, linesOf(sct.head, Z.heading), 1.15) + ptIn(Z.heading) * 0.6
      + (sct.body ? lineH(Z.body, linesOf(sct.body, Z.body), 1.25) + ptIn(Z.body) * 0.5 : 0)
      + (sct.fig ? ptIn(Z.caption) * 2.2 : 0);
  };
  const fixed = items.reduce((a, it) => a + textH(it), 0) + gap * (items.length - 1)
    + (items.includes("orient") ? lineH(Z.highlight, 6, 1.3) + 2 * pad + G * 0.8 : 0);
  const weights = items.map((it) => (it === "orient" ? 0.8 : SECTIONS[it].weight));
  const free = Math.max(0, colH - fixed);
  const wsum = weights.reduce((a, b) => a + b, 0) || 1;
  let y = top;
  items.forEach((it, k) => {
    const figH = (free * weights[k]) / wsum;
    if (it === "orient") {
      const h = figH + lineH(Z.highlight, 6, 1.3) + 2 * pad + G * 0.8;
      slide.addShape("rect", { x, y, w: colW, h, fill: { color: tint }, line: { type: "none" }, objectName: "Orienting block" });
      picture(x + pad, y + pad, colW - 2 * pad, figH, "[Orienting picture]");
      slide.addText(pointsRuns(3), { ...txt({ fontSize: Z.highlight }), x: x + pad, y: y + pad + figH + G * 0.8, w: colW - 2 * pad, h: lineH(Z.highlight, 6, 1.3) });
      y += h + gap;
      return;
    }
    const sct = SECTIONS[it];
    const hh = lineH(Z.heading, linesOf(sct.head, Z.heading), 1.15);
    slide.addText(sct.head, { ...txt({ fontSize: Z.heading, bold: true, color: COLOR.primary }), x, y, w: colW, h: hh, objectName: "Section message" });
    y += hh + ptIn(Z.heading) * 0.6;
    if (sct.body) {
      const bh = lineH(Z.body, linesOf(sct.body, Z.body), 1.25);
      slide.addText(sct.body, { ...txt({ fontSize: Z.body }), x, y, w: colW, h: bh, objectName: "Section text" });
      y += bh + ptIn(Z.body) * 0.5;
    }
    if (sct.fig) {
      picture(x, y, colW, figH, sct.fig);
      y += figH + ptIn(Z.caption) * 0.4;
      slide.addText(sct.cap, { ...txt({ fontSize: Z.caption, color: "3C3C3C" }), x, y, w: colW, h: ptIn(Z.caption) * 1.4, align: "center", objectName: "Caption" });
      y += ptIn(Z.caption) * 1.8;
    }
    y += gap;
  });
});

slide.addNotes([
  `sci-propos poster, ${P.name}. The slide is the poster at full size: print it at 100 %.`,
  "Before filling it in: write the main finding as one sentence (the title) and each section's message as a sentence (the headings). Sketch two or three layouts on paper and keep the one where the evidence is largest.",
  "Replace each gray box with a picture (Insert › Pictures) and each [placeholder]. Paragraphs: four sentences at most. Figure labels: at least the caption size, " + Z.caption + " pt.",
  "Type sizes: title " + Z.title + " pt, section messages " + Z.heading + " pt, body " + Z.body + " pt, captions " + Z.caption + " pt, bottom band " + Z.small + " pt.",
  "Check: print the poster on A4 or Letter; if the body text reads at arm's length, it reads at 1.5 m on the poster.",
].join("\n\n"));

pres.writeFile({ fileName: out }).then((f) => console.log("wrote", f));
