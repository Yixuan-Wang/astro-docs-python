import path from "node:path";

const sourceRoot = process.env.DOCS_SOURCE_ROOT ?? "./example/source";

const site = {
  title: "Example",
  description: "Smoke-test site for astro-docs-python.",
  pydocs: {
    packages: [
      {
        name: "example_pkg",
        base: "api/example_pkg",
        docstringStyle: "google",
        search: [path.join(sourceRoot, "src")],
        sidebar: { label: "Reference" },
      },
    ],
    inventories: ["python"],
  },
  sidebar: [{ label: "Guide", items: [{ label: "Getting started", slug: "getting-started" }] }],
};

export default site;
