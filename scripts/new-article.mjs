// Create a new wiki article markdown file.
// Usage: node scripts/new-article.mjs <slug> "<title>" "<description>" "kw1,kw2" [category]
import { writeFile, mkdir, access } from 'node:fs/promises';
import { constants } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const outDir = resolve(__dirname, '..', 'src/content/wiki');

const [slug, title, description, kwRaw = '', category = '攻略'] = process.argv.slice(2);
if (!slug || !title || !description) {
  console.error('Usage: node scripts/new-article.mjs <slug> "<title>" "<description>" "kw1,kw2" [category]');
  process.exit(1);
}

await mkdir(outDir, { recursive: true });
const file = resolve(outDir, `${slug}.md`);
try { await access(file, constants.F_OK); console.error('already exists:', file); process.exit(1); } catch {}

const today = new Date().toISOString().slice(0, 10);
const kw = kwRaw.split(',').map((s) => s.trim()).filter(Boolean);

const content = `---
title: ${title}
description: ${description}
keywords: [${kw.join(', ')}]
category: ${category}
pubDate: ${today}
updatedDate: ${today}
---

在这里撰写正文。建议包含：核心结论、详细说明、分场景建议、常见疑问、相关阅读。
`;

await writeFile(file, content, 'utf8');
console.log('created:', file);
