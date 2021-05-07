# Analyses

Use this folder to keep your workflow configurations. I date analysis folders to
know when an analysis was started. An analysis folder usually looks like this.
There is a folder for the testing parameters for workflow development, and then
usually one folder that runs the workflow on the full data set.

```
analyses
  |
  | - YYYY-MM-DD_workflow_dev               (Analysis folder with testing parameters)
  |     | - params.config                   (Parameter config file for test data)
  |     \ - run_nextflow.sh                 (Shell script to call nextflow with correct parameters)
  |
  \ - YYYY-MM-DD_<short_desc>               (Usually the workflow that runs all the data)
        | - params.config                   (Parameter config for all data)
        \ - run_nextflow.sh
```

This makes the analyses easy to run, recreate, and revisit to know settings used.

```
cd /proj/snic20XX-YY-ZZ/NBIS_support_<id>/analyses/<date>_<analysis>/
module load bioinfo-tools Nextflow
./run_nextflow.sh
```

If the workflow script is extended to incorporate new processes / analyses,
the workflow is rerun in the same directory to generate the next set of results.

`nextflow log` can be used to see the date and status of each time nextflow has been
run.
