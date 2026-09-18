# Data management

This repository is organised around five top-level folders:

```
<project_root>/
 | - analyses/     Numbered launch scripts that run code/ against data/
 | - code/         Adhoc scripts and workflows that analyses/ calls
 | - data/         Source data, structured input, and results
 | - docs/         Documentation, including this folder
 \ - scratch/      Disposable space - temp files and the local container cache
```

## `data/`

`data/` has three subfolders, reflecting how data moves through the project:

```
data/
 | - source/     Original delivered/source data (write-protected)
 | - input/      Structured input, symlinked from source/
 \ - results/    Workflow/notebook outputs
```

1. **[`data/source/`](../../data/source/README.md)** — data exactly as
   received, made write-protected once placed there.
2. **[`data/input/`](../../data/input/README.md)** — a structured,
   descriptively named view onto `source/`, built with symlinks.
3. **[`data/results/`](../../data/results/README.md)** — outputs
   published by workflows/notebooks, usually not committed to git.

On systems with a separate storage allocation from the compute allocation
(e.g., [NAISS](glossary.md#organisations) storage vs. compute projects on
[UPPMAX](glossary.md#organisations)), `data/` is typically a symlink to,
or mounted from, that storage allocation rather than living directly
inside the git repository. The logical structure above still applies
either way.

**Sensitive/personal data does not go under `data/` at all.** AI coding
tools (Copilot, this assistant, ...) read workspace file content live as
you work, regardless of `.gitignore` or git status — keeping sensitive
data out of the repository's working tree (e.g., processing it on
[Bianca](glossary.md#clusters) under its own access controls, never
inside a cloned copy of this repo) is the only reliable protection.

## Workflows vs. notebooks

Processing splits into two different kinds — pick the one that matches
the task rather than defaulting to whichever is more familiar:

- **Workflows** (Nextflow, `code/workflows/<name>/`) are for large-scale
  data processing — anything working directly with `data/source/`/`data/input/`
  at the scale of raw sequencing data, many samples, or anything that
  benefits from Nextflow's parallelism, caching, and container management.
  Launched from `analyses/<n>_<desc>/` — see [`code.md`](code.md).
- **Notebooks** (e.g. Quarto/Jupyter/Marimo) are for analysing
  already-processed, typically small, tabular data — CSVs and similar
  formats a workflow has published to `data/results/` — statistics,
  figures, and interpretation. They live in `analyses/<n>_<desc>/`
  alongside the run whose `data/results/<analysis>/` they read, not under
  `code/` — a notebook is itself an analysis run, not shared workflow
  logic.

Don't reach for a Nextflow workflow to analyse a handful of CSVs, and
don't reach for a notebook to process raw sequencing data at scale.

## How the folders work together

- **`analyses/`** contains one numbered folder per analysis run
  (`01_fetch-source-data/`, `02_workflow_dev/`, ...), each with the
  parameters and launch script for that run. See
  [`analyses.md`](analyses.md) and [`../../analyses/README.md`](../../analyses/README.md).
- **`code/`** contains the workflow(s) and adhoc scripts that `analyses/`
  launch scripts call, reading from `data/input/` and writing to
  `data/results/`. See [`code.md`](code.md).
- **`docs/`** contains project documentation: this advice folder, the
  Quarto closing report under `docs/closing_report/`, and Redmine/admin
  fields in `docs/project_info.md`.
- **`scratch/`** holds temporary/throwaway files and the local container
  image cache — nothing here is authored or precious. See
  [`environment.md`](environment.md#container-images-and-seqera-wave).

When asked to add a new analysis, add a new data source, or explain the
repository layout, use this structure rather than inventing a different
one.
