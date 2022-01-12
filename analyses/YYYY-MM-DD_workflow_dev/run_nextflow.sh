#! /usr/bin/env bash

PROFILE=${PROFILE:-uppmax}

NXF_SCRIPT="/proj/snic20XX-YY-ZZ/NBIS_support_<id>/workflow/main.nf"
nextflow run -params-file params.yml -profile "$PROFILE" "$NXF_SCRIPT"

# Use `nextflow log` to see the time and state of the last nextflow executions.
