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
