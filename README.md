# NBIS project template

This is a personal template for National Bioinformatics Infrastructure Sweden (NBIS) 
support projects. It is an evolving method of working as I gain experience and find 
better ways of working. See [`docs/advice/how_to.md`](docs/advice/how_to.md)
for how to use this template.

# <Title>

* NBIS Project ID: <id>
* NBIS experts: Mahesh Binzer-Panchal (mahesh.binzer-panchal@nbis.se)
* Request by: <name> (<email>)
* Principal Investigator: <name> (<email>)

Expert Affiliation:
```
Mahesh Binzer-Panchal
Department of Medical Biochemistry and Microbiology,
National Bioinformatics Infrastructure Sweden (NBIS),
Science for Life Laboratory,
Uppsala Universitet,
Uppsala,
Sweden
ORCID = https://orcid.org/0000-0003-1675-0677
```

## NBIS Support Request.

NBIS Project support request:

> <Project description goes here>

NBIS Agreement: ( XX hrs)

> - <Agreed outcome 1>
> - <Agreed outcome 2>

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

## Workflow instructions

Quickstart:
```bash
pixi run <numbered-analysis-task>
```

Each folder under `analyses/` has a matching pixi task (`cwd` baked in),
so this doesn't require `cd`-ing there or activating anything manually.

A description of the workflow stages is provided in
the [closing report](docs/closing_report/closing_report.qmd).

See [`docs/advice/`](docs/advice/) for how this repository is organised
and how to work in it, including how to write a `run_nextflow.sh`,
`params.yml`, `nextflow.config`, and the matching pixi task
([`docs/advice/nextflow_workflow.md`](docs/advice/nextflow_workflow.md)).
