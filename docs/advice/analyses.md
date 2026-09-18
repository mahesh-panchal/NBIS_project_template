# Analyses

`analyses/` contains one numbered folder per analysis run, in the order
the analyses were run:

```
analyses/
 | - README.md                 Structure and History (mermaid diagram of how folders relate)
 | - 01_fetch-source-data/      Standalone script fetching the example's test data
 | - 02_workflow_dev/           Nextflow workflow dev against that test data
 \ - 03_<short_desc>/           Launch scripts + params for the next analysis
```

A numbered folder holds whatever a single launch needs — that's not
always the full Nextflow shape:

- **Nextflow workflow** (the common case for a multi-step, repeatable, or
  large-scale run): `params.yml`, an optional `nextflow.config`, and
  `run_nextflow.sh` — the shell script that launches the workflow in
  `code/` against `data/`. See [`nextflow_workflow.md`](nextflow_workflow.md).
- **Standalone container script** (for a one-off, single-tool step that
  doesn't need Nextflow's orchestration — e.g., running one tool once
  against an existing result): a single shell script that invokes the
  container directly, e.g. `apptainer run <container.sif> <tool> ...` or
  `docker run ...`, with no `params.yml`/`nextflow.config`. It can double
  as an `sbatch` script (`#SBATCH` directives at the top) when it needs to
  be queued rather than run interactively.

Either way, the folder is paired with a task of the same name in the root
`pixi.toml` (`cwd` set to the folder), so it runs as `pixi run <task-name>`.
A Nextflow-workflow folder's `run_nextflow.sh` also leaves behind a
`results` symlink pointing at its `data/results/<analysis>` output, so
you don't need to know/type that path to find it.

## Conventions

- Number folders in the order they were run (`01_`, `02_`, ...), not by
  date — the number already gives a natural ordering, and a short
  description says what the folder is for (`02_workflow_dev`, not
  `02_2024-03-01`).
- Never edit a completed analysis folder's parameters after the fact if
  the run produced results someone might rely on — make a new numbered
  folder instead, and use `analyses/README.md`'s History section (and its
  mermaid diagram) to record how it relates to earlier folders.
- Keep extending a workflow (adding processes/tools) in the *same* analysis
  folder if it's a continuation of the same line of results; start a *new*
  folder for a different workflow script or a materially different
  parameter set (e.g., test data vs. full data).
- `nextflow log` shows the date and status of past runs in a folder; use
  it, plus git tags on `main`, to mark completed stages.

When asked to set up a new analysis, create the next numbered folder with
whichever shape above fits the task, add its matching task to the root
`pixi.toml`, and update the History section in
[`../../analyses/README.md`](../../analyses/README.md) to describe how it
relates to other folders.
