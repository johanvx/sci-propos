// sci-propos presentation templates for PowerPoint: theme, slide layouts and
// drawing helpers. Geometry is measured on the Typst theme
// (sci-propos-presentation, 16:9 page, 841.89 x 473.56 pt) and scaled to
// PowerPoint's widescreen page (960 x 540 pt) by F.
// Style: SP_STYLE=sans (default) or serif.
// Fonts: SP_FONTS=office (default: fonts that come with Office on Windows
// and Mac) or noto (the Typst theme's fonts; install them where you present).
// Chinese: SP_CJK=Hans (default, Simplified) or Hant (Traditional).

const F = 960 / 841.89;
const IN = (v) => (v * F) / 72;               // Typst pt -> inches
const PT = (v) => Math.round(v * F * 10) / 10; // Typst pt -> PowerPoint pt

const STYLE = process.env.SP_STYLE === "serif" ? "serif" : "sans";
const FONTS = process.env.SP_FONTS === "noto" ? "noto" : "office";
const CJK = process.env.SP_CJK === "Hant" ? "Hant" : "Hans";
const FONT_SETS = {
  office: {
    sans:  { body: "Calibri", code: "Consolas", ea: { Hans: "DengXian", Hant: "Microsoft JhengHei" }, em: 0.53 },
    serif: { body: "Cambria", code: "Consolas", ea: { Hans: "SimSun", Hant: "PMingLiU" }, em: 0.56 },
  },
  noto: {
    sans:  { body: "Noto Sans", code: "Noto Sans Mono", ea: { Hans: "Noto Sans SC", Hant: "Noto Sans TC" }, em: 0.6 },
    serif: { body: "Noto Serif", code: "Noto Sans Mono", ea: { Hans: "Noto Serif SC", Hant: "Noto Serif TC" }, em: 0.6 },
  },
};
const fs_ = FONT_SETS[FONTS][STYLE];
const FONT = {
  set: FONTS,
  body: fs_.body,
  head: fs_.body,
  code: fs_.code,
  ea: fs_.ea[CJK],
  em: fs_.em,   // average bold character width, in em, for fitting titles
};
const COLOR = {
  primary: "00561F",
  text: "141414",     // luma(20)
  muted: "6E6E6E",    // luma(110), 5:1 on white: labels, descriptions, inactive sections
  credit: "505050",   // luma(80), 8:1: credit lines
  number: "3C3C3C",   // luma(60), 11:1: slide numbers
  faint: "CDCDCD",    // luma(205): title rule
  label: "707070",    // labels above code panels
  codeBg: "F6F6F6",
  pkgBg: "E0EBE4",    // primary lightened 88 %
  cardBg: "F2F7F4",   // primary lightened 95 %
};

const THEME = {
  name: `sci-propos ${STYLE === "serif" ? "Serif" : "Sans"}`,
  headFontFace: FONT.head,
  bodyFontFace: FONT.body,
  eaFontFace: FONT.ea,
  colors: {
    dk1: COLOR.text, lt1: "FFFFFF", dk2: COLOR.primary, lt2: COLOR.codeBg,
    accent1: COLOR.primary, accent2: COLOR.muted, accent3: COLOR.faint,
    accent4: COLOR.pkgBg, accent5: COLOR.cardBg, accent6: "8A4B08",
    hlink: COLOR.primary, folHlink: COLOR.primary,
  },
};

// Typst geometry (pt): margins 40 left/right, title rule at y = 58, body from 72 to 439.56 (the Typst package's band without a top section label).
const X0 = 40, RIGHT = 801.89, W = RIGHT - X0;
const BODY_TOP = 72, BODY_BOTTOM = 439.56;
const QR = 136, QR_X = RIGHT - QR;   // QR codes on the closing slides, as in Typst (about 4.8 cm)

// ------------------------------------------------------------------ placeholders
const ph = (name, type, b, opts, prompt) => ({ placeholder: { options: {
  name, type, x: IN(b[0]), y: IN(b[1]), w: IN(b[2]), h: IN(b[3]), margin: 0,
  fontFace: FONT.body, fontSize: PT(20), color: COLOR.text, valign: "top", align: "left",
  lineSpacingMultiple: 1.0, ...opts,
}, text: prompt } });

const P = {
  // Full width: the logo sits above the title band. "Shrink on overflow" is set
  // for titles typed in PowerPoint; built decks size titles with addTitle().
  title: ph("title", "title", [X0, 24, W, 34], { fontFace: FONT.head, fontSize: PT(28), bold: true, color: COLOR.primary, valign: "bottom", fit: "shrink" }, "Short title"),
  // The lead line: the slide's point as one full sentence, at most two lines,
  // never shrunk (assertion-evidence). 22 pt in Typst.
  lead: ph("lead", "body", [X0, 68, W, 58], { fontSize: PT(22) }, "The point of this slide as one full sentence, at most two lines"),
  body: ph("body", "body", [X0, 136, W, 282], { valign: "middle" }, "Evidence: a figure, a table, an equation, a picture with call-outs"),
  credit: ph("credit", "body", [X0, 420, W, 18], { fontSize: PT(13), color: COLOR.credit, valign: "bottom" }, "Source / credit line"),
  // The footer locator "2 Results · 5 / 7": finish.py turns this placeholder
  // into a footer, filled with Insert › Header & Footer › Footer.
  locator: ph("locator", "body", [360, 446, 373, 18], { fontSize: PT(14), color: COLOR.primary, align: "right", valign: "middle" }, "2 Section ·"),
};
const RULE = { line: { x: IN(X0), y: IN(58), w: IN(W), h: 0, line: { color: COLOR.faint, width: PT(0.6) } } };
// Left-aligned, so the number follows the locator at a constant gap ("2 Results · 5 / 7").
const SLIDE_NUMBER = { x: IN(736), y: IN(446), w: IN(65.89), h: IN(18), fontFace: FONT.body, fontSize: PT(14), color: COLOR.number, align: "left" };

function defineLayouts(pres) {
  const L = (title, objects, extra = {}) => pres.defineSlideMaster({
    title, background: { color: "FFFFFF" }, margin: 0, objects,
    slideNumber: SLIDE_NUMBER, ...extra,
  });
  const content = (more) => [P.title, RULE, ...more, P.locator];
  const pic = (name, b, prompt) => ph(name, "pic", b, {}, prompt);

  L("Title", [
    ph("title", "title", [X0, 140, W, 60], { fontFace: FONT.head, fontSize: PT(34), bold: true, color: COLOR.primary, align: "center", valign: "bottom" }, "A specific title: field, then what sets the work apart"),
    ph("subtitle", "body", [X0, 220, W, 50], { fontSize: PT(22), align: "center" }, "One line that says what the talk shows"),
    ph("author", "body", [X0, 340, W, 24], { align: "center", color: COLOR.primary }, "[Presenter name]"),
    ph("institution", "body", [X0, 384, W, 22], { fontSize: PT(18), align: "center" }, "[Department] · [University]"),
    ph("date", "body", [X0, 425, W, 22], { fontSize: PT(17), align: "center", color: "696969" }, "Date"),
  ], { slideNumber: undefined });
  // Text on the left, an orienting picture on the right: scope, setting, why it matters.
  L("Title with Image", [
    ph("title", "title", [X0, 90, 360, 110], { fontFace: FONT.head, fontSize: PT(34), bold: true, color: COLOR.primary, valign: "bottom" }, "A specific title"),
    ph("subtitle", "body", [X0, 210, 360, 50], { fontSize: PT(22) }, "One line that says what the talk shows"),
    ph("author", "body", [X0, 340, 360, 24], { color: COLOR.primary }, "[Presenter name]"),
    ph("institution", "body", [X0, 384, 360, 22], { fontSize: PT(18) }, "[Department] · [University]"),
    ph("date", "body", [X0, 425, 360, 22], { fontSize: PT(17), color: "696969" }, "Date"),
    pic("image", [432, 60, 369.89, 360], "Orienting picture: the scope, the setting, or why the work matters"),
  ], { slideNumber: undefined });
  L("Outline", [P.title, RULE,
    ph("body", "body", [X0, BODY_TOP, W, BODY_BOTTOM - BODY_TOP], { valign: "middle" }, "Sections with their descriptions (see the style guide)")]);
  // The mapping slide of the assertion-evidence approach: one picture per part.
  L("Outline Map", [P.title, RULE,
    pic("part 1 picture", [X0, 108, 237.96, 147], "Picture for part 1"),
    pic("part 2 picture", [X0 + 261.96, 108, 237.96, 147], "Picture for part 2"),
    pic("part 3 picture", [X0 + 523.93, 108, 237.96, 147], "Picture for part 3"),
    ph("part 1", "body", [X0, 265, 237.96, 60], { fontSize: PT(21), bold: true, color: COLOR.primary }, "1. Part"),
    ph("part 2", "body", [X0 + 261.96, 265, 237.96, 60], { fontSize: PT(21), bold: true, color: COLOR.primary }, "2. Part"),
    ph("part 3", "body", [X0 + 523.93, 265, 237.96, 60], { fontSize: PT(21), bold: true, color: COLOR.primary }, "3. Part")]);
  L("Section", [
    ph("body", "body", [X0, 48, W, 377], { valign: "middle" }, "The outline, current section highlighted (see the style guide)")]);
  L("Section with Image", [
    ph("body", "body", [X0, 48, 420, 377], { valign: "middle" }, "The outline, current section highlighted"),
    pic("image", [496, 88, 305.89, 297], "The section's picture")]);
  L("Title and Content", content([P.lead, P.body, P.credit]));
  L("Two Content", content([P.lead,
    ph("left", "body", [X0, 136, 368.9, 282], { valign: "middle" }, "Left column"),
    ph("right", "body", [432.99, 136, 368.9, 282], { valign: "middle" }, "Right column"),
    P.credit]));
  L("Picture with Call-outs", content([P.lead,
    pic("picture", [140, 143, 561.89, 272], "Picture: add call-outs as short text boxes joined by lines (see the style guide)"),
    P.credit]));
  L("Code and Output", content([P.lead,
    ph("code", "body", [X0, 148, 420, 252], { fontFace: FONT.code, fontSize: PT(15), fill: { color: COLOR.codeBg }, margin: [PT(10), PT(10), PT(8), PT(8)], valign: "middle" }, "code, one line per paragraph"),
    ph("output", "pic", [478, 148, 323.89, 252], {}, "Output: insert the picture rendered from the code"),
    P.credit]));
  L("Content with Aside", content([P.lead,
    ph("body", "body", [X0, 136, 506, 282], { valign: "middle" }, "Main content"),
    ph("aside", "body", [566, 136, 235.89, 282], { fontSize: PT(17), valign: "middle" }, "Side cards: copy them from the style guide")]));
  L("Step", content([
    ph("instruction", "body", [X0, 70, W, 26], {}, "One instruction: Menu → Item → Button"),
    pic("screenshot", [X0, 106, W, 333], "Screenshot: click the icon to insert the full-window screenshot")]));
  L("Title Only", content([P.lead, P.credit]));
  // The last slide of a research talk: it stays up while people ask questions.
  // No section in the footer, and the logo stays.
  L("Conclusion", [P.title, RULE,
    ph("lead", "body", [X0, 68, W, 58], { fontSize: PT(22) }, "In summary, the talk's main takeaway in one sentence"),
    pic("figure 1", [X0, 144, 96, 56], "Mini"),
    pic("figure 2", [X0, 212, 96, 56], "Mini"),
    pic("figure 3", [X0, 280, 96, 56], "Mini"),
    ph("points", "body", [X0 + 116, 144, W - 116, 214], { valign: "top", lineSpacingMultiple: 1.0 }, "Up to three supporting assertions, one per line, parallel in form"),
    pic("photo", [X0, 388, 48, 48], "Photo"),
    ph("contact", "body", [X0 + 60, 396, 420, 32], { fontSize: PT(15), color: "616161", valign: "middle" }, "[Group name] · [email@example.org]"),
    pic("qr", [620, 388, 48, 48], "QR"),
    ph("questions", "body", [680, 396, 121.89, 32], { fontSize: PT(24), color: COLOR.muted, align: "right", valign: "middle" }, "Questions?"),
    { line: { x: IN(X0), y: IN(378), w: IN(W), h: 0, line: { color: COLOR.faint, width: PT(0.6) } } }]);
  // For promotional talks: an affiliation page whose lead repeats the takeaway.
  L("Contact", [P.title, RULE,
    ph("lead", "body", [X0, 68, W, 58], { fontSize: PT(22) }, "The talk's takeaway, repeated in one sentence"),
    pic("photo", [X0, 136, 440, 282], "Photo of the group, the lab or the building"),
    ph("lines", "body", [508, 146, 293.89, 110], { fontSize: PT(19), color: COLOR.primary }, "[Group name]\n[Department] · [University]\n[email@example.org]"),
    pic("qr", [508, 268, 120, 120], "QR code to the website")]);
  // For courses and seminars: links and a thank-you line (after the summary).
  L("Closing", [P.title, RULE,
    ph("body", "body", [X0, 88, QR_X - 32 - X0, 282], { valign: "middle" }, "Resources: title — link"),
    pic("qr", [QR_X, 150, QR, QR], "QR code (optional): insert a picture"),
    ph("qr caption", "body", [QR_X - 30, 292, QR + 60, 16], { fontFace: FONT.code, fontSize: PT(12), color: COLOR.muted, align: "center" }, "link"),
    ph("closing", "body", [X0, 392, W, 40], { fontSize: PT(30), bold: true, color: COLOR.primary, valign: "bottom" }, "Thank you")]);
  L("Thank You", [
    ph("closing", "body", [X0, 210, W, 44], { fontSize: PT(30), bold: true, color: COLOR.primary, align: "center", valign: "middle" }, "Thank you"),
    pic("qr", [(841.89 - QR) / 2, 268, QR, QR], "QR code (optional)"),
    ph("qr caption", "body", [(841.89 - QR - 60) / 2, 410, QR + 60, 16], { fontFace: FONT.code, fontSize: PT(12), color: COLOR.muted, align: "center" }, "link")]);
  L("Focus", [
    ph("body", "body", [48, 48, 745.89, 377.56], { fontSize: PT(32), bold: true, color: "FFFFFF", align: "center", valign: "middle" }, "One sentence on the primary color")],
    { background: { color: COLOR.primary }, slideNumber: undefined });
  // A black page for stretches of the talk where no visual helps.
  L("Black", [], { background: { color: "000000" }, slideNumber: undefined });
  // "Blank" is pptxgenjs' own empty layout, renamed by finish.py.
}

// ------------------------------------------------------------------ helpers (positions in Typst pt)
const at = (b) => ({ x: IN(b[0]), y: IN(b[1]), w: IN(b[2]), h: IN(b[3]) });

/** Font size (PowerPoint pt) that keeps a slide title on one line, as the
 *  Typst theme does: shrink down to 72 % of `base`, then let it wrap.
 *  An estimate from the character count (FONT.em per char; a CJK char is 1 em). */
function titleSize(text, base = 28, width = W) {
  const est = [...String(text)].reduce((s, ch) => s + (ch.codePointAt(0) > 0x2e80 ? 1 : FONT.em), 0) * base;
  return PT(est > width ? Math.max(base * width / est, base * 0.72) : base);
}

/** Put a title into the slide's title placeholder at a size that fits.
 *  (pptxgenjs ignores `fontSize` in placeholder options: it must sit on the run.) */
function addTitle(slide, text, base = 28) {
  slide.addText([{ text, options: { fontSize: titleSize(text, base) } }], { placeholder: "title" });
}

/** Code panel with highlighted runs: { lines: [[{text, color}]] }; never wraps. */
function addCode(slide, code, b, size = 15, leading = 0.5) {
  const runs = [];
  code.lines.forEach((line, i) => {
    const last = i === code.lines.length - 1;
    if (line.length === 0) runs.push({ text: " ", options: { breakLine: !last } });
    line.forEach((r, j) => runs.push({ text: r.text, options: { color: r.color, ...(j === line.length - 1 && !last ? { breakLine: true } : {}) } }));
  });
  slide.addText(runs, {
    ...at(b), shape: "roundRect", rectRadius: IN(4), fill: { color: COLOR.codeBg }, line: { type: "none" },
    fontFace: FONT.code, fontSize: PT(size), lineSpacing: PT((1.0 + leading) * size),
    margin: [PT(10), PT(10), PT(8), PT(8)], valign: "middle", wrap: false, fit: "none", objectName: "Code panel",
  });
}

/** Paragraphs from arrays of runs; paragraph options go on every run. */
function paras(list, popts = () => ({})) {
  const out = [];
  list.forEach((runs, i) => {
    const p = popts(i);
    runs.forEach((r, j) => out.push({ text: r.text, options: { align: "left", ...(r.options || {}), ...p, ...(j === runs.length - 1 && i < list.length - 1 ? { breakLine: true } : {}) } }));
  });
  return out;
}

/** Package name in running text. */
const pkgRun = (name) => ({ text: name, options: { fontFace: FONT.code, color: COLOR.primary, highlight: COLOR.pkgBg } });

/** Rich text: *strong* (bold, primary), _emphasis_ (italic, primary), `code`. */
function rich(s, base = {}) {
  const out = [];
  const re = /(\*[^*]+\*|_[^_]+_|`[^`]+`)/g;
  let i = 0, m;
  while ((m = re.exec(s))) {
    if (m.index > i) out.push({ text: s.slice(i, m.index), options: { ...base } });
    const t = m[0];
    if (t[0] === "*") out.push({ text: t.slice(1, -1), options: { ...base, bold: true, color: COLOR.primary } });
    else if (t[0] === "_") out.push({ text: t.slice(1, -1), options: { ...base, italic: true, color: COLOR.primary } });
    else out.push({ text: t.slice(1, -1), options: { ...base, fontFace: FONT.code } });
    i = m.index + t.length;
  }
  if (i < s.length) out.push({ text: s.slice(i), options: { ...base } });
  return out;
}

/** The "parts" outline: [(name, description)], `current` highlighted (0 = outline
 *  page). The number hangs in its own column, so names and descriptions line up.
 *  A description of null leaves it out. */
function outlineRuns(items, current = 0) {
  const indent = PT(32.18);
  const runs = [];
  items.forEach(([name, note], i) => {
    const active = current === 0 || current === i + 1;
    const accent = active ? COLOR.primary : COLOR.muted;
    const noteColor = current === 0 ? COLOR.muted : active ? COLOR.text : COLOR.muted;
    const last = i === items.length - 1;
    runs.push({ text: name, options: {
      bold: true, fontSize: PT(26), color: accent, align: "left",
      bullet: { type: "number", numberStartAt: i + 1, indent }, paraSpaceBefore: i ? PT(16) : 0,
      ...(last && note == null ? {} : { breakLine: true }),
    } });
    if (note == null) return;
    runs.push({ text: note, options: {
      fontSize: PT(18), color: noteColor, align: "left", indentLevel: 0,
      bullet: { code: "200B", indent }, paraSpaceBefore: PT(2),
      ...(last ? {} : { breakLine: true }),
    } });
  });
  return runs;
}

/** Side card: tinted box with a frame on one side (solid, dashed or dotted). */
const CARD_KINDS = {
  note: { label: "Note", frame: "solid" },
  definition: { label: "Definition", frame: "solid" },
  intro: { label: "In short", frame: "solid" },
  recap: { label: "Recap", frame: "dashed" },
  reminder: { label: "Reminder", frame: "dotted" },
};
function addCard(slide, b, { kind = "note", title = null, body = "", label = undefined, side = "left", frame = undefined, accent = COLOR.primary, fill = COLOR.cardBg, size = 17 } = {}) {
  const k = CARD_KINDS[kind] || kind;
  const dash = { solid: "solid", dashed: "dash", dotted: "sysDot" }[frame || k.frame];
  const lab = label === undefined ? k.label : label;
  const box = at(b);
  if (fill) slide.addShape("rect", { ...box, fill: { color: fill }, line: { type: "none" }, objectName: `Card (${typeof kind === "string" ? kind : "custom"})` });
  const L = {
    left: { x: box.x, y: box.y, w: 0, h: box.h },
    right: { x: box.x + box.w, y: box.y, w: 0, h: box.h },
    top: { x: box.x, y: box.y, w: box.w, h: 0 },
    bottom: { x: box.x, y: box.y + box.h, w: box.w, h: 0 },
  }[side];
  slide.addShape("line", { ...L, line: { color: accent, width: PT(2.5), dashType: dash }, objectName: "Card frame" });
  const runs = [];
  if (lab) runs.push({ text: lab.toUpperCase(), options: { bold: true, fontSize: PT(size * 0.72), color: accent, charSpacing: 1, breakLine: true } });
  if (title) runs.push({ text: title, options: { bold: true, fontSize: PT(size), breakLine: true, paraSpaceBefore: PT(4) } });
  rich(body, { fontSize: PT(size) }).forEach((r, i) => { if (i === 0) r.options.paraSpaceBefore = PT(title ? 0 : 4); runs.push(r); });
  const pad = { left: [16, 12, 10, 10], right: [12, 16, 10, 10], top: [12, 12, 10, 16], bottom: [12, 12, 16, 10] }[side];
  slide.addText(runs, { ...box, fontFace: FONT.body, color: COLOR.text, margin: pad.map(PT), valign: "top", objectName: "Card text" });
}

/** A call-out on a picture: a dot at the point, a thin line, a short label
 *  (positions in Typst pt; label box at (lx, ly), anchored on the line's end). */
function addCallout(slide, [px, py], [lx, ly], text, { size = 17, align = "left" } = {}) {
  slide.addShape("line", { x: IN(Math.min(px, lx)), y: IN(Math.min(py, ly)), w: IN(Math.abs(lx - px)), h: IN(Math.abs(ly - py)),
    flipH: (lx < px) !== (ly < py) ? true : false, line: { color: COLOR.primary, width: PT(1) }, objectName: "Call-out line" });
  slide.addShape("ellipse", { x: IN(px - 3), y: IN(py - 3), w: IN(6), h: IN(6), fill: { color: COLOR.primary }, line: { type: "none" }, objectName: "Call-out point" });
  const w = 170, h = 22;
  const x = align === "right" ? lx - w : lx;
  slide.addText(text, { ...at([x, ly - h / 2, w, h]), fontFace: FONT.body, fontSize: PT(size), color: COLOR.text, align, valign: "middle", margin: PT(2), objectName: "Call-out label" });
}

module.exports = { F, IN, PT, STYLE, FONT, COLOR, THEME, X0, W, RIGHT, BODY_TOP, BODY_BOTTOM, QR, QR_X, defineLayouts, addCallout, at, titleSize, addTitle, addCode, paras, pkgRun, rich, outlineRuns, addCard, CARD_KINDS };
