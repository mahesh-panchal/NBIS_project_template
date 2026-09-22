# Writing a Nextflow run script, params.yml, and nextflow.config

Each numbered folder under `analyses/` (see [`analyses.md`](analyses.md))
launches one workflow under `code/workflows/` (see [`code.md`](code.md))
with three files — `run_nextflow.sh`, `params.yml`, and an optional
`nextflow.config` — plus a matching task in the root
[`pixi.toml`](../../pixi.toml).

```bash
pixi run 01-fetch-source-data
pixi run 02-workflow-dev
```

`analyses/02_workflow_dev/` (paired with `analyses/01_fetch-source-data/`
and the `code/workflows/qc/` FastQC example) is a working copy of this
shape. Add a new numbered folder per analysis, following the templates
below.

## Wiring it up as a pixi task

Give each analysis folder its own task in the root `pixi.toml`, with
`cwd` baked in, so it runs from the right place without `cd`-ing there
first or passing `--manifest-path`:

```toml
[tasks."02-workflow-dev"]
cmd = "./run_nextflow.sh"
cwd = "analyses/02_workflow_dev"
description = "Run the workflow-dev analysis (test data)"
```

Name the task after the folder, swapping `_` for `-` (`02_workflow_dev`
-> `02-workflow-dev`), and run it with:

```bash
pixi run 02-workflow-dev
```

## `run_nextflow.sh`

Detects which of pelle/bianca/dardel/arrhenius/nac it's running on (see
[`glossary.md`](glossary.md#clusters) for what each cluster is) and picks
the matching Nextflow profile. Assumes `nextflow` is already on `PATH` —
whether the pixi task above (or `pixi shell`) provides that, or it's a
`pixi global install` — not `conda`/`mamba` or manual activation (see
[`environment.md`](environment.md)). An unrecognised cluster is a hard
error rather than a silent fallback, since guessing wrong here (e.g.
picking a profile assuming Docker's available) can run against a real
allocation in the wrong way.

```bash
#! /usr/bin/env bash

# Exit on unset variables, errors, or pipe failures
set -euo pipefail

function get_cluster_name {
    if command -v sacctmgr >/dev/null 2>&1; then
        # Only return cluster names we're catering for
        sacctmgr show cluster -P -n \
        | cut -f1 -d'|' \
        | grep "pelle\|bianca\|dardel\|arrhenius\|nac"
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
# nextflow.config (see the nextflow.config template below).
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
```

For local development off-cluster, run `nextflow run` directly with
`-profile local` (see the `local` profile in the `nextflow.config`
template below) rather than through `run_nextflow.sh` — the script is
built around auto-detecting a known HPC cluster and erroring otherwise.

## `params.yml`

```yaml
## Workflow inputs
## The absolute path (full path, begins with / ) to the input data
samples: ''

## Workflow outputs
## run_nextflow.sh sets this via -output-dir to <project_root>/data/results/<analysis>
## (override here only if you need a different location)
# results: '<project_root>/data/results/<analysis>'

## Cluster project allocation - needed only when running on a Slurm cluster
# project: 'naiss2025-YY-ZZ'
```

## `nextflow.config`

An analysis folder's `nextflow.config` overrides or extends its workflow's
`code/workflows/<name>/nextflow.config` (e.g., process-specific resources
for this run only):

```groovy
process {
    withName: 'TASK' {
        cpus = 4    // Update cpus required
        time = 1.d  // Update maximum time process can run for
    }
}
```

`code/workflows/<name>/nextflow.config` itself should define one profile
per cluster, named to match `run_nextflow.sh`'s detected cluster name,
plus a `local` profile for development off-cluster (invoked directly with
`nextflow run ... -profile local` — see above; `run_nextflow.sh` itself
only ever picks a detected HPC cluster's profile):

```groovy
profiles {
    local {
        process.executor = 'local'
        docker.enabled = true
    }
}
```

Prefer pulling in
[nf-core's maintained institutional configs](https://nf-co.re/configs)
for cluster profiles over hand-writing them — they're kept up to date
with each cluster's scheduler, scratch variable, and container tooling:

```groovy
profiles {
    pelle {
        includeConfig 'https://raw.githubusercontent.com/nf-core/configs/master/conf/uppmax.config'
        params.project = ''
    }
    dardel {
        includeConfig 'https://raw.githubusercontent.com/nf-core/configs/master/conf/pdc_kth.config'
        params.project = ''
    }
    arrhenius {
        includeConfig 'https://raw.githubusercontent.com/nf-core/configs/master/conf/naiss.config'
        params.project = ''
    }
}
```

### Running on Bianca

[Bianca](glossary.md#clusters) has no general internet access, so its
profile can't `includeConfig` a live `https://...` URL the way `pelle`
does — the fetch would just hang/fail. Vendor a local copy of the
institutional config instead, and point each module's container at a
local file instead of a registry:

```groovy
profiles {
    bianca {
        includeConfig 'conf/bianca_uppmax.config'
        params.project = ''

        process {
            withName: 'FASTQC' {
                container = "${System.getenv('NXF_APPTAINER_CACHEDIR')}/fastqc-0.12.1--hdfd78af_0.sif"
            }
        }
    }
}
```

- **Institutional config**: copy the contents of
  [nf-core/configs' `uppmax.config`](https://github.com/nf-core/configs/blob/master/conf/uppmax.config)
  into `code/workflows/<name>/conf/bianca_uppmax.config` (see
  `code/workflows/qc/conf/bianca_uppmax.config` for a worked example,
  including a header recording the source commit and fetch date).
  Re-fetch and diff it against the vendored copy occasionally, from a
  machine with internet — this file won't pick up upstream fixes on its
  own the way `pelle`'s live include does.
- **Container per module**: on a machine with internet, pull the same
  image the module's `container` directive would otherwise resolve
  (check `modules/nf-core/<name>/main.nf`, or run `nextflow config
  code/workflows/<name> -profile pelle` and read the resolved
  `container` value), e.g.:
  ```bash
  apptainer pull fastqc-0.12.1--hdfd78af_0.sif \
      https://depot.galaxyproject.org/singularity/fastqc:0.12.1--hdfd78af_0
  ```
  Transfer the resulting `.sif` into Bianca's
  `scratch/apptainer-cache/` (e.g. via the
  [wharf](glossary.md#clusters) file transfer service), then add a
  `withName` override like the one above for each module a Bianca run
  needs — the filename just needs to match what you transferred.

NAC has no maintained nf-core config, so hand-write its profile (it's
still Slurm-based, but unlike the others doesn't need a project
allocation):

```groovy
profiles {
    nac {
        process {
            executor = 'slurm'
            scratch = '$TMPDIR' // check the cluster's actual scratch variable
        }
        apptainer.enabled = true
    }
}
```

## Test data

A small, fast-running test data set makes workflow development much
quicker to iterate on:

- Keep it small, but large enough to exercise a meaningful portion of the
  workflow.
- Store it under `data/source/` like any other source data (see
  [`data_management.md`](data_management.md)), and keep the script used to
  produce it so it's reproducible.
- Use it in a dedicated `analyses/02_workflow_dev/`-style folder and
  matching pixi task (see above), with `-resume` (already in the run
  script above) so re-running only executes what changed.
  `analyses/01_fetch-source-data/` + `analyses/02_workflow_dev/` are an
  example of this pattern — see
  [`../../analyses/README.md`](../../analyses/README.md).

Examples:

```bash
# Subsample paired-end Illumina reads
FRACTION=0.1
SEED=100
seqtk sample -s"$SEED" "$READ1" "$FRACTION" | gzip -c > "${READ1/_R1./_R1.subsampled.}" &
seqtk sample -s"$SEED" "$READ2" "$FRACTION" | gzip -c > "${READ1/_R2./_R2.subsampled.}"
wait

# Subsample a BAM file
FRACTION=0.10
samtools view -b -@ "${CPUS:-10}" -s "$FRACTION" -o "${PREFIX}.subsampled_${FRACTION}.subreads.bam" "${PREFIX}.subreads.bam"

# Subsample a CSV file
NUM_RECORDS=1000
shuf -n "$NUM_RECORDS" "${PREFIX}.csv" > "${PREFIX}.subsampled_${NUM_RECORDS}.csv"
```

## Troubleshooting

When a Nextflow process fails, Nextflow prints the work directory it
failed in:

```bash
cd /path/to/nextflow/workdir/<xx>/<hashstring>
```

If that's scrolled out of view, filter `nextflow log` instead of
scrolling back through it (`-l` lists the available fields to filter/show):

```bash
nextflow log -f process,workdir,status -F "status == 'FAILED'" last
```

That folder contains several hidden files:

```
.command.begin      # Script to execute before the process script
.command.err        # Error stream log
.command.log        # Combined stream log
.command.out        # Output stream log
.command.run        # Run script - runs .command.sh in the correct environment
.command.sh         # The process script
.exitcode
```

You can edit and re-run `.command.sh` directly, but that runs outside the
container. To reproduce the process's actual runtime environment, run
`.command.run` instead, either directly on a worker node
(`bash .command.run`) or submitted to the cluster (`sbatch .command.run`).
Iterate on the script in place, then fold the fix back into the workflow.

Be wary of long-running commands — swap them out for toy/test data while
debugging:

```bash
blastx ...                                      # Long run time
awk '<complex script>' <blast_output>           # Quick
```

Comment out the slow step and run the fast one with test data, or let the
slow step finish once and rely on `-resume` (already used by
`run_nextflow.sh` above) to reuse its cached output while you iterate on
what comes after it.

Once a debugging session is done, clean up redundant work directories with
`nextflow clean -f -before <run_name>` (`run_nextflow.sh` does this after
every run using `last`). Use `nextflow log` to see the date and status of
past runs, and to find a specific `<run_name>` to clean before.

To prune an analysis folder's cache/work dir outside of a run (e.g. an old
`02_workflow_dev`-style folder you're not actively iterating on), use the
generic `nextflow-clean` pixi task instead of repeating the commands above
by hand:

```bash
pixi run nextflow-clean analyses/02_workflow_dev
```

It takes the analysis folder as an argument rather than being keyed to one,
since it's meant to run periodically against whichever folder needs it.
