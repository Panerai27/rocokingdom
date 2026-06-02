# Rocokingdom Wiki MVP

这是一个可直接上线的静态 Wiki 基础版，目标是：
- 符合 Google SEO 基础规范
- 满足 AdSense 申请必备页面与技术要素
- 支持持续内容更新和流量增长

## 当前已完成
- 首页与三篇核心词条（新手、宠物榜、活动日历）
- 基础 SEO：title、description、canonical、robots、sitemap
- 结构化数据：WebSite / Article
- AdSense 预留：ads.txt + 页面广告位占位
- 合规页面：About / Contact / Privacy
- 运营文档：SEO手册、90天内容计划、AdSense清单

## 文件结构
- /index.html
- /wiki/beginner-guide.html
- /wiki/pet-tier-list.html
- /wiki/event-calendar.html
- /about.html
- /contact.html
- /privacy.html
- /styles.css
- /robots.txt
- /sitemap.xml
- /ads.txt
- /guides/seo-playbook.md
- /guides/content-calendar-90d.md
- /guides/adsense-checklist.md

## 上线步骤（建议）
1. 购买并绑定域名（建议 rocokingdom.wiki 或同类品牌域名）。
2. 使用 Cloudflare Pages / Netlify / GitHub Pages 部署本目录。
3. 将以下占位信息替换为真实值：
   - 所有页面中的 canonical 域名
   - AdSense client ID（ca-pub-XXXXXXXXXXXXXXXX）
   - ads.txt 的 pub ID
   - 联系邮箱
4. 接入 Google Search Console 并提交 sitemap。
5. 接入 GA4（建议），监控流量与页面表现。

## AdSense 申请建议
- 先积累 25-40 篇原创词条后再申请。
- 保证每篇有明确价值，非空壳页面。
- 控制广告密度，优先可读性和停留时长。

## 持续更新节奏（推荐）
- 每周至少 3 篇：1篇核心更新 + 2篇长尾新文
- 每周刷新 1-2 篇旧文并标注更新时间
- 每月复盘关键词覆盖与排名变化
