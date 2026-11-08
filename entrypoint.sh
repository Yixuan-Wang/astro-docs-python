#!/usr/bin/env bash
set -euo pipefail

export DOCS_SOURCE_ROOT="${DOCS_SOURCE_ROOT:-/app/source}"

[ -f /app/docs/site/config.ts ] || { echo "ERROR: 'site' volume not mounted at /app/docs/site (config.ts missing)" >&2; exit 1; }
[ -d /app/src/content/docs ]    || { echo "ERROR: 'content' volume not mounted at /app/src/content/docs" >&2; exit 1; }
[ -d "$DOCS_SOURCE_ROOT/src" ]  || { echo "ERROR: 'source' volume missing Python sources at $DOCS_SOURCE_ROOT/src" >&2; exit 1; }

case "${1:-build}" in
  build)
    exec pnpm exec astro build --outDir /app/dist
    ;;
  *)
    exec "$@"
    ;;
esac
