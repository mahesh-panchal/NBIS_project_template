# 1. Vendor a local copy of the UPPMAX config for Bianca

Date: 2026-09-21

## Status

Accepted

## Context

`docs/advice/nextflow_workflow.md` recommends pulling in
[nf-core's maintained institutional configs](https://nf-co.re/configs)
for cluster profiles via a live `includeConfig 'https://...'`, rather
than hand-writing them, so they stay in sync with each cluster's
scheduler/scratch/container setup. `code/workflows/qc/nextflow.config`'s
`bianca` profile did exactly that — but [Bianca](../advice/glossary.md#clusters)
has no general internet access, so that `includeConfig` (and the
module's default container pull from a public registry) would just
hang or fail there. Nothing in the template previously reconciled this.

## Decision

For `bianca` specifically, vendor a local copy of nf-core's
`uppmax.config` (`code/workflows/qc/conf/bianca_uppmax.config`, with a
header noting the source commit and fetch date), and override each
module's container to a local file path under
`scratch/apptainer-cache/` instead of a registry reference. `pelle`,
`dardel`, and `arrhenius` keep their live `includeConfig`, since they do
have internet access. See
[`nextflow_workflow.md`](../advice/nextflow_workflow.md#running-on-bianca)
for the mechanics.

## Consequences

- Running on Bianca needs a manual pre-step on a machine with internet:
  pull each module's container image and transfer it (e.g. via `wharf`)
  into `scratch/apptainer-cache/` before the first run there.
- The vendored `uppmax.config` copy won't pick up upstream fixes on its
  own — it needs an occasional manual re-fetch-and-diff, unlike `pelle`'s
  live include.
- Adding a new module to a workflow that also runs on Bianca means
  adding one more `withName` container override to that workflow's
  `bianca` profile, on top of the usual `nf-core modules install`.
