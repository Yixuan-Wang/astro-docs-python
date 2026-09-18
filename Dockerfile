# syntax=docker/dockerfile:1.7
#
# Documentation build engine: a reusable Astro + Starlight image that bakes the
# generic toolchain and takes each package's inputs as runtime volumes.
#
#   site    volume -> /app/docs/site        (config, plugins, styles, assets, public)
#   content volume -> /app/src/content/docs  (the markdown docs)
#   source  volume -> /app/source            (Python source; DOCS_SOURCE_ROOT)
#   output         -> /app/dist
#
# node_modules is generated here (pnpm install); `astro build` runs at RUNTIME
# via the entrypoint, against the mounted volumes.
#
# Debian slim (not Alpine): sharp ships glibc prebuilts, the uv binary is glibc,
# and starlight-pydocs requires Node >=22.12.
FROM node:22-slim

# uv / uvx for starlight-pydocs, which shells out to Griffe via `uvx --from
# griffe` (static source analysis — no venv, no target-package install needed).
# TODO: pin to an exact version or @sha256 digest for reproducible builds.
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV PNPM_HOME=/pnpm \
    PATH=/pnpm:$PATH \
    UV_LINK_MODE=copy \
    DOCS_SOURCE_ROOT=/app/source

# pnpm via corepack. package.json pins pnpm only under devEngines.packageManager,
# which corepack does not read, so activate the version explicitly.
RUN corepack enable && corepack prepare pnpm@12.4.2 --activate \
 && pnpm config set store-dir /pnpm/store --global

WORKDIR /app

# Resolve dependencies from the lockfile. --ignore-scripts skips the project's
# `prepare: vp config` (vite-plus) hook we don't need in the image; we then
# rebuild only the approved native packages (see pnpm-workspace.yaml allowBuilds).
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN --mount=type=cache,id=pnpm,target=/pnpm/store \
    pnpm install --frozen-lockfile --ignore-scripts
RUN --mount=type=cache,id=pnpm,target=/pnpm/store \
    pnpm rebuild esbuild sharp

# Engine source only. Never copy docs/ (site + content volumes) or the Python
# source — those arrive as runtime mounts.
COPY tsconfig.json astro.config.mjs ./
COPY src/ ./src/

# Create the mount points so bind mounts land cleanly on an empty dir.
RUN mkdir -p /app/docs/site /app/src/content/docs /app/source /app/dist

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["build"]
