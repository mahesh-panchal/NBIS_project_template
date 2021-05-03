# How I work

This page is a description of how I work with Nextflow, version control, and containers
in a support project.

## Contents

* What I use
* Summary of work habits
* How to use the template repository

## What I use

* A SNIC compute allocation on Uppmax
* A SNIC storage allocation on Uppmax (not needed for small data sets)
* Docker installed on my personal computer
* A Github account
* A conda environment with Nextflow

  ```bash
  conda install -n nextflow-env nextflow
  ```
* An editor ( I use Atom and Vim )

## Summary of work habits

* Make a private Project repository from the Template repository on Github,
and clone it into the SNIC Compute project and then locally from the SNIC Compute allocation.
* Make a test data set from the users data, and use that to test code as I develop.
* Use git branches to add new features, and make sure the `main` branch is always stable.
* To understand what a Nextflow construct does, make an example test like in [Nextflow Patterns](http://nextflow-io.github.io/patterns/index.html). Nextflow also has a (GUI) console mode to test syntax (`nextflow console`).
* Nextflow processes are kept as modular as possible, often limiting them to a single tool.
* Try to use existing containers when possible. When a container must be created, I use Docker to make
a local image, test, and then push it to Github packages.

## How to use the template repository

1. Create a **private** repository using this as a template, following a naming scheme.

  ```
  SMS-<id>-<short_description>
  ```

2. Add a link to the Redmine project next to the project description (in the URL box).

3. Log in to Uppmax, and change directory into the SNIC compute allocation.

  ```bash
  cd /proj/snic20XX-YY-ZZ
  ```

4. Clone the Github repository into the SNIC compute allocation, renaming to a shorter name.

  ```bash
  git clone git@github.com:NBISweden/SMS-<id>-<short_description>.git NBIS_support_<id>
  ```

5. Clone the Uppmax repository locally.

  ```bash
  cd ~/Documents/Projects
  git clone <user>@rackham.uppmax.uu.se:/proj/snic20XX-YY-ZZ/NBIS_support_<id>
  ```

6. Update the README.md in the root of the project with project information.

## Adding a new Nextflow process

1. Make a new branch.

  ```bash
  git branch -d <add_process>
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

3. Add the container path and resources to the configs.

4. Test with the test data.
