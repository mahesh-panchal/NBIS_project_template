---
title: Project report
author: Mahesh Binzer-Panchal
date: DATE
bibliography: citations.bib
---

#  PROJECT TITLE

* Redmine ID: REDMINE_ID
* NBIS experts: Mahesh Binzer-Panchal (mahesh.binzer-panchal@nbis.se)
* Request by: PROJECT_CONTACT_NAME ( EMAIL_ADDRESS )
* Principal Investigator: PROJECT_PI_NAME ( EMAIL_ADDRESS )
* Organization: PROJECT_AFFILIATION

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

Redmine support request:

> REDMINE DESCRIPTION

NBIS Agreement:

> - AGREEMENT TERMS

## Project information

### Project allocation

* snicXXXX-YY-ZZ (SNIC Compute allocation, Rackham)

### Data responsibility

* **NBIS & Uppnex:**  Unfortunately, we do not have resources to keep any files associated with the support request. We suggest that you safely store the results delivered by us. In addition, we ask that you remove the files from UPPMAX/UPPNEX after analysis is completed. The main storage at UPPNEX is optimized for high-speed and parallel access, which makes it expensive and not the right place for long time archiving.
* **Sensitive data:** Please note that special considerations may apply to the human-derived sensitive personal data. These should be handled according to specific laws and regulations as outlined e.g. http://nbis.se/support/human-data.html.
* **Long-term backup:** The responsibility for data archiving lies with universities and we recommend asking your local IT for support with long-term data archiving. Also a newly established Data Office (https://www.scilifelab.se/data/) at SciLifeLab may be of help to discuss other options.

### Acknowledgements

If you are presenting the results in a paper, at a workshop or conference, we kindly ask you to acknowledge us.

* **NBIS:** Staff are encouraged to be co-authors when this is merited in accordance to the ethical recommendations for authorship, e.g. ICMJE recommendations. If applicable, please include Name, Surname, National Bioinformatics Infrastructure Sweden, Science for Life Laboratory, Further Affliations, as co-author. In other cases, NBIS would be grateful if support by us is acknowledged in publications according to this example: "Support by NBIS (National Bioinformatics Infrastructure Sweden) is gratefully acknowledged."
* **UPPMAX:** If your project has used HPC resources we kindly asks you to acknowledge UPPMAX and SNIC. If applicable, please add: "The computations were performed on resources provided by SNIC through Uppsala Multidisciplinary Center for Advanced Computational Science (UPPMAX) under Project SNIC XXXX/Y-ZZZ."
* **NGI:** In publications based on data from NGI Sweden, the authors must acknowledge SciLifeLab, NGI and UPPMAX: "The authors would like to acknowledge support from Science for Life Laboratory, the National Genomics Infrastructure, NGI, and Uppmax for providing assistance in massive parallel sequencing and computational infrastructure."

## Data

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

### Input Data

Description:
* Input data type:
    * Path to data: `/path/to/data`

## Methods

A workflow has been written in Nextflow to manage the data analysis steps.
Nextflow is used to run the tasks on the HPC cluster Rackham.
The workflow analyses can be run on UPPMAX HPC clusters within `screen` sessions
as follows:

```bash
cd /proj/snic20XX-YY-ZZ/NBIS_support_<id>/analyses/<date>_<analysis>/
conda activate /proj/snic20XX-YY-ZZ/NBIS_support_<id>/conda/nextflow-env
./run_nextflow.sh
```

The workflow runs the following data processing and analyses steps for each sample.

- FastQC (Illumina Read QC)
- Fastp (Illumina Read trimming and QC)
- MultiQC (Log collection processing and reporting)

### Software

The following tools were used in the current analysis:

| Tool        | Version    | Description | Citation   |
| ----------- | ---------- | ------------------------------------- | ---------- |
| Fastp |  0.20.1 | Trimming and merging | [@chen2018fastp] |
| FastQC | 0.11.9 | Illumina Read QC | [@andrews2010fastqc] |
| MultiQC | 1.10.1 | Reporting summary tool | [@ewels2016multiqc] |

All the tools used in this project are available as Singularity container
images (`*.{img,sif}`) in the folder
`/proj/snic20xx-yy-zz/nobackup/nxf-work/singularity`. The container
image path and version these Singularity images were made from
can be found in the file
`/proj/snic20XX-YY-ZZ/NBIS_support_<id>/workflow/configs/singularity_packages.config`.

Images hosted on `docker.pkg.github.com` are initially private. These images should be
copied to a public respository on publication.
Request access to the code repository from the NBIS expert to
have access to the Docker container images. All other Docker images
are hosted on public registries.

### Reproducibility

Several tools have been used to aid the reproducibility of this analysis.

- Version Control: The scripts, documentation, configuration parameters,
and container image definitions for this analysis have been managed
using the version control system `git`. These files are also hosted
privately on the `NBISweden/SMS-<id>-<description>` Github repository. Please
ask the NBIS expert to add your Github user for access if you would like
to make a copy of this repository and continue making changes to it.
- Nextflow workflow management system: Nextflow is used to automate
the running of various tools for data processing and analysis. It
provides a complete computational description of how the analysis
was run, from beginning to end. A configuration profile
`uppmax` was created to utilise the `singularity` container technology
and `slurm` queueing system available on the UPPMAX cluster Rackham.
- Singularity container technology: Containers provide a software
package that include everything needed to run an application: code,
runtime, system tools, system libraries, and settings. Containerised
software will run the same regardless of the infrastructure, and
isolate its software from the computational environment to ensure
it works uniformly.

## Results

## Recommendations and concluding remarks

* RECOMMENDATIONS

## References
