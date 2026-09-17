# Environment management

Tools needed to work in this repository (Nextflow, nf-core tools, Quarto,
...) are declared as dependencies in the root [`pixi.toml`](../../pixi.toml)
and resolved with [pixi](https://pixi.sh), not a manually managed conda
environment.

- Never call `conda`/`mamba`/`micromamba` directly in this repository —
  use `pixi run <command>` (or a defined task, see `pixi task list`)
  instead, even for one-off checks.
- Add new tool dependencies to `pixi.toml`'s `[dependencies]` table rather
  than creating a separate environment file.
- Repeated commands (rendering docs, linking the upstream template, ...)
  are defined as `[tasks]` in `pixi.toml` — run them with `pixi run <task>`.
- `analyses/<n>_<desc>/run_nextflow.sh` scripts call Nextflow through
  `pixi run --manifest-path <project_root>/pixi.toml nextflow ...` so they
  work without first activating anything.
- Never include the `defaults` conda channel in `pixi.toml` or any vendored
  `environment.yml` — only `conda-forge`/`bioconda`.

When asked to add a tool or change how an environment is built, edit
`pixi.toml` and re-resolve with `pixi lock --dry-run` before installing.
