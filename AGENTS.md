# Agent instructions

Before working in this repository, read the advice files under
[`docs/advice/`](docs/advice/). They explain how this repository is
organised and how to work in it, and take precedence over generic
assumptions about project layout.

- [`docs/advice/data_management.md`](docs/advice/data_management.md) — how
  `analyses/`, `code/`, `data/`, and `docs/` relate to each other, and how
  data flows from source to results.
- [`docs/advice/analyses.md`](docs/advice/analyses.md) — conventions for
  launch scripts and folders under `analyses/`.
- [`docs/advice/code.md`](docs/advice/code.md) — conventions for adhoc
  scripts and workflows under `code/`.
- [`docs/advice/nextflow_workflow.md`](docs/advice/nextflow_workflow.md) —
  how to write an analysis's `run_nextflow.sh`, `params.yml`, and
  `nextflow.config`, plus troubleshooting a failed run.
- [`docs/advice/environment.md`](docs/advice/environment.md) — how tools
  and environments are managed with pixi.
- [`docs/advice/how_to.md`](docs/advice/how_to.md) — starting a new
  project, working habits, and the git branching workflow.

If a task touches one of these areas and the relevant advice file doesn't
cover it, prefer asking the user over guessing a convention.

When you make (or are asked to make) a significant, non-obvious, or
hard-to-reverse decision — choosing a tool, changing the data layout,
dropping something — record it as a new file in
[`docs/decisions/`](docs/decisions/), following
[`docs/decisions/template.md`](docs/decisions/template.md). Check that
folder for existing records before proposing something it already
settled.
