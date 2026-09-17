# Scratch

Disposable space: temporary files, one-off tests, downloads you're
poking at before deciding where (if anywhere) they belong. This is also
where an AI agent working in this repo should do its own testing and
scratch work (see [`AGENTS.md`](../AGENTS.md)), rather than `/tmp` or
elsewhere in the repo. Everything here except this file is gitignored
and safe to delete at any time — nothing here should be the only copy of
anything you care about.

This is also where the local container image cache lives by default
(`scratch/singularity-cache/`, set via `NXF_SINGULARITY_CACHEDIR` in the
root [`pixi.toml`](../pixi.toml)) — slow to rebuild, but not precious;
losing it just means Nextflow re-pulls/re-converts images next run. On
HPC systems with a separate storage allocation, `run_nextflow.sh`
overrides this to use `nobackup/` instead (see
[`docs/advice/environment.md`](../docs/advice/environment.md)).
