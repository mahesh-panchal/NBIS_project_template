#! /usr/bin/env bash

PROFILE=${PROFILE:-uppmax}
SNIC_COMPUTE=${SNIC_COMPUTE:-/proj/snic20XX-YY-ZZ/}
SNIC_STORAGE=${SNIC_STORAGE:-/proj/snic20xx-yy-zz/}
REDMINE_ID=${REDMINE_ID:-XXXX}
NXF_SCRIPT=${NXF_SCRIPT:-${SNIC_COMPUTE}/NBIS_support_${REDMINE_ID}/workflow/main.nf}
WORKDIR=${WORKDIR:-$SNIC_STORAGE/nobackup/nxf-work}

nextflow run -resume \
    -params-file params.yml \
    -profile "$PROFILE" \
    -work-dir "$WORKDIR" \
    "$NXF_SCRIPT"

# Use `nextflow log` to see the time and state of the last nextflow executions.
