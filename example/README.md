# Example site

A minimal set of the three engine inputs, used by CI to smoke-test the image
and handy for local engine development.

| Volume  | Path              | Container mount         |
| ------- | ----------------- | ----------------------- |
| site    | `example/site`    | `/app/docs/site`        |
| content | `example/content` | `/app/src/content/docs` |
| source  | `example/source`  | `/app/source`           |

Build with the container:

```sh
docker build -t docs-engine .
SITE_DIR=example/site CONTENT_DIR=example/content ./build.sh example/source
```

Run the dev server against it (`docs/` and `src/content/` are gitignored mount
points):

```sh
ln -s example docs
mkdir -p src/content && ln -s ../../docs/content src/content/docs
vp run dev
```
