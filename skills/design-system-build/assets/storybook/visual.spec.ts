// Visual regression: screenshot every Storybook story and compare it with the committed baseline.
//
// Usage:
//   1. npx storybook build                       # produces storybook-static/ (including index.json)
//   2. Serve storybook-static with a static server, or configure webServer in playwright.config.ts
//   3. Create the first baseline: npx playwright test visual.spec.ts --update-snapshots
//   4. After every change:        npx playwright test visual.spec.ts
//
// Environment variables:
//   STORYBOOK_URL         default http://localhost:6006
//   STORYBOOK_STATIC_DIR  default storybook-static
//
// Commit the baseline screenshots. Run --update-snapshots only when a visual change is expected and confirmed.
// Tag stories that should not be compared with "skip-visual".
import fs from "node:fs";
import path from "node:path";

import { expect, test } from "@playwright/test";

const STORYBOOK_URL = process.env.STORYBOOK_URL ?? "http://localhost:6006";
const STATIC_DIR = process.env.STORYBOOK_STATIC_DIR ?? "storybook-static";

type IndexEntry = {
  id: string;
  title: string;
  name: string;
  type: "story" | "docs";
  tags?: string[];
};

const indexPath = path.join(STATIC_DIR, "index.json");
if (!fs.existsSync(indexPath)) {
  throw new Error(`${indexPath} not found. Run npx storybook build first.`);
}

const index = JSON.parse(fs.readFileSync(indexPath, "utf8")) as {
  entries: Record<string, IndexEntry>;
};

const stories = Object.values(index.entries).filter(
  (entry) => entry.type === "story" && !entry.tags?.includes("skip-visual"),
);

for (const story of stories) {
  test(`${story.title} › ${story.name}`, async ({ page }) => {
    await page.goto(`${STORYBOOK_URL}/iframe.html?id=${story.id}&viewMode=story`);
    await page.waitForLoadState("networkidle");
    await page.evaluate(async () => {
      await document.fonts.ready;
    });
    await expect(page).toHaveScreenshot(`${story.id}.png`, {
      animations: "disabled",
      fullPage: true,
    });
  });
}
