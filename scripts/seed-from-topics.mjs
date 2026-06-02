// Seed 20 long-tail wiki markdown files from scripts/topics.json
// Usage: node scripts/seed-from-topics.mjs
import { readFile, writeFile, mkdir, access } from 'node:fs/promises';
import { constants } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const root = resolve(__dirname, '..');
const topicsPath = resolve(__dirname, 'topics.json');
const outDir = resolve(root, 'src/content/wiki');

const today = new Date().toISOString().slice(0, 10);
const topics = JSON.parse(await readFile(topicsPath, 'utf8'));
await mkdir(outDir, { recursive: true });

const exists = async (p) => {
  try { await access(p, constants.F_OK); return true; } catch { return false; }
};

const body = (h1) => `本篇为长期维护内容，会随版本变化补充与修订。

## 核心结论

- 结论 1：先用一句话概括最重要的判断。
- 结论 2：补充次要但关键的策略。
- 结论 3：标明需要避免的情况。

## 详细说明

这里展开 3-5 段的实战说明，覆盖背景、做法与对比，确保读者能直接落地操作。

## 分场景建议

| 场景 | 推荐做法 | 注意点 |
| --- | --- | --- |
| 新手期 | …… | …… |
| 中期 | …… | …… |
| 毕业期 | …… | …… |

## 常见疑问

对 2-3 个最高频的玩家提问做精炼回答，便于长尾搜索命中。
`;

let written = 0;
for (const t of topics) {
  const file = resolve(outDir, `${t.slug}.md`);
  if (await exists(file)) { console.log('skip exists:', t.slug); continue; }
  const kw = String(t.kw).split(',').map((s) => s.trim()).filter(Boolean);
  const fm = `---
title: ${t.title}
description: ${t.desc}
keywords: [${kw.join(', ')}]
category: 攻略
pubDate: ${today}
updatedDate: ${today}
---

${body(t.h1)}`;
  await writeFile(file, fm, 'utf8');
  written++;
  console.log('wrote:', `${t.slug}.md`);
}
console.log(`done. total: ${topics.length}, newly written: ${written}`);
