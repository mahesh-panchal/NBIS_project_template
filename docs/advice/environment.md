# Environment management

Tools needed to work in this repository (Nextflow, nf-core tools, Quarto,
...) are declared as dependencies in the root [`pixi.toml`](../../pixi.toml)
and resolved with [pixi](https://pixi.sh), not a manually managed conda
environment.

## Adding a tool

```bash
pixi add <package>
pixi lock --dry-run
```

Add it to `pixi.toml`'s `[dependencies]` table (`pixi add` does this for
you). Never include the `defaults` conda channel in `pixi.toml` or any
vendored `environment.yml` — only `conda-forge`/`bioconda`.

## Container images and Seqera Wave

```bash
pixi init --import <environment.yml> -p linux-64 scratch/precheck
pixi lock --manifest-path scratch/precheck/pixi.toml --dry-run
```

Run this before building a container — it validates a conda/pip spec
resolves, using [`../../scratch/`](../../scratch/README.md) as scratch
space. Nextflow processes always run containerised, pulling images from
a registry; when a tool has no existing public image (Biocontainers,
Rocker, ...), build one with [Seqera Containers](https://seqera.io/containers/)
(Wave) from that spec rather than hand-writing a `Dockerfile` under
`code/containers/`. Only fall back to a custom `Dockerfile` when Wave and
existing public images don't cover it — see [`code.md`](code.md).

The container cache itself defaults to
[`scratch/apptainer-cache/`](../../scratch/README.md), set via
`NXF_APPTAINER_CACHEDIR` in `pixi.toml`'s `[activation.env]` (Apptainer is
the maintained successor to Singularity — prefer its env var/CLI name
over the `singularity`-named equivalents). On HPC clusters with a
separate storage allocation, `run_nextflow.sh` overrides this to point at
`nobackup/` instead (see [`nextflow_workflow.md`](nextflow_workflow.md))
— `scratch/` covers local development and anywhere without a separate
allocation.

## Publishing a custom container

```bash
docker build -t ghcr.io/<org>/<image_name>:<tag> .
echo "$GITHUB_TOKEN" | docker login ghcr.io -u <username> --password-stdin
docker push ghcr.io/<org>/<image_name>:<tag>
```

Use when Wave and existing public images genuinely don't cover a tool,
building from a `Dockerfile` in `code/containers/<tool_name>/`. New
images are private by default — make the package public from its GitHub
package settings once it's ready to be pulled without authentication.

To build straight from a conda/pip spec, skipping the `Dockerfile`
entirely, use the Wave CLI itself. It's a standalone binary, not a pixi
package — download it from the
[wave-cli releases page](https://github.com/seqeralabs/wave-cli/releases/latest)
(pick the asset matching your OS/arch, e.g. `wave-<version>-macos-arm64`
or `wave-<version>-linux-x86_64`) and make it executable:

```bash
chmod 755 wave-<version>-<os>-<arch>
./wave-<version>-<os>-<arch> --conda-file environment.yml --freeze --await
# -> community.wave.seqera.io/library/<name>:<tag>
```

## Per-notebook environments

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

Run with `pixi run -e stats stats-notebook`. A notebook under
`code/notebooks/` (see [`code.md`](code.md)) that needs a different
package set than the project default gets its own pixi feature and
environment this way, rather than a hand-written `environment.yml` in a
separate folder — one source of truth, dry-run-checked the same way as
every other dependency.

## Platform-specific tasks

```toml
[target.linux.tasks.view-results]
cmd = "apptainer exec $NXF_APPTAINER_CACHEDIR/<image>.sif <viewer> <args>"

[target.osx.tasks.view-results]
cmd = "docker run --rm -v \"$PWD:/data\" <image>:<tag> <viewer> <args>"
```

`pixi run view-results` then does the right thing whichever platform
it's run from. Use this when a task needs a different invocation on
HPC/Linux (typically Apptainer) than locally on macOS (typically Docker),
rather than branching inside a single command.

## Personal pixi setup on HPC

```bash
export PIXI_CACHE_DIR=/proj/naiss20XX-YY-ZZ/<user>/nobackup/.pixi-cache
export PIXI_HOME=/proj/naiss20XX-YY-ZZ/<user>/nobackup/.pixi-home
mkdir -p "$PIXI_CACHE_DIR" "$PIXI_HOME"
export PATH="$PATH:$PIXI_HOME/bin"
```

Add to your shell profile if pixi's default cache/global-install
directories (`~/.cache/rattler`, `~/.pixi`) hit a small home-directory
quota on HPC. This is personal machine setup, not something `pixi.toml`
can declare.

## Syncing with HPC

```bash
pixi run git-link-hpc <user>@<hpc-login-node>:/proj/naiss20XX-YY-ZZ/<project_root>
pixi run fetch-results 02_workflow_dev
```

`git-link-hpc` records the HPC clone's SSH address as a git remote named
`hpc` — a git-over-SSH address and an rsync-over-SSH address share the
same `user@host:/path` syntax, so `$(git remote get-url hpc)` doubles as
an rsync prefix. `fetch-results` uses it to pull an analysis's results
from the HPC clone to your local one (`data/results/<analysis>/` on both
sides — see [`data_management.md`](data_management.md)); add similar
tasks for other `data/` subfolders as needed. This is one-directional
(HPC -> local) and only ever touches `data/`, not git history — see
[`how_to.md`](how_to.md#starting-a-new-project) for why `git push hpc`
specifically is never the right move.

## Conventions

- Never call `conda`/`mamba`/`micromamba` directly in this repository —
  use `pixi run <command>` (or a defined task, see `pixi task list`)
  instead, even for one-off checks. The Wave CLI is the one exception —
  it's not on conda-forge/bioconda, so it's a manually downloaded binary
  (see [Publishing a custom container](#publishing-a-custom-container)),
  not a pixi dependency.
- Repeated commands (rendering docs, linking the upstream template, ...)
  are defined as `[tasks]` in `pixi.toml` — run them with `pixi run <task>`.
- `analyses/<n>_<desc>/run_nextflow.sh` scripts assume `nextflow` is
  already on `PATH` — each has a matching pixi task (`cwd` baked in), so
  launch them with `pixi run <task-name>` (or from inside `pixi shell`),
  never by activating a conda environment. See
  [`nextflow_workflow.md`](nextflow_workflow.md).
