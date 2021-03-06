# NBIS project template

This is a personal template for NBIS support projects. This is an evolving method of
working as I gain experience and find better ways of working. It's by no means best
practice, but it's a method that works well for me.

* See [How I work](docs/HowIWork.Rmd) for an explanation of how I use this template.
* See [Copying the Template](docs/CopyTemplateRepo.md) for instructions to make
your own template from this one.

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
 | - README.md                                 Project details summary
 |
 | - analyses/                                 Analysis configuration files
 | - conda/                                    Shared conda environments
 | - docs/                                     Project documentation
 \ - workflow/                                 Nextflow workflow

/proj/snic20xx-yy-zz/                          (SNIC Storage Allocation)
 |
 | - nobackup/nxf-work                         Intermediate analysis files
 \ - NBIS_support_<id>_results/                Analysis results
```

## Workflow instructions

Quickstart:
```bash
cd /proj/snic20XX-YY-ZZ/NBIS_support_<id>/analyses/<date>_<analysis>/
conda activate /proj/snic20XX-YY-ZZ/NBIS_support_<id>/conda/nextflow-env
./run_nextflow.sh
```

A description of the workflow stages is provided in
the [Project Report](docs/Project_Report.md).

Workflow parameter options and outputs are detailed
in the [workflow README](workflow/README.md).
