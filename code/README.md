# Code

This folder holds the workflow(s) and adhoc scripts that launch scripts
under `analyses/` call. It ships empty — build it up as the project's
workflow takes shape:

```
code/
 | - bin/                            Adhoc/custom scripts
 | - configs/                        Configuration files that govern workflow execution
 | - containers/                     Custom container definition files
 | - modules/                        Process definitions
 | - notebooks/                      Notebooks analysing already-processed data
 | - main.nf                         The primary analysis script
 \ - nextflow.config                 General Nextflow configuration
```

See [`docs/advice/code.md`](../docs/advice/code.md) for conventions on
adding modules, configuration, and containers, and
[`docs/advice/nextflow_workflow.md`](../docs/advice/nextflow_workflow.md)
for how `analyses/` launches this workflow (run script, `params.yml`,
`nextflow.config`), including troubleshooting a failed run.
