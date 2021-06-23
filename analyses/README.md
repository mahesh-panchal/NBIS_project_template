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

```bash
cd /proj/snic20XX-YY-ZZ/NBIS_support_<id>/analyses/<date>_<analysis>/
conda activate /proj/snic20XX-YY-ZZ/NBIS_support_<id>/conda/nextflow-env
./run_nextflow.sh
```

If the workflow script is extended to incorporate new processes / analyses,
the workflow is rerun in the same directory to generate the next set of results.
A new analysis folder usually corresponds to the creation of a new workflow script.

`nextflow log` can be used to see the date and status of each time nextflow has been
run. Git tags can also be used to mark major stages of completion on the main branch.

### Long conda env prefix

To run nextflow, you should activate the `nextflow-env` conda environment.
```bash
conda activate /proj/snic20XX-YY-ZZ/NBIS_support_<id>/conda/nextflow-env
```
However this can change your terminal prompt (`PS1`) variable to be something very long.
You can modify the prompt to just use the environment name by using the following command.
```bash
conda config --set env_prompt '({name}) '
```
which modifies or creates a `.condarc` file for your user.
Details can be found [here](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#specifying-a-location-for-an-environment).
