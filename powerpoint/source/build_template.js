// Build the sci-propos PowerPoint template: one master, the layouts of
// style.js, and a style guide written as a short assertion-evidence talk
// (illustrative data), with speaker notes that show the handout format.
// Usage: SP_STYLE=sans|serif node build_template.js <assets-dir> <out.pptx>
const fs = require("fs");
const path = require("path");
const pptxgen = require("pptxgenjs");
const S = require("./style.js");
const { PT, FONT, COLOR, at, addCode, paras, pkgRun, outlineRuns, addCard, addCallout, IN, X0, W } = S;

const assets = process.argv[2];
const out = process.argv[3];
const code = JSON.parse(fs.readFileSync(path.join(assets, "code-demo.json"), "utf8"));

const pres = new pptxgen();
pres.layout = "LAYOUT_WIDE";
pres.title = "sci-propos presentation template";
pres.theme = { headFontFace: FONT.head, bodyFontFace: FONT.body };
S.defineLayouts(pres);

const parts = [["Question", "what the correlations assume"], ["Method", "a grid upstream of a large leading edge"], ["Results", "what the measurements show"]];
let section = "Opening";
let partNo = 0;
const add = (layout, fill = {}, note = "") => {
  const s = pres.addSlide({ masterName: layout, sectionTitle: section });
  const f = { ...fill };
  // The footer locator "2 Results ·" on content slides of a part.
  if (partNo > 0 && !("locator" in f) && ["Title and Content", "Two Content", "Picture with Call-outs", "Code and Output", "Content with Aside", "Step", "Title Only"].includes(layout)) {
    f.locator = `${partNo} ${parts[partNo - 1][0]} ·`;
  }
  for (const [k, v] of Object.entries(f)) s.addText(v, { placeholder: k });
  if (note) s.addNotes(note);
  return s;
};
const bullets = (items) => paras(items.map((t) => S.rich(t)), (i) => ({ bullet: true, paraSpaceBefore: i ? PT(10) : 0 }));
const startPart = (n) => { partNo = n; section = parts[n - 1][0]; pres.addSection({ title: section }); };

// A native (editable) bar chart in the house colors: gray bars, the last one green.
function barChart(slide, b, labels, values, { last = true, axis = true, ref = null, size = 15, min = 0.9, format = "0.00" } = {}) {
  const colors = values.map((_, i) => (last && i === values.length - 1 ? COLOR.primary : "C3C3C3"));
  slide.addChart(pres.charts.BAR, [{ name: "Value", labels, values }], {
    ...at(b), barDir: "col", chartColors: colors, varyColors: true, barGapWidthPct: 60,
    catAxisLabelFontFace: FONT.body, catAxisLabelFontSize: PT(size), catAxisLabelColor: COLOR.text, catAxisLineShow: true, catAxisLineColor: "969696",
    valAxisHidden: true, valGridLine: { style: "none" }, catAxisHidden: !axis,
    valAxisMinVal: min, valAxisMaxVal: Math.max(...values) * 1.08,
    showValue: axis, dataLabelFontFace: FONT.body, dataLabelFontSize: PT(size + 1), dataLabelColor: COLOR.text, dataLabelPosition: "outEnd", dataLabelFormatCode: format,
    showLegend: false, plotArea: { fill: { color: "FFFFFF" } },
  });
  if (ref != null) {
    // A dashed reference line, drawn over the plot area at the reference value.
    const [x, y, w, h] = b;
    const top = y + 0.08 * h, bottom = y + h - (axis ? 26 : 2);
    const yy = bottom - ((ref - min) / (Math.max(...values) * 1.08 - 0.9)) * (bottom - top);
    slide.addShape("line", { x: IN(x + 0.05 * w), y: IN(yy), w: IN(0.9 * w), h: 0, line: { color: "5A5A5A", width: PT(1.2), dashType: "dash" }, objectName: "Reference line" });
    if (axis) slide.addText("correlation", { ...at([x + 0.95 * w, yy - 10, 90, 20]), fontFace: FONT.body, fontSize: PT(14), color: "5A5A5A", margin: 0 });
  }
}

// A schematic test section drawn with shapes: flow arrows, a grid, a leading edge.
function rig(slide, [x, y, w, h]) {
  const f = w / 340;
  const P = (a, b, c, d) => at([x + a * f, y + b * f, c * f, d * f]);
  slide.addShape("rect", { ...P(0, 0, 340, 190), fill: { color: "E6EFE9" }, line: { type: "none" }, objectName: "Test section" });
  for (let k = 0; k < 4; k++) slide.addShape("line", { ...P(20, 30 + 40 * k, 100, 0), line: { color: "4D8A62", width: PT(1.4), endArrowType: "triangle" }, objectName: "Flow" });
  for (let k = 0; k < 7; k++) slide.addShape("rect", { ...P(140, 18 + 24 * k, 8, 14), fill: { color: "787878" }, line: { type: "none" }, objectName: "Grid bar" });
  slide.addShape("ellipse", { ...P(230, 60, 90, 70), fill: { color: "FFFFFF" }, line: { color: "3C3C3C", width: PT(1.6) }, objectName: "Leading edge" });
  slide.addShape("rect", { ...P(275, 58, 65, 74), fill: { color: "E6EFE9" }, line: { type: "none" } });
  slide.addShape("line", { ...P(272, 60, 60, 0), line: { color: "3C3C3C", width: PT(1.6) } });
  slide.addShape("line", { ...P(272, 130, 60, 0), line: { color: "3C3C3C", width: PT(1.6) } });
}

const REF = "Reference: [Author], “[Title],” [Journal] [volume], [pages] ([year]).";

// ---------------------------------------------------------------- opening
pres.addSection({ title: section });
{
  const s = add("Title with Image", {
    title: "Turbulence and leading-edge heat transfer",
    subtitle: "Why the standard correlations miss high turbulence",
    author: "[Presenter name]",
    institution: "[Department] · [University]",
    date: "[Date]",
  }, "Layout: Title with Image. The picture orients the audience: what the talk is about and why it matters. Stay on this slide until the title has sunk in. Say the first sentence of the talk by heart.\n\n" + REF);
  rig(s, [432, 90, 369.89, 206.7]);
}
{
  // Hidden in the slide show: tells people who receive the file where the handout is.
  const s = add("Title Only", { title: "How to read this file", lead: "The speaker notes under each slide hold the details and full references: View › Notes Page, or File › Print › Notes Pages" },
    "Layout: Title Only, hidden (Slide Show › Hide Slide). Keep it second in decks you send: it doesn't project, but readers learn where the handout is.");
  s.hidden = true;
}
add("Outline", { title: "Outline", body: outlineRuns(parts) },
  "Layout: Outline. Section names in green, descriptions in gray, aligned with the names. Descriptions are optional: leave them out for a defence (outlineRuns with null).");
{
  const s = add("Outline Map", { title: "Outline", "part 1": "1. Question", "part 2": "2. Method", "part 3": "3. Results" },
    "Layout: Outline Map, the mapping slide of the assertion-evidence approach: one picture per part. Repeat each picture on the first slide of its part.");
  const tiles = [[X0, 108], [X0 + 261.96, 108], [X0 + 523.93, 108]];
  s.addShape("rect", { ...at([...tiles[0], 237.96, 133]), fill: { color: "D9E6DD" }, line: { type: "none" } });
  s.addText("?", { ...at([...tiles[0], 237.96, 133]), fontFace: FONT.body, fontSize: PT(56), color: COLOR.primary, align: "center", valign: "middle" });
  rig(s, [tiles[1][0], tiles[1][1], 237.96, 133]);
  barChart(s, [tiles[2][0] + 40, tiles[2][1], 157.96, 133], ["", "", "", ""], [1.0, 1.08, 1.17, 1.35], { axis: false, ref: 1.0 });
}

// ---------------------------------------------------------------- part 1
startPart(1);
add("Section", { body: outlineRuns(parts, 1) },
  "Layout: Section. Every section starts with one, the first included: current section green, its description black, the others gray.");
{
  const s = add("Title and Content", {
    title: "The gap",
    lead: "Gas-turbine vanes see 20 % turbulence; the correlations stop at 5 %",
    credit: "Illustrative: highest turbulence intensity in the correlations' data (gray) and at engine vanes (green).",
  }, "Layout: Title and Content. A short title to find the slide, the lead line that states its point as a sentence (at most two lines, never shrunk), and the evidence. Here a native chart: double-click it to edit the data.\n\nRehearsal script: …\nKey phrases: 20 % in engines · fitted below 5 %.\n\n" + REF);
  barChart(s, [250, 154, 340, 250], ["correlations", "engine vanes"], [5, 20], { min: 0, format: '0" %"' });
}

// ---------------------------------------------------------------- part 2
startPart(2);
{
  const s = add("Section with Image", { body: outlineRuns(parts, 2) },
    "Layout: Section with Image. The outline on the left, the section's picture on the right: the same picture as on the mapping slide.");
  rig(s, [496, 153, 305.89, 170.9]);
}
{
  const s = add("Picture with Call-outs", {
    title: "Test section",
    lead: "A grid of bars sets the turbulence level ahead of the leading edge",
  }, "Layout: Picture with Call-outs. Up to four call-outs: short labels joined by thin lines to the parts they name. They replace a bullet list that would describe the picture.\n\n" + REF);
  rig(s, [210, 164, 420, 234.7]);
  addCallout(s, [262, 185], [292, 156], "flow");
  addCallout(s, [390, 385], [330, 419], "turbulence grid", { align: "right" });
  addCallout(s, [504, 281], [650, 221], "heated leading edge");
}
{
  const s = add("Code and Output", {
    title: "Code beside its output",
    lead: [pkgRun("demo"), { text: ": the output on the right comes from the code on the left" }],
    credit: `Code: ${S.FONT.code} on a gray panel; lines never wrap.`,
  }, "Layout: Code and Output. Paste code into the gray panel (keep lines short) and insert the rendered output in the picture placeholder. Here the colors are Typst's own highlighting.");
  addCode(s, code, [40, 241, 430, 64]);
  const h = 300 * 113 / 726;
  s.addImage({ path: path.join(assets, "formula.png"), ...at([490, 273 - h / 2, 300, h]), altText: "Rendered formula" });
}
{
  const s = add("Title Only", { title: "Side cards", lead: "A definition or a reminder sits beside the evidence, never on a results slide" },
    "Cards are drawn shapes: copy one and edit its text. Frames: solid (note, definition, in short), dashed (recap), dotted (reminder). At most 25 words per card.");
  s.addText(bullets(["The evidence of the slide goes here", "Definitions and reminders go in the cards", "Cards have a frame on one side only"]),
    { ...at([40, 157, 500, 250]), fontFace: FONT.body, fontSize: PT(20), color: COLOR.text, valign: "middle", margin: 0 });
  addCard(s, [566, 172, 235.89, 94], { kind: "definition", title: "Stanton number", body: "Heat transfer scaled by the flow's capacity." });
  addCard(s, [566, 276, 235.89, 52], { kind: "reminder", body: "Tu: turbulence intensity." });
}
{
  const s = add("Step", {
    title: "Platform · 1/2 · First step",
    instruction: [{ text: "Open " }, { text: "this", options: { bold: true, color: COLOR.primary } }, { text: ", then click " }, { text: "that", options: { bold: true, color: COLOR.primary } }, { text: "." }],
  }, "Layout: Step. One instruction line, then a full-window screenshot: click the picture icon to insert it.");
  s.addText("", { placeholder: "screenshot" });
}

// ---------------------------------------------------------------- part 3
startPart(3);
add("Section", { body: outlineRuns(parts, 3) });
{
  const s = add("Title and Content", {
    title: "Heat transfer",
    lead: "At 20 % turbulence, heat transfer at the leading edge rises by 35 %, which the correlations miss",
    credit: "Illustrative data: normalised Stanton number.",
  }, "The lead states the finding with its number; the chart is the evidence. The dashed line is a shape drawn over the chart.\n\n" + REF);
  barChart(s, [150, 154, 470, 250], ["Tu 0.5 %", "Tu 5 %", "Tu 10 %", "Tu 20 %"], [1.0, 1.08, 1.17, 1.35], { ref: 1.0 });
}
{
  const s = add("Title Only", { title: "Solver choice", lead: "The implicit solver needs four times fewer steps for the same error" },
    "A short table: three-line style, rules above and below the header and at the end, no vertical lines.");
  const hdr = (t) => ({ text: t, options: { bold: true } });
  const rows = [[hdr("Solver"), hdr("Steps"), hdr("Error"), hdr("Time (s)")], ["Explicit Euler", "12 800", "1.0 × 10⁻³", "4.1"], ["Runge–Kutta 4", "6 400", "0.9 × 10⁻³", "3.2"], ["Implicit (BDF2)", "3 200", "1.0 × 10⁻³", "1.9"]];
  const thick = { type: "solid", pt: PT(2), color: COLOR.text }, thin = { type: "solid", pt: PT(0.6), color: COLOR.text }, none = { type: "none" };
  const table = rows.map((r, i) => r.map((c, j) => {
    const cell = typeof c === "string" ? { text: c, options: {} } : c;
    cell.options.border = [i === 0 ? thick : none, none, i === 0 ? thin : i === rows.length - 1 ? thick : none, none];
    cell.options.align = j === 0 ? "left" : "right";
    return cell;
  }));
  s.addTable(table, { ...at([180, 204, 480, 130]), fontFace: FONT.body, fontSize: PT(20), color: COLOR.text, margin: [PT(3), PT(12), PT(3), PT(12)], colW: [IN(170), IN(95), IN(115), IN(100)] });
  s.addText("Illustrative data.", { placeholder: "credit" });
}
{
  const s = add("Conclusion", {
    title: "Conclusion",
    lead: "In summary, high turbulence raises leading-edge heat transfer well beyond the correlations",
    points: paras([
      [{ text: "1. ", options: { bold: true, color: COLOR.primary } }, { text: "The correlations were fitted below 5 % turbulence" }],
      [{ text: "2. ", options: { bold: true, color: COLOR.primary } }, { text: "A grid sets 0.5–20 % turbulence ahead of the leading edge" }],
      [{ text: "3. ", options: { bold: true, color: COLOR.primary } }, { text: "At 20 %, heat transfer rises by 35 %" }],
    ], (i) => ({ paraSpaceBefore: i ? PT(42) : PT(14) })),
    contact: "[Group name] · [email@example.org]",
    questions: "Questions?",
  }, "Layout: Conclusion, the last slide of a research talk: it stays up while people ask questions. The lead starts with “In summary,”. Up to three supporting points, each with a miniature of a figure shown earlier. Say the last sentence by heart, pause, thank the audience, then invite questions.");
  barChart(s, [40, 144, 96, 56], ["", ""], [5, 20], { axis: false, min: 0 });
  rig(s, [40, 215, 96, 53.6]);
  barChart(s, [40, 280, 96, 56], ["", "", "", ""], [1.0, 1.08, 1.17, 1.35], { axis: false, ref: 1.0 });
  s.addShape("rect", { ...at([40, 388, 48, 48]), fill: { color: "D9E6DD" }, line: { type: "none" }, objectName: "Photo placeholder" });
  s.addImage({ path: path.join(assets, "qr-typst-app.png"), ...at([620, 388, 48, 48]), altText: "QR code" });
}
{
  const s = add("Contact", {
    title: "Contact",
    lead: "High turbulence raises leading-edge heat transfer by up to 35 %",
    lines: paras([[{ text: "[Group name]", options: { bold: true } }], [{ text: "[Department] · [University]" }], [{ text: "[email@example.org]" }]]),
  }, "Layout: Contact, for promotional talks (a seminar elsewhere, recruitment, outreach). Its lead repeats the takeaway. Go back to the conclusion slide for the questions.");
  s.addShape("rect", { ...at([40, 136, 440, 282]), fill: { color: "D9E6DD" }, line: { type: "none" }, objectName: "Photo placeholder" });
  s.addText("[Group photo]", { ...at([40, 136, 440, 282]), fontFace: FONT.body, fontSize: PT(20), color: COLOR.primary, align: "center", valign: "middle" });
  s.addImage({ path: path.join(assets, "qr-typst-app.png"), ...at([508, 268, 120, 120]), altText: "QR code" });
}
add("Black", {}, "Layout: Black. For a stretch of the talk where no visual helps: the audience looks at you. Leave it up at least 30 seconds.");

// ---------------------------------------------------------------- course decks
partNo = 0; section = "Course decks"; pres.addSection({ title: section });
add("Focus", { body: "One sentence on the primary color." }, "Layout: Focus. Counted, number hidden.");
const thanks = [{ text: "Thank you", options: { bold: true, color: COLOR.primary } }, { text: "  Questions?", options: { bold: false, color: COLOR.muted } }];
{
  const s = add("Closing", {
    title: "Resources",
    body: paras([["Touying", "https://touying-typ.github.io"], ["Typst", "https://typst.app"]].map(([t, u]) => [{ text: `${t} — ` }, { text: u.replace("https://", ""), options: { hyperlink: { url: u }, color: COLOR.primary } }]),
      (i) => ({ bullet: true, paraSpaceBefore: i ? PT(8) : 0 })),
    "qr caption": "typst.app",
    closing: thanks,
  }, "Layout: Closing, for courses and seminars, after the summary: links, an optional QR code, then the thank-you line. For two pages, leave the thank-you line empty and add a Thank You slide after it. PowerPoint can't draw QR codes: make one elsewhere (Typst's tiaoma package, for instance) and insert it as a picture.");
  s.addImage({ path: path.join(assets, "qr-typst-app.png"), ...at([S.QR_X, 150, S.QR, S.QR]), altText: "QR code: https://typst.app" });
}
add("Thank You", { closing: thanks.map((r) => ({ text: r.text, options: { ...r.options, align: "center" } })) },
  "Layout: Thank You. A closing page with no heading, after a Closing slide whose thank-you line is left empty.");

// ---------------------------------------------------------------- backup
section = "Backup"; pres.addSection({ title: section });
add("Title and Content", { title: "Backup: uncertainty", lead: "The measured rise exceeds the uncertainty at every turbulence level", locator: "" },
  "Backup slides go in a section named Backup (or Appendix): finish.py --total stops the total before it, so these show their number alone.");

pres.writeFile({ fileName: out }).then((f) => console.log("wrote", f));
