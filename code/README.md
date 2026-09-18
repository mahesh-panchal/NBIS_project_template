# Code

This folder holds the workflow(s) and adhoc scripts that launch scripts
under `analyses/` call. It ships a minimal, real, working example — a
single `FASTQC` step run by `analyses/02_workflow_dev/` — build it up as
the project's actual workflow takes shape:

```
code/
 | - bin/                            Adhoc/custom scripts
 | - configs/                        Configuration files that govern workflow execution
 | - containers/                     Custom container definition files
 | - modules/nf-core/                nf-core modules (ships: fastqc)
 | - modules/local/                  Hand-written modules
 | - notebooks/                      Notebooks analysing already-processed data
 | - main.nf                         The primary analysis script
 \ - nextflow.config                 General Nextflow configuration
```

See [`docs/advice/code.md`](../docs/advice/code.md) for conventions on
adding modules, configuration, and containers, and
[`docs/advice/nextflow_workflow.md`](../docs/advice/nextflow_workflow.md)
for how `analyses/` launches this workflow (run script, `params.yml`,
`nextflow.config`), including troubleshooting a failed run.
