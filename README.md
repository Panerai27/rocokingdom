# Rocokingdom Wiki (Astro)

洛克王国资料站，使用 Astro 静态生成，部署到 GitHub Pages，面向 SEO + AdSense 变现与长期内容更新。

## 技术栈
- Astro（静态站点生成，默认零 JS，利于 SEO 与性能）
- @astrojs/sitemap（自动生成 sitemap-index.xml）
- 内容集（Content Collections）：Markdown 写作，统一 schema 与布局

## 目录结构
- `src/pages/` 路由页面（首页、FAQ、about/contact/privacy）
- `src/pages/wiki/[slug].astro` 词条详情动态路由
- `src/pages/wiki/index.astro` 词条索引（按分类）
- `src/content/wiki/*.md` 词条内容（Markdown + frontmatter）
- `src/content.config.ts` 内容集 schema（loader 模式）
- `src/layouts/BaseLayout.astro` 统一布局 + SEO/OG/JSON-LD 注入
- `src/components/AdSlot.astro` 广告位组件
- `public/` 静态资源（styles.css、robots.txt、ads.txt、.nojekyll）
- `scripts/new-article.mjs` 新建词条脚本
- `scripts/seed-from-topics.mjs` 从 topics.json 批量生成词条
- `.github/workflows/pages.yml` GitHub Actions 自动构建并部署

## 本地开发
```powershell
npm install
npm run dev      # 本地预览 http://localhost:4321/rocokingdom
npm run build    # 生成 dist/
npm run preview  # 预览构建产物
```
> 若 PowerShell 提示脚本被禁用，可在当前会话执行：`Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force`

## 新增一篇词条
方式一（推荐，命令行）：
```powershell
npm run new -- my-slug "标题" "描述" "关键词1,关键词2" 分类
```
方式二：直接在 `src/content/wiki/` 新建 `.md`，按现有 frontmatter 字段填写。

提交后推送，GitHub Actions 会自动重新构建并部署，sitemap 自动更新。

## 部署到 GitHub Pages
1. 仓库 Settings → Pages → Source 选择 `GitHub Actions`。
2. 推送到 `main` 即触发 `.github/workflows/pages.yml` 自动部署。
3. 访问地址：https://panerai27.github.io/rocokingdom/

## 上线前需替换的占位
- AdSense client id：`ca-pub-XXXXXXXXXXXXXXXX`（`src/layouts/BaseLayout.astro`）
- ads.txt 的 pub id（`public/ads.txt`）
- 如绑定自定义域名：修改 `astro.config.mjs` 的 `site` 为你的域名、`base` 改为 `'/'`，并在 `public/` 添加 `CNAME` 文件。

## 运营文档
见 `guides/` 目录：SEO 手册、90 天内容计划、AdSense 清单。
