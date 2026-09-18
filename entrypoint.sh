#!/usr/bin/env bash
set -euo pipefail

# The Python source tree is mounted at $DOCS_SOURCE_ROOT (default /app/source);
# starlight-pydocs reads $DOCS_SOURCE_ROOT/src via Griffe.
export DOCS_SOURCE_ROOT="${DOCS_SOURCE_ROOT:-/app/source}"

# Fail fast with a clear message if a volume is missing. astro.config.mjs imports
# ./docs/site/config at config-load time, so the site volume must be present.
[ -f /app/docs/site/config.ts ] || { echo "ERROR: 'site' volume not mounted at /app/docs/site (config.ts missing)" >&2; exit 1; }
[ -d /app/src/content/docs ]    || { echo "ERROR: 'content' volume not mounted at /app/src/content/docs" >&2; exit 1; }
[ -d "$DOCS_SOURCE_ROOT/src" ]  || { echo "ERROR: 'source' volume missing Python sources at $DOCS_SOURCE_ROOT/src" >&2; exit 1; }

case "${1:-build}" in
  build)
    # Griffe runs during this step (uvx --from griffe griffe dump …).
    exec pnpm exec astro build --outDir /app/dist
    ;;
  *)
    # Escape hatch: `docker run … sh`, `… astro check`, etc.
    exec "$@"
    ;;
esac
