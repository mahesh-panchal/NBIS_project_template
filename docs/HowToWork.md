# How I work

This page is a description of how I work with Nextflow, version control, and containers
in a support project.

## Contents

* What I use
* Summary of work habits
* How to use the Template repository
* Making a test data set
* Adding a new Nextflow process
* How to use containers with a process
* Troubleshooting a Nextflow process
* How to clean temporary files

## What I use

* A SNIC compute allocation on Uppmax
* A SNIC storage allocation on Uppmax (not needed for small data sets)
* Docker installed on my personal computer
* A Github account
* A conda environment with Nextflow

  ```bash
  # Make a shared conda environment for everyone in the project
  PROJECT_DIR=/proj/snic20XX-YY-ZZ/NBIS_support_<id>
  conda env create --prefix "$PROJECT_DIR/conda/nextflow-env" -f "$PROJECT_DIR/workflow/nextflow_conda-env.yml"
  ```
* An editor ( I use Atom and Vim )

## Summary of work habits

* Make a private Project repository from the Template repository on Github,
and clone it into the SNIC Compute project and then locally from the SNIC Compute allocation.
* Make a test data set from the users data, and use that to test code as I develop.
* Use git branches to add new features, and make sure the `main` branch is always stable.
* To understand what a Nextflow construct does, make an example test like in [Nextflow Patterns](http://nextflow-io.github.io/patterns/index.html). Nextflow also has a (GUI) console mode to test syntax (`nextflow console`).
* Nextflow processes are kept as modular as possible, often limiting them to a single tool. The benefits are that one can often use public images for
a process, reducing build time. Environments are small, meaning low build time, and low conflict potential. As projects are often incrementally developed, this also reduces the need to rebuild images or environments, saving time.
* Try to use existing containers (public images) when possible. When a container must be created, I use Docker to make
a local image, test, and then push it to Github packages to keep it private to the project.
* Try to use a structured work directory such as the structure below:
    ```
    /proj/snic20XX-YY-ZZ/NBIS_support_<id>/        (SNIC Compute Allocation)
     |
     | - README.md                                 Project details summary
     |
     | - analyses/                                 Analysis configuration files
     |   | - YYYY-MM-DD_workflow_dev                 Configuration to use test data
     |   \ - YYYY-MM-DD_full_data_analysis           Configuration to use all the data
     | - conda/nextflow-env                        Conda Environment containing tools and dependancies to run Nextflow
     | - docs/                                     Project documentation
     \ - workflow/                                 Nextflow workflow
         | - bin                                     Custom script folder
         | - configs                                 General workflow configuration
         \ - containers                              Custom container definitions

    /proj/snic20xx-yy-zz/                          (SNIC Storage Allocation)
     |
     | - nobackup/nxf-work                         Intermediate analysis files
     \ - NBIS_support_<id>_results/                Analysis results
    ```
* When disk space becomes an issue `nextflow clean` is used to clean up intermediate files.
* Troubleshooting processes is often done inside the nextflow work directories where the
input files and process scripts are staged.

## How to use the Template repository

1. Create a **private** Project repository using this as a template, following a naming scheme.

  ```
  SMS-<id>-<year>-<short_description>
  ```

2. Add a link to the Redmine project next to the project description (in the URL box).

3. Log in to Uppmax, and change directory into the SNIC compute allocation.

  ```bash
  cd /proj/snic20XX-YY-ZZ
  ```

4. Clone the Github repository into the SNIC compute allocation, renaming to a shorter name.

  ```bash
  git clone git@github.com:NBISweden/SMS-<id>-<year>-<short_description>.git NBIS_support_<id>
  ```

5. Clone the Uppmax repository locally.

  ```bash
  cd ~/Documents/Projects
  git clone <user>@rackham.uppmax.uu.se:/proj/snic20XX-YY-ZZ/NBIS_support_<id>
  ```

6. Update the README.md in the root of the project with project information.

## Making a test data set

A good test data set should be small, but have enough data to get to the end of the analysis.

There are various tools that let you subsample data, for example, seqtk, or samtools.

Paired end sequence subsample example:
```bash
FRACTION=0.1
SEED=100
seqtk sample -s"$SEED" "$READ1" "$FRACTION" | gzip -c > "${READ1/_R1./_R1.subsampled.}" &
seqtk sample -s"$SEED" "$READ2" "$FRACTION" | gzip -c > "${READ1/_R2./_R2.subsampled.}"
wait
```

Subsample a bam file:
```bash
FRACTION=0.10
samtools view -b -@ "${CPUS:-10}" -s "$FRACTION" -o "${PREFIX}.subsampled.subreads.bam" "${PREFIX}.subreads.bam"
```

Subsample a CSV file:
```bash
NUM_RECORDS=1000
shuf -n "$NUM_RECORDS" "${PREFIX}.csv" > "${PREFIX}.subsampled.csv"  
```

## Adding a new Nextflow process

To add the next step in the analysis, write a new process.
It's a good idea to use git branches to add new functionality to your analysis,
particularly if you're new to using the program. There is a section lower down
on trouble shooting processes if you're having trouble executing a process.

1. Make a new branch.

  ```bash
  git branch -d <add_new_process>
  ```

2. Edit the process into the workflow:

  ```groovy
  process <name> {

	  <directives>

	  input:
	    path <filename_var>

	  output:
	    path "<filename>", emit: <file_type>
	    path "*"  // Captures everything. Use when you don't know what the output is.

	  script:
	  """
	  """
  }
  ```

3. Pass the appropriate input channel(s) in the workflow block.

4. Add the container path and resources to the configs.

5. Test with the test data. The parameter config contains a directive
to resume the workflow from the last successfully executed process (`resume = true`).

6. Once it works, merge with the existing development branch or main branch.

```bash
# Update main branch
git checkout -b main
git pull
# merge updates to main into new process branch
git checkout -b <add_new_process>
git merge main
# IMPORTANT: Resolve any conflicts if main was updated
# Switch to main and merge new process
git checkout -b main
git merge <add_new_process>
# delete new process branch
git branch -d <add_new_process>
```
## How to use containers with a process

A container image path can be provided to the `process.container` directive
for a process (see [singularity_packages.config](../workflow/configs/singularity_packages.config)).
Various container images are supported. See the
[Nextflow Documentation](https://www.nextflow.io/docs/latest/singularity.html) for more details.

The [README.md](../workflow/containers/README.md) in the `workflow/containers` directory
has more information on creating custom containers.

## Troubleshooting a Nextflow process

If a process fails to run, Nextflow reports the Nextflow working directory it failed in.
Change directory to that folder:

```bash
cd /path/to/nextflow/workdir/<xx>/<hashstring>
```

In that folder there are several hidden files starting with `.`.

```
.command.begin                     Script to execute before process script
.command.err                       Error stream log
.command.log                       Combined stream log
.command.out                       Output stream log
.command.run                       Run script - runs .command.sh in the correct environment.
.command.sh                        Process script.
.exitcode
```

The `.command.sh` contains the process script.
You can modify this and execute it, but it runs in your current environment (.i.e.
outside the container). To run the modified `.command.sh` inside the container,
you should run `.command.run`, either directly on your local node ( e.g. `bash .command.run`)
or submit it to the cluster (e.g. `sbatch .command.run`). One can debug the process
script in this way, incorporate changes to the Nextflow workflow, and continue.

## How to clean temporary files

Each time you run Nextflow it's given a unique run name. This can be seen using
`nextflow log`. You can use this to clean up temporary files and folders in
the Nextflow working directory using `nextflow clean`.

Most commonly you will clean up folders before the last run.
```bash
nextflow log
nextflow clean -f -before <run_name>
```

See `nextflow help clean` for more options.
