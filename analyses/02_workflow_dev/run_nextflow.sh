#! /usr/bin/env bash

# Exit on unset variables, errors, or pipe failures
set -euo pipefail

function get_cluster_name {
    if command -v sacctmgr >/dev/null 2>&1; then
        # Only return cluster names we're catering for
        sacctmgr show cluster -P -n \
        | cut -f1 -d'|' \
        | grep "pelle\|bianca\|dardel\|arrhenius\|nac" || true
    fi
}

function run_nextflow {
    PROFILE="$1"                                # Nextflow profile to use, named after the cluster
    PROJECT_ROOT="$2"                           # Path to the project root (contains pixi.toml)
    WORKDIR="${PWD/analyses/scratch}/nxf-work"  # Nextflow work directory
    RESULTS="${PWD/analyses/data/results}"      # Path to store results from Nextflow

    # Path to Nextflow script. Point this at a remote pipeline (e.g.
    # nf-core/rnaseq) instead of a local path if that's what you're running,
    # and pin it with -r <version> below.
    SCRIPT="${SCRIPT:-$PROJECT_ROOT/code/workflows/qc/main.nf}"

    # Convenience symlink from this analysis folder to its results, so
    # you don't need to know/type the data/results/<analysis> path.
    ln -sfn "$RESULTS" results

    # Run Nextflow
    nextflow run "$SCRIPT" \
        -profile "$PROFILE" \
        -work-dir "$WORKDIR" \
        -resume \
        -ansi-log false \
        -params-file params.yml \
        -output-dir "$RESULTS"
        # -r <version>  # pin this if $SCRIPT is a remote pipeline, e.g. nf-core/rnaseq

    # Clean up Nextflow cache to remove unused files
    nextflow clean -f -before last
    # Clean up empty work directories
    find "$WORKDIR" -type d -empty -delete
    # Use `nextflow log` to see the time and state of past executions.
}

# Detect cluster name ( pelle, bianca, dardel, arrhenius, nac )
cluster=$( get_cluster_name )
echo "Running on HPC=$cluster."
# Project root is two levels up from analyses/<numbered_analysis>/
project_root=$( dirname "$( dirname "$PWD" )" )

# Add any cluster-specific setup (e.g. environment modules) before calling
# run_nextflow. The profile name is expected to match the cluster name in
# nextflow.config (see docs/advice/nextflow_workflow.md).
case "$cluster" in
    dardel)
        module load PDC apptainer
        run_nextflow "$cluster" "$project_root"
        ;;
    pelle|bianca|arrhenius|nac)
        run_nextflow "$cluster" "$project_root"
        ;;
    *)
        echo "Error: unrecognised cluster '$cluster'." >&2
        exit 1
        ;;
esac
