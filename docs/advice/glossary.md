# Glossary

Terms used throughout this repository that aren't explained where they
first appear — mostly Swedish/NBIS-specific organisations, clusters, and
administrative process. This template is explicitly built around NBIS's
own conventions (see [`how_to.md`](how_to.md)), so these terms are
intentional, not oversights — swap in your own organisation's equivalents
if adapting this template elsewhere.

## Organisations

- **NBIS** — National Bioinformatics Infrastructure Sweden. Provides
  bioinformatics support to Swedish life science researchers; this
  template is built around how an NBIS expert runs a support project.
- **SciLifeLab** — Science for Life Laboratory, the Swedish national
  research infrastructure centre NBIS operates under.
- **NAISS** — National Academic Infrastructure for Supercomputing in
  Sweden. Allocates the compute/storage projects (`naiss20XX-Y-ZZZ`
  allocation IDs) referenced throughout `docs/advice/` and the closing
  report.
- **UPPMAX** — Uppsala Multidisciplinary Center for Advanced
  Computational Science. Operates HPC clusters (Pelle, Bianca) under
  NAISS allocations.
- **Uppnex** — The storage system historically associated with UPPMAX;
  still referenced in some data-responsibility boilerplate.
- **NGI** — National Genomics Infrastructure. Provides sequencing
  services; acknowledged separately from NBIS/UPPMAX when a project uses
  NGI-generated data.

## Clusters

See [`nextflow_workflow.md`](nextflow_workflow.md) for how each maps to
a Nextflow profile.

- **Pelle** — UPPMAX's general-purpose compute cluster (Rackham's
  successor).
- **Bianca** — UPPMAX's cluster for sensitive/personal data, with its
  own access controls and no general internet access. See the
  sensitive-data note in [`data_management.md`](data_management.md).
- **Dardel** — PDC's (KTH Royal Institute of Technology) HPC cluster.
- **Arrhenius** — a NAISS-allocated HPC cluster, covered by nf-core's
  generic `naiss` institutional config (no dedicated one like `uppmax`
  or `pdc_kth`).
- **NAC** — National Academic Compute, a Slurm-based HPC cluster with no
  maintained nf-core config at all
  (see [`nextflow_workflow.md`](nextflow_workflow.md)).

## Administrative

- **Redmine** — NBIS's project/issue tracker. A support request's
  Redmine ID, requester, and PI are recorded in
  [`../project_info.md`](../project_info.md).
- **ORCID** — a persistent researcher identifier
  (`https://orcid.org/...`), used in author metadata.
- **ICMJE** — International Committee of Medical Journal Editors;
  their authorship criteria are referenced in the closing report's
  acknowledgements section.

## Tools

Covered in depth elsewhere, listed here only as quick pointers:

- **nf-core** — a community collection of standardised Nextflow modules
  and pipelines. See [`code.md`](code.md).
- **Wave** / **Seqera Containers** — a service that builds container
  images from a conda/pip spec on demand. See
  [`environment.md`](environment.md#container-images-and-seqera-wave).
- **Apptainer** — the maintained successor to Singularity; this
  template's container runtime on HPC. See
  [`environment.md`](environment.md#container-images-and-seqera-wave).
- **GHCR** — GitHub Container Registry (`ghcr.io`), used for custom
  container images. See
  [`environment.md`](environment.md#publishing-a-custom-container).
- **pixi** — the tool/task manager this template is built on. See
  [`environment.md`](environment.md).
- **Slurm** / **`sbatch`** — the job scheduler most of these clusters use;
  `sbatch` submits a batch job to it. See
  [`nextflow_workflow.md`](nextflow_workflow.md) and
  [`analyses.md`](analyses.md).
