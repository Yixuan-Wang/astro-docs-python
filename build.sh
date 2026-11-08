#!/usr/bin/env bash
# Usage: ./build.sh SOURCE_DIR [OUT_DIR]
# Env overrides: DOCS_ENGINE_IMAGE, SITE_DIR, CONTENT_DIR, SOURCE_DIR, OUT_DIR
set -euo pipefail

IMAGE="${DOCS_ENGINE_IMAGE:-docs-engine}"
SITE_DIR="${SITE_DIR:-$PWD/docs/site}"
CONTENT_DIR="${CONTENT_DIR:-$PWD/docs/content}"
SOURCE_DIR="${1:-${SOURCE_DIR:?usage: ./build.sh SOURCE_DIR [OUT_DIR]}}"
OUT_DIR="${2:-${OUT_DIR:-$PWD/out}}"

SITE_DIR="$(cd "$SITE_DIR" && pwd)"
CONTENT_DIR="$(cd "$CONTENT_DIR" && pwd)"
SOURCE_DIR="$(cd "$SOURCE_DIR" && pwd)"
mkdir -p "$OUT_DIR"
OUT_DIR="$(cd "$OUT_DIR" && pwd)"

cid="$(docker create \
  -v "$SITE_DIR:/app/docs/site:ro" \
  -v "$CONTENT_DIR:/app/src/content/docs:ro" \
  -v "$SOURCE_DIR:/app/source:ro" \
  "$IMAGE")"
trap 'docker rm -f "$cid" >/dev/null 2>&1 || true' EXIT

docker start -a "$cid"
docker cp "$cid:/app/dist/." "$OUT_DIR/"

echo "Docs written to $OUT_DIR (owned by $(id -un))"
