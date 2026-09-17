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
- `analyses/<n>_<desc>/run_nextflow.sh` scripts assume `nextflow` is
  already on `PATH` — each has a matching pixi task (`cwd` baked in), so
  launch them with `pixi run <task-name>` (or from inside `pixi shell`),
  never by activating a conda environment. See
  [`nextflow_workflow.md`](nextflow_workflow.md).
- Never include the `defaults` conda channel in `pixi.toml` or any vendored
  `environment.yml` — only `conda-forge`/`bioconda`.

When asked to add a tool or change how an environment is built, edit
`pixi.toml` and re-resolve with `pixi lock --dry-run` before installing.

## Container images and Seqera Wave

Nextflow processes always run containerised, pulling images from a
registry. When a tool has no existing public image (Biocontainers,
Rocker, ...), prefer building one with
[Seqera Containers](https://seqera.io/containers/) (Wave) from a
conda/pip environment spec over hand-writing a `Dockerfile` under
`code/containers/`. Validate the spec resolves *before* building, using
[`../../scratch/`](../../scratch/README.md) as scratch space:

```bash
pixi init --import <environment.yml> -p linux-64 scratch/precheck
pixi lock --manifest-path scratch/precheck/pixi.toml --dry-run
```

Only fall back to a custom `Dockerfile` when Wave and existing public
images don't cover it — see [`code.md`](code.md).

The container cache itself defaults to
[`scratch/singularity-cache/`](../../scratch/README.md), set via
`NXF_SINGULARITY_CACHEDIR` in `pixi.toml`'s `[activation.env]`. On HPC
clusters with a separate storage allocation, `run_nextflow.sh` overrides
this to point at `nobackup/` instead (see
[`nextflow_workflow.md`](nextflow_workflow.md)) — `scratch/` covers local
development and anywhere without a separate allocation.

## Per-notebook environments

A notebook under `code/notebooks/` (see [`code.md`](code.md)) that needs
a different set of packages than the project default gets its own pixi
feature and environment, rather than a hand-written `environment.yml` in
a separate folder:

```toml
[feature.stats.dependencies]
python = "*"
pandas = "*"

[feature.stats.tasks.stats-notebook]
cmd = "quarto render stats.qmd"
cwd = "code/notebooks"

[environments]
stats = ["stats"]
```

Run it with `pixi run -e stats stats-notebook`. This keeps one source of
truth for every environment the project needs (all resolved and
dry-run-checked the same way) instead of a parallel, hand-maintained set
of environment files.
