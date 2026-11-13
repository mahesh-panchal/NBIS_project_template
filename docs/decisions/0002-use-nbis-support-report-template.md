# 2. Fetch the NBIS support report template when writing the closing report

Date: 2026-11-13

## Status

Accepted

## Context

This repository bundled its own closing report: a Quarto theme (`flatly`)
and a copy of the standard NBIS boilerplate (data responsibility,
acknowledgements). NBIS maintains
[NBISweden/NBIS-template-support-reports](https://github.com/NBISweden/NBIS-template-support-reports),
which ships the `nbis` Quarto extension (theme, logo, TOC) and the
current wording. The bundled copy had already drifted: it said
UPPNEX/UPPMAX, linked a retired human-data page, and listed fewer HPC
sites. Issue #11.

Nobody here watches the upstream repository, so any copy kept in this
template goes stale unnoticed. Fetching on every render avoids that but
lets a report change mid-project. Fetching at project start leaves months
between the fetch and the report.

## Decision

This repository holds no report template. `pixi run closing-report-init`
fetches the current upstream template (`NBIS_Quarto_Report.qmd` and the
`nbis` extension) into `docs/closing_report/` when it is time to write the
report, then inserts the project-specific sections kept in
`docs/closing_report_additions/` (project allocation, workflow, software
table, reproducibility, recommendations, references, `citations.bib`).
The project commits the result. `pixi run closing-report` renders that
local copy offline.

- The ref is explicit (`@master`) because upstream's default branch is
  `master` and Quarto assumes `main`.
- The init task refuses to overwrite an existing report.
- Additions are inserted at exact upstream heading lines
  (`apply.sh`). If upstream renames one, the task fails instead of
  dropping a section.
- The environment does not support the template's R engine or example
  chunks (no R in `pixi.toml`). The author replaces the `knitr:` block
  and chunks when writing the report. A throwaway render, with those
  removed, confirmed the fetched template plus additions renders.

## Consequences

- The report starts from the newest NBIS template, with no maintenance of
  a copy here.
- A report is fixed once committed; later upstream changes are adopted by
  hand.
- `closing-report-init` needs internet; render does not.
- `closing-report` fails on a fresh fetch until the R engine and example
  chunks are removed or replaced.
- `apply.sh` can break when upstream restructures headings, and needs a
  fix then.
- The template's `.gitignore` must not ignore `docs/closing_report/`,
  because projects commit it.
- Fixes to shared wording should go upstream as a PR.
