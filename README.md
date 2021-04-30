# NBIS project template

This is a personal template for NBIS support projects. This is an evolving method of
working as I gain experience and find better ways of working. It's by no means best
practice, but it's a method that works well for me.

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

## How to use this repository

1. Create a repository using this as a template, following a naming scheme.

  ```
  SMS-<id>-<short_description>
  ```

2. Log in to Uppmax, and change directory into the SNIC compute allocation.

  ```bash
  cd /proj/snic20XX-YY-ZZ
  ```

3. Clone the Github repository into the project directory, renaming to a shorter name.

  ```bash
  git clone git@github.com:NBISweden/SMS-<id>-<short_description>.git NBIS_support_<id>
  ```

4. Clone the repository on Uppmax locally.

  ```bash
  cd ~/Documents/Projects
  git clone <user>@rackham.uppmax.uu.se:/proj/snic20XX-YY-ZZ/NBIS_support_<id>
  ```

5. Update the README.md with project information.
