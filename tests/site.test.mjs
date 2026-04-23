import test from "node:test";
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const pages = ["index.html", "story.html", "links.html"];

test("semua halaman punya navigasi silang", () => {
  for (const page of pages) {
    const html = readFileSync(page, "utf8");
    for (const href of ['./index.html', './story.html', './links.html']) {
      assert.ok(html.includes(href), `${page} belum punya tautan ${href}`);
    }
  }
});

test("halaman links tetap mempertahankan jalur yang terverifikasi", () => {
  const html = readFileSync("links.html", "utf8");
  assert.ok(html.includes("https://caturnawa.unasfest.com/"));
  assert.ok(html.includes("https://www.unasfest.com/"));
});
