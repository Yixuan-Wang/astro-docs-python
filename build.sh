#!/usr/bin/env bash
#
# Build the docs with the engine container and extract the output to the host as
# the current (non-root) user. Uses `docker cp` so the output is never
# root-owned, on Linux and macOS alike.
#
# Usage:
#   ./build.sh [SOURCE_DIR] [OUT_DIR]
#
# Env overrides: DOCS_ENGINE_IMAGE, SITE_DIR, CONTENT_DIR, SOURCE_DIR, OUT_DIR
set -euo pipefail

IMAGE="${DOCS_ENGINE_IMAGE:-docs-engine}"
SITE_DIR="${SITE_DIR:-$PWD/docs/site}"
CONTENT_DIR="${CONTENT_DIR:-$PWD/docs/content}"
SOURCE_DIR="${1:-${SOURCE_DIR:-$PWD/../apfel}}"
OUT_DIR="${2:-${OUT_DIR:-$PWD/out}}"

# Resolve to absolute paths (docker requires them for -v).
SITE_DIR="$(cd "$SITE_DIR" && pwd)"
CONTENT_DIR="$(cd "$CONTENT_DIR" && pwd)"
SOURCE_DIR="$(cd "$SOURCE_DIR" && pwd)"
mkdir -p "$OUT_DIR"
OUT_DIR="$(cd "$OUT_DIR" && pwd)"

# Create (not run) the container so we can copy /app/dist out after it exits.
# dist is intentionally NOT bind-mounted — it stays inside the container and is
# extracted with `docker cp`, which writes files owned by the host user.
cid="$(docker create \
  -v "$SITE_DIR:/app/docs/site:ro" \
  -v "$CONTENT_DIR:/app/src/content/docs:ro" \
  -v "$SOURCE_DIR:/app/source:ro" \
  "$IMAGE")"
trap 'docker rm -f "$cid" >/dev/null 2>&1 || true' EXIT

docker start -a "$cid"                 # run the build, stream its logs
docker cp "$cid:/app/dist/." "$OUT_DIR/"

echo "Docs written to $OUT_DIR (owned by $(id -un))"
