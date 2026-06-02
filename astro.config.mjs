// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// GitHub Pages（项目站点）默认地址：https://panerai27.github.io/rocokingdom/
// 如果将来绑定自定义域名，把 site 改成你的域名，并把 base 改成 '/'。
export default defineConfig({
  site: 'https://panerai27.github.io',
  base: '/rocokingdom',
  trailingSlash: 'ignore',
  integrations: [sitemap()],
});
