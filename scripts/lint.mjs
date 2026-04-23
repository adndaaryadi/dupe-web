import { readFileSync, existsSync } from "node:fs";

const files = ["index.html", "story.html", "links.html", "style.css", "app.js"];
for (const file of files) {
  if (!existsSync(file)) {
    throw new Error(`File wajib hilang: ${file}`);
  }
}

for (const page of ["index.html", "story.html", "links.html"]) {
  const html = readFileSync(page, "utf8");
  for (const expected of ["<!doctype html>", "<title>", 'name="description"', 'class="nav"']) {
    if (!html.includes(expected)) {
      throw new Error(`${page} belum memuat penanda ${expected}`);
    }
  }
  if (html.includes("Lorem ipsum")) {
    throw new Error(`${page} masih punya placeholder lorem ipsum`);
  }
}

const css = readFileSync("style.css", "utf8");
if (!css.includes("@media")) {
  throw new Error("style.css wajib punya aturan responsif");
}

console.log("static lint ok");
