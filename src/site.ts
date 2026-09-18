import type { SatteriProcessorOptions } from "@astrojs/markdown-satteri";
import type { StarlightUserConfig } from "@astrojs/starlight/types";
import type { StarlightPydocsOptions } from "starlight-pydocs";

/**
 * The contract the engine (`astro.config.mjs`) consumes from the `docs/site`
 * volume.
 *
 * `docs/` is downstream input mounted at build time, not part of this
 * repository. The engine therefore reads the mounted `config` module through
 * this declared shape rather than depending on whatever concrete types happen
 * to be inferred from a particular checkout: a malformed config is a *runtime*
 * error, surfaced by Starlight's schema validation and starlight-pydocs'
 * `normalizeConfig`, not something the engine's own type check should police.
 *
 * Each field mirrors the option it is forwarded to, so the engine's wiring
 * stays type-checked against the libraries even though the input is not.
 */
export interface SiteConfig {
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
