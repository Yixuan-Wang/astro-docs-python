# syntax=docker/dockerfile:1.7
FROM node:22-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV PNPM_HOME=/pnpm \
    PATH=/pnpm:$PATH \
    UV_LINK_MODE=copy \
    DOCS_SOURCE_ROOT=/app/source

RUN corepack enable && corepack prepare pnpm@12.4.2 --activate \
 && pnpm config set store-dir /pnpm/store --global

WORKDIR /app

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN --mount=type=cache,id=pnpm,target=/pnpm/store \
    pnpm install --frozen-lockfile --ignore-scripts
RUN --mount=type=cache,id=pnpm,target=/pnpm/store \
    pnpm rebuild esbuild sharp

COPY tsconfig.json astro.config.mjs ./
COPY src/ ./src/

RUN mkdir -p /app/docs/site /app/src/content/docs /app/source /app/dist

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["build"]
