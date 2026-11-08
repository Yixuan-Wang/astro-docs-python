// @ts-check
import { defineConfig } from "astro/config";
import { satteri } from "@astrojs/markdown-satteri";
import starlight from "@astrojs/starlight";
import starlightPydocs, { pydocsSidebarGroup } from "starlight-pydocs";
import siteInput from "./docs/site/config";

const site = /** @type {import("./src/site").SiteConfig} */ (siteInput);

const plugins = [];
const sidebar = [...(site.sidebar ?? [])];

if (site.pydocs) {
  plugins.push(starlightPydocs(site.pydocs));
  sidebar.push(pydocsSidebarGroup);
}

// https://astro.build/config
export default defineConfig({
  site: site.url,
  publicDir: "./docs/site/public",
  markdown: {
    processor: satteri({
      features: { directive: true },
      mdastPlugins: site.mdastPlugins ?? [],
    }),
  },
  integrations: [
    starlight({
      title: site.title,
      description: site.description,
      favicon: site.favicon,
      logo: site.logo,
      customCss: [
        "./src/styles/base.css",
        "@fontsource-variable/ibm-plex-sans/wght.css",
        "@fontsource-variable/ibm-plex-sans/wght-italic.css",
        "@fontsource-variable/jetbrains-mono/wght.css",
        "@fontsource-variable/jetbrains-mono/wght-italic.css",
        ...(site.styles ?? []),
      ],
      social: site.social,
      plugins,
      sidebar,
    }),
  ],
});
