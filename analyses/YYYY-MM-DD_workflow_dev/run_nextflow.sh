#! /usr/bin/env bash

NXF_SCRIPT=/proj/snic20XX-YY-ZZ/NBIS_support_<id>/workflow/main.nf
NXF_VER=21.04.0 nextflow run -c params.config -profile uppmax "$NXF_SCRIPT"
# Use `nextflow log` to see the time and state of the last nextflow executions. 
