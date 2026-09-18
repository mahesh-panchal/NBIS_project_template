# Scratch

Disposable space: temporary files, one-off tests, downloads you're
poking at before deciding where (if anywhere) they belong. This is also
where an AI agent working in this repo should do its own testing and
scratch work (see [`AGENTS.md`](../AGENTS.md)), rather than `/tmp` or
elsewhere in the repo. Everything here except this file is gitignored
and safe to delete at any time — nothing here should be the only copy of
anything you care about.

This is also where the container image cache lives (`scratch/apptainer-cache/`,
set via `NXF_APPTAINER_CACHEDIR` in the root [`pixi.toml`](../pixi.toml)) and
where each analysis's Nextflow work directory is created (`scratch/<analysis>/nxf-work/`,
see [`docs/advice/nextflow_workflow.md`](../docs/advice/nextflow_workflow.md)) —
slow to rebuild/rerun, but not precious; losing either just means Nextflow
re-pulls images or re-executes processes next run.
