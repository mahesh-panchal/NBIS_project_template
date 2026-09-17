# Code

`code/` holds the workflow(s) and adhoc scripts that `analyses/` launch
scripts call. It is not run directly — `analyses/<n>_<desc>/run_nextflow.sh`
invokes it with the parameters for that particular run.

This folder ships with just a README — build up the layout below as the
project's workflow takes shape, rather than assuming it already exists:

```
code/
 | - bin/            Adhoc/custom scripts (automatically on PATH for Nextflow processes)
 | - configs/         Workflow configuration (compute resources, tool-specific config, e.g. MultiQC)
 | - containers/      Custom container image definitions (Dockerfile per tool)
 | - modules/         Nextflow process definitions
 | - notebooks/       Notebooks analysing already-processed data (e.g. Quarto/Jupyter)
 | - main.nf          The primary workflow script
 \ - nextflow.config  General Nextflow configuration (profiles, defaults)
```

`main.nf`/`modules/` (the Nextflow workflow) and `notebooks/` serve
different jobs — see [`data_management.md`](data_management.md#workflows-vs-notebooks)
for which one a task calls for.

## Conventions

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

When asked to add a new processing step, add a module under `modules/`,
wire it into `main.nf`, and add its resource/tool configuration under
`configs/`, following this shape:

```groovy
// modules/<tool>.nf
process <UPPERCASE_NAME> {

    input:
    path <filename_var>

    // directives
    <directives>
    conda "<channel>::<software>=<version>"
    container "<software>:<version+build>"

    script:
    """
    command --opts $var
    """

    output:
    path "<filename>", emit: <file_type>
    path "*"  // Captures everything. Use when you don't know what the output is.

}
```

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
