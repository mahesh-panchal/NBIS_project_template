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
- [`docs/advice/writing_style.md`](docs/advice/writing_style.md) — how to
  write code comments, docs, commit messages, and review comments in this
  repository.
- [`docs/advice/glossary.md`](docs/advice/glossary.md) — NBIS/NAISS
  organisations, clusters, and administrative terms used elsewhere in
  these docs.

If a task touches one of these areas and the relevant advice file doesn't
cover it, prefer asking the user over guessing a convention.

Sensitive/personal data (e.g., human sequencing data on Bianca) must
never be placed anywhere in this repository's working tree, including
`data/`, `scratch/`, or your own temporary files — this and other AI
tools (Copilot, etc.) read workspace file content live as you work,
regardless of `.gitignore` or whether anything gets committed. If asked
to work with such data from inside this workspace, say so and ask where
it actually lives instead of proceeding. See
[`docs/advice/data_management.md`](docs/advice/data_management.md).

Use [`scratch/`](scratch/README.md) for your own temporary files and
testing — throwaway scripts, downloads, intermediate outputs you're
checking before deciding where (if anywhere) they belong — instead of
`/tmp` or scattering them elsewhere in the repo. Nothing there is tracked
except its README, so it's always safe to leave things behind or clean
up.

When you make (or are asked to make) a significant, non-obvious, or
hard-to-reverse decision — choosing a tool, changing the data layout,
dropping something — record it as a new file in
[`docs/decisions/`](docs/decisions/), following
[`docs/decisions/template.md`](docs/decisions/template.md). Check that
folder for existing records before proposing something it already
settled.
