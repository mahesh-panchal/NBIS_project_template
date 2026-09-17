# Data management

This repository is organised around four top-level folders:

```
<project_root>/
 | - analyses/     Numbered launch scripts that run code/ against data/
 | - code/         Adhoc scripts and workflows that analyses/ calls
 | - data/         Source data, structured input, and results
 \ - docs/         Documentation, including this folder
```

## `data/`

`data/` has three subfolders, reflecting how data moves through the project:

```
data/
 | - source/     Original delivered/source data (write-protected)
 | - input/      Structured input, symlinked from source/
 \ - results/    Workflow/notebook outputs
```

1. **`data/source/`** holds data exactly as received (e.g., a sequencing
   centre delivery, a dataset from a collaborator). Once placed here, it is
   made write-protected (`chmod -R a-w`) so nothing downstream can
   accidentally modify or delete it.
2. **`data/input/`** is a structured, descriptively named view onto
   `source/`, built with symlinks rather than copies. This is where
   reorganising happens — renaming, grouping by sample, building a
   samplesheet — without ever touching the original files.
3. **`data/results/`** holds outputs published by workflows or notebooks
   launched from `analyses/`. These are generated, not authored, so they
   are usually not committed to git; they can always be reproduced by
   re-running the analysis that made them.

On systems with a separate storage allocation from the compute allocation
(e.g., NAISS storage vs. compute projects on UPPMAX), `data/` is typically
a symlink to, or mounted from, that storage allocation rather than living
directly inside the git repository. The logical structure above still
applies either way.

## Workflows vs. notebooks

`code/` can hold two different kinds of processing — pick the one that
matches the task rather than defaulting to whichever is more familiar:

- **Workflows** (Nextflow, `code/main.nf` + `modules/`) are for
  large-scale data processing — anything working directly with
  `data/source/`/`data/input/` at the scale of raw sequencing data, many
  samples, or anything that benefits from Nextflow's parallelism, caching,
  and container management.
- **Notebooks** (e.g. Quarto/Jupyter, `code/notebooks/`) are for analysing
  already-processed, typically small, tabular data — CSVs and similar
  formats a workflow has published to `data/results/` — statistics,
  figures, and interpretation.

Don't reach for a Nextflow workflow to analyse a handful of CSVs, and
don't reach for a notebook to process raw sequencing data at scale.

## How the folders work together

- **`analyses/`** contains one numbered folder per analysis run
  (`01_workflow_dev/`, `02_full_data/`, ...), each with the parameters and
  launch script for that run. See
  [`analyses.md`](analyses.md) and [`../../analyses/README.md`](../../analyses/README.md).
- **`code/`** contains the workflow(s) and adhoc scripts that `analyses/`
  launch scripts call, reading from `data/input/` and writing to
  `data/results/`. See [`code.md`](code.md).
- **`docs/`** contains project documentation, including this advice folder
  and the Quarto closing report under `docs/closing_report/`.

When asked to add a new analysis, add a new data source, or explain the
repository layout, use this structure rather than inventing a different
one.
