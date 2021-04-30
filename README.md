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

6. Update the README.md (below) with project information.

7. Continue from [How I work](HowToWork.md)

# <Title>

* NBIS Project ID: <id>
* NBIS experts: Mahesh Binzer-Panchal (mahesh.binzer-panchal@nbis.se)
* Request by: <name> (<email>)
* Principal Investigator: <name> (<email>)

Expert Affiliation:
```
Mahesh Binzer-Panchal
Department of Medical Biochemistry and Microbiology,
National Bioinformatics Infrastructure Sweden (NBIS),
Science for Life Laboratory,
Uppsala Universitet,
Uppsala,
Sweden
ORCID = https://orcid.org/0000-0003-1675-0677
```

## NBIS Support Request.

NBIS Project support request:

> <Project description goes here>

NBIS Agreement: ( XX hrs)

> - <Agreed outcome 1>
> - <Agreed outcome 2>

## Directories

```
/proj/snic20XX-YY-ZZ/NBIS_support_<id>/        (SNIC Compute Allocation)
 |
 | - README.md                                 Project details
 |
 | - analyses/                                 Analysis configuration files
 | - docs/                                     Project documentation
 \ - workflow/                                 Nextflow workflow

/proj/snic20xx-yy-zz/                          (SNIC Storage Allocation)
 |
 | - nobackup/nxf-work                         Intermediate analysis files
 \ - results/                                  Analysis results
```

## Workflow instructions

Quickstart:
```bash
cd /proj/snic20XX-YY-ZZ/NBIS_support_<id>/analyses/<date>_<analysis>/
module load bioinfo-tools Nextflow
./run_nextflow.sh
```
