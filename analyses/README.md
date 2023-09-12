# Analyses

This folder contains folders with scripts to run the project analyses. Folders within this folder
are intended to be dated and have short description of the analysis run.
A `Roadmap.md` file is used to communicate how analyses relate to each other. 
For example:
- which folders run the same workflow but with different parameters.
- which folders run subsequent analyses to another folder.
- which folders result in useful data, were abandoned/unfinished, or the resulting 
data were of little use. 
- which folders use test data and develop workflows, and which folders run analyses on the full data sets.


```
analyses
  |
  | - Roadmap.md                            (For longer projects, a roadmap of which analysis lead to what)
  |
  | - YYYY-MM-DD_dev_<desc>/                (Analysis folder used to develop workflow with test data)
  |     | - params.yml                      (Parameter file for test data)
  |     | - nextflow.config                 (Additional Nextflow configuration, such as workdir)
  |     \ - run_nextflow.sh                 (Shell script to call nextflow with correct parameters)
  |
  \ - YYYY-MM-DD_<short_desc>/              (Usually the workflow that runs all the data)
        | - params.yml                      (Parameter config for all data)
        | - nextflow.config
        \ - run_nextflow.sh
```

Analyses often follow this recipe, making the analyses easy to run, recreate, and reference.

```bash
cd /proj/snic20XX-YY-ZZ/NBIS_support_<id>/analyses/<date>_<analysis>/
conda activate /proj/snic20XX-YY-ZZ/NBIS_support_<id>/conda/nextflow-env
./run_nextflow.sh
```

When a workflow script is extended to incorporate new processes / tools,
the workflow is resumed in the same analysis folder it was originally deployed to generate the next set of results.
A new analysis folder often corresponds the running of a different workflow script or an alternate parameter input to investigate.

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
