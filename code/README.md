# Code

This folder holds the workflow(s) and adhoc scripts that launch scripts
under `analyses/` call. It ships a minimal example — a single `FASTQC`
step run by `analyses/02_workflow_dev/` — build it up as the project's
actual workflow takes shape. Each pipeline gets its own self-contained
folder under `workflows/`, with its own modules, subworkflows, `bin/`,
and configuration — nothing is shared between workflows:

```
code/
 \ - workflows/                          One self-contained pipeline per folder
      \ - qc/                            Ships: minimal FastQC example
           | - bin/                      Adhoc/custom scripts
           | - conf/                     Vendored bianca_uppmax.config, plus unused per-arch digests from `nf-core pipelines create` (see docs/advice/code.md)
           | - configs/                  Configuration files that govern workflow execution
           | - containers/               Custom container definition files
           | - modules/nf-core/          nf-core modules (ships: fastqc)
           | - modules/local/            Hand-written modules
           | - subworkflows/local/       Hand-written subworkflows
           | - main.nf                   The primary analysis script
           \ - nextflow.config           General Nextflow configuration
```

*Kept separate from [`analyses/`](../analyses/README.md) for the same
reason in reverse — pipeline logic can be improved and reused across
runs without changing the parameters/results record of a run that
already happened.*

See [`docs/advice/code.md`](../docs/advice/code.md) for conventions on
adding workflows, modules, configuration, and containers, and
[`docs/advice/nextflow_workflow.md`](../docs/advice/nextflow_workflow.md)
for how `analyses/` launches a given workflow (run script, `params.yml`,
`nextflow.config`), including troubleshooting a failed run.
