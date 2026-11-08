# astro-docs-python

Build Python documentation within JavaScript land.

Python documentation is extracted with [Griffe](https://github.com/mkdocstrings/griffe) and then rendered within [Astro](https://docs.astro.build/)
stack using [Starlight](https://starlight.astro.build/) and [`starlight-pydocs`](https://github.com/Yixuan-Wang/starlight-pydocs).

## Usage

The engine is a container image that takes three volumes:

| Volume  | Container mount         | Contents                                                    |
| ------- | ----------------------- | ----------------------------------------------------------- |
| site    | `/app/docs/site`        | `config.ts` (see `src/site.ts`), plugins, styles, `public/` |
| content | `/app/src/content/docs` | Starlight Markdown pages                                    |
| source  | `/app/source`           | The Python project; sources are read from `src/` via Griffe |

```sh
SITE_DIR=path/to/site CONTENT_DIR=path/to/content ./build.sh path/to/python-project [OUT_DIR]
```

See [`example/`](./example) for a minimal working set of inputs.
