import type { SatteriProcessorOptions } from "@astrojs/markdown-satteri";
import type { StarlightUserConfig } from "@astrojs/starlight/types";
import type { StarlightPydocsOptions } from "starlight-pydocs";

export interface SiteConfig {
  url?: string;
  title: StarlightUserConfig["title"];
  description?: StarlightUserConfig["description"];
  favicon?: StarlightUserConfig["favicon"];
  logo?: StarlightUserConfig["logo"];
  social?: StarlightUserConfig["social"];
  /** Package stylesheets, appended after the engine defaults. */
  styles?: string[];
  /** Markdown (mdast) plugins contributed by this package. */
  mdastPlugins?: SatteriProcessorOptions["mdastPlugins"];
  /** API-reference generation. Omit to disable. */
  pydocs?: StarlightPydocsOptions;
  sidebar?: StarlightUserConfig["sidebar"];
}
