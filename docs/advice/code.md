# Code

`code/` holds the workflow(s) and adhoc scripts that `analyses/` launch
scripts call. It is not run directly — `analyses/<n>_<desc>/run_nextflow.sh`
invokes it with the parameters for that particular run.

This folder ships with just a README — build up the layout below as the
project's workflow takes shape, rather than assuming it already exists:

```
code/
 | - bin/                 Adhoc/custom scripts (automatically on PATH for Nextflow processes)
 | - configs/              Workflow configuration (compute resources, tool-specific config, e.g. MultiQC)
 | - containers/           Custom container image definitions (Dockerfile per tool)
 | - modules/nf-core/      Modules installed with `nf-core modules install <name>`
 | - modules/local/        Hand-written modules (no nf-core equivalent exists)
 | - notebooks/            Notebooks analysing already-processed data (e.g. Quarto/Jupyter/Marimo)
 | - main.nf               The primary workflow script
 \ - nextflow.config       General Nextflow configuration (profiles, defaults)
```

`main.nf`/`modules/` (the Nextflow workflow) and `notebooks/` serve
different jobs — see [`data_management.md`](data_management.md#workflows-vs-notebooks)
for which one a task calls for.

## Conventions

- Before writing a process, check whether an
  [nf-core module](https://nf-co.re/modules/) already does it —
  `nf-core modules list remote <name>` — and install it
  (`nf-core modules install <name>`) rather than reimplementing it. Only
  write a local module, under `modules/local/`, when no nf-core module
  covers the tool.
- Keep Nextflow processes modular, ideally one tool per process, so public
  container images can be reused directly. Prefer an existing public image
  (Biocontainers, Rocker, ...), then building one with Seqera Wave from a
  conda/pip spec, before hand-writing a custom `Dockerfile` under
  `containers/<tool_name>/` — see [`environment.md`](environment.md#container-images-and-seqera-wave).
- Analysis-specific parameters (e.g., input paths, per-run overrides)
  belong in the relevant `analyses/<n>_<desc>/` folder, not here — this
  folder holds the workflow logic and its defaults, not one run's inputs.
- Adhoc, one-off scripts that aren't formal Nextflow processes still live
  under `bin/`, alongside process scripts — keep them there rather than
  scattering scripts elsewhere in the repo.
- Notebooks under `notebooks/` read from `data/results/` (a workflow's
  published output), not from `data/source/`/`data/input/` directly.
- A notebook needing its own package set gets its own pixi feature and
  environment rather than a separate environment file — see
  [`environment.md`](environment.md#per-notebook-environments).
- Lint before committing: `nextflow lint -exclude .pixi -exclude results .`
  (also available as an IDE extension).
- A process that fetches a shared, stable file (e.g. a reference database)
  should use `storeDir` so independent analysis runs reuse the same
  download instead of refetching it:

  ```groovy
  process FETCH_DB {
      storeDir "${params.db_cachedir}/my_db"

      script:
      """
      fetch-my-db.sh
      """
  }
  ```

### Installing an nf-core module

```bash
nf-core modules install <name>
```

This installs `modules/nf-core/<name>/` (`main.nf`, `environment.yml`,
`meta.yml`, `tests/`) and tracks it in `modules.json`, so it can later be
updated (`nf-core modules update <name>`) or patched
(`nf-core modules patch <name>`) if you need a small local change without
losing the ability to update it. See the
[nf-core modules docs](https://nf-co.re/docs/nf-core-tools/pipelines/modules)
for the full workflow.

### Writing a local module

When asked to add a new processing step with no nf-core equivalent, add a
module under `modules/local/`, wire it into `main.nf`, and add its
resource/tool configuration under `configs/`, following this shape:

```groovy
// modules/local/<tool>.nf
process <UPPERCASE_NAME> {

    input:
    path <filename_var>

    // directives
    <directives>
    conda "<channel>::<software>=<version>"
    container "<software>:<version+build>"

    script:
    """
    echo "[TASK] Starting <tool> for ${task.tag}" >&2
    command --opts $var 2> >(tee -a <tool>.log >&2)
    """

    output:
    path "<filename>", emit: <file_type>
    path "*"  // Captures everything. Use when you don't know what the output is.

}
```

Write to standard error for progress/log messages (`>&2`), and `tee` a
tool's own stderr to a log file so it survives even if the job's
allocation is relinquished right after a failure.

Wire the module into `main.nf`'s `workflow` block, passing whatever
channel shape the process needs — write toy examples first (e.g. via
`nextflow console`, or see
[Nextflow Patterns](http://nextflow-io.github.io/patterns/index.html)) if
it's not obvious what a channel operator produces:

```groovy
workflow {
    Channel.fromFilePairs( params.reads, checkIfExists: true )
        .set { input_ch }

    FASTQC( input_ch )
    FASTP( input_ch )
    ASSEMBLE( FASTP.out.trimmed_reads )
}
```

Add the process's resource requirements to `configs/compute_resources.config`:

```groovy
process {
    withName: 'FASTQC' {
        cpus = 4
        time = '1h'
    }
}
```

If a step is one of many short, fast tasks, batch them into a single
process (e.g. with `xargs -P`) rather than submitting hundreds of
individually-scheduled jobs — each job submission has real scheduling
overhead on a shared cluster.

## Testing

Test modules and workflows with
[nf-test](https://www.nf-test.com/), the nf-core-standard testing
framework — `nf-test generate process modules/local/<tool>.nf` scaffolds
a test, which snapshots a process/workflow's output so a future change
that alters it is caught as a diff to review, not silently passed.
`nf-core modules install` already ships nf-test scaffolding for installed
modules under their `tests/` folder.
