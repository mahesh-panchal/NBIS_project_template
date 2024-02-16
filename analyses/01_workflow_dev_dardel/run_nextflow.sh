#! /usr/bin/env bash

# Internal Project ID
REDMINE_ID='XXXX'
# NAISS compute allocation
COMPUTEALLOC='/proj/snicXX-YY-ZZZ'
# NAISS storage allocation
STORAGEALLOC='/proj/snicXX-YY-ZZZ'
# Nextflow work directory
WORKDIR="${STORAGEALLOC}/nobackup/nxf-work"
# Path to Nextflow script.
NXF_SCRIPT="${COMPUTEALLOC}/NBIS_support_${REDMINE_ID}/workflow/main.nf"
# Set common path to store all Singularity containers
export NXF_SINGULARITY_CACHEDIR="${STORAGEALLOC}/nobackup/singularity-cache"

# Activate shared Nextflow environment
eval "$(conda shell.bash hook)"
conda activate "${COMPUTEALLOC}/NBIS_support_${REDMINE_ID}/conda/nextflow-env"

# Launch workflow
nextflow run \
    -resume \
    -ansi-log false \
    -profile pdc_kth \
    -params-file params.yml \
    -work-dir "$WORKDIR" \
    "$NXF_SCRIPT"

# Clean up Nextflow cache to remove unused files
nextflow clean -f -before $( nextflow log -q | tail -n 1 )
# Use `nextflow log` to see the time and state of the last nextflow executions.
