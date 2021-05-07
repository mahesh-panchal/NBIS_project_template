# Workflow

Here is a folder for your workflows to manage the execution of your analyses from beginning to end.

This folder contains a skeleton for a Nextflow script and configuration, intended to run on
the UPPMAX clusters.

```
workflow/
 | - bin/                            A folder for custom workflow scripts
 | - configs/                        Configuration files that govern workflow execution
 | - containers/                     Custom container definition files
 | - main.nf                         The primary analysis script
 | - nextflow.config                 General Nextflow configuration
 \ - params.config.TEMPLATE          A Template for parameter configuration
```

There can be more than one workflow script if one desires. The Nextflow DSL2 syntax also
supports modules / subworkflows, and it can be useful to make a folder for those.  

## Customisation for Uppmax

A custom profile named `uppmax` is available to run this workflow specifically
on UPPMAX clusters. The process `executor` is `slurm` so jobs are
submitted to the Slurm Queue Manager. All jobs submitted to slurm
must have a project allocation. This is automatically added to the `clusterOptions`
in the `uppmax` profile. All Uppmax clusters have node local disk space to do
computations, and prevent heavy input/output over the network.
The path to this disk space is provided by the `$SNIC_TMP` variable, and
so is used in the `process.scratch` directive in the `uppmax` profile. Lastly
the profile enables the use of Singularity so that all processes must be
executed within Singularity containers. See [nextflow.config](nextflow.config)
for the profile specification.
