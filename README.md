# NBIS project template

This is a personal template for National Bioinformatics Infrastructure Sweden (NBIS) 
support projects. It is an evolving method of working as I gain experience and find 
better ways of working. See [`docs/advice/how_to.md`](docs/advice/how_to.md)
for how to use this template.

# <Title>

Quickstart:
```bash
pixi run 01-fetch-source-data
pixi run 02-workflow-dev
```

That's the shipped working example (fetches a tiny public test dataset,
runs FastQC on it) — replace it with the project's actual data/workflow
as it takes shape. Each folder under `analyses/` has a matching pixi task
(`cwd` baked in), so running one doesn't require `cd`-ing there or
activating anything manually. See
[`docs/advice/nextflow_workflow.md`](docs/advice/nextflow_workflow.md)
for how to write a `run_nextflow.sh`, `params.yml`, `nextflow.config`,
and the matching pixi task.

## Location

- HPC compute allocation: `/proj/naiss20XX-YY-ZZ/<project_root>`
- HPC storage allocation (if separate): `/proj/naiss20xx-yy-zz/`

Project and Redmine details are in
[`docs/project_info.md`](docs/project_info.md). A description of the
workflow stages is in the
[closing report](docs/closing_report/closing_report.qmd).

## Directories

```
<project_root>/
 |
 | - README.md                                 Project details summary
 | - AGENTS.md                                 Pointers for AI agents (see docs/advice/)
 | - pixi.toml                                 Tool dependencies and tasks (pixi)
 |
 | - analyses/                                 Numbered analysis launch scripts
 | - code/                                     Adhoc scripts and workflows analyses/ calls
 | - data/                                     Source data, structured input, and results
 | - docs/                                     Project documentation (incl. docs/advice/)
 \ - scratch/                                  Disposable space - temp files, local container cache
```

On HPC systems with a separate storage allocation from the compute
allocation (e.g., NAISS storage vs. compute projects on UPPMAX), `data/`
and Nextflow's work directory typically live on the storage allocation
instead of inside this repository. See
[docs/advice/data_management.md](docs/advice/data_management.md) for details.

See [`docs/advice/`](docs/advice/) for how this repository is organised
and how to work in it.
