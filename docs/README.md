# Docs - Documentation folder

Organise your documentation here.

## Advice for working in this repository

The [`advice/`](advice/) folder contains markdown files that explain how
this repository is organised and how to work in it (e.g.,
[`advice/data_management.md`](advice/data_management.md) describes the
`analyses/`/`code/`/`data/` layout). [`AGENTS.md`](../AGENTS.md) at the
project root points AI agents here — keep these files up to date as the
project's conventions evolve, and update them (not `AGENTS.md`) when a
convention changes.

## Project info

[`project_info.md`](project_info.md) holds the Redmine/administrative
fields (Project ID, PI, requester, NBIS Agreement) — kept separate from
the root `README.md` so that file stays a quick technical orientation,
and separate from the closing report so the report stays focused on
methods and results.

## Decisions

The [`decisions/`](decisions/) folder holds Architecture Decision Records
(ADRs) and similar documents — the reasoning behind significant,
non-obvious, or hard-to-reverse choices. See
[`decisions/README.md`](decisions/README.md) for the convention and
[`decisions/template.md`](decisions/template.md) to start a new one.

## Closing report

The closing report is NBIS's support report template
([NBISweden/NBIS-template-support-reports](https://github.com/NBISweden/NBIS-template-support-reports)).
It is not bundled here. You fetch it when it is time to write the report,
so it is current then and does not change afterwards. See
[`decisions/0002-*.md`](decisions/) for why.
[Quarto Markdown](https://quarto.org/docs/authoring/markdown-basics.html)
and code are intertwined in the document, which is then rendered to HTML.

### Writing the closing report

1. Fetch the current template into `closing_report/` (needs internet, so
    not on Bianca; refuses to overwrite an existing report):

    ```bash
    pixi run closing-report-init
    ```

    This also inserts this project's extra sections from
    [`closing_report_additions/`](closing_report_additions/) (project
    allocation, workflow, software table, reproducibility,
    recommendations, references) and copies in `citations.bib`. Commit
    the result, including `_extensions/`. Later upstream changes are
    adopted by hand.

    If upstream renames a heading the additions are anchored on, the
    task stops with an error. Update
    `closing_report_additions/apply.sh` to match.

2. Fill in `closing_report/NBIS_Quarto_Report.qmd` and update
    `citations.bib`. The template sets the R (`knitr`) engine and has
    example R chunks. This environment has no R, so remove the `knitr:`
    block and example chunks, or replace them with your own engine and
    code, before rendering.

3. Render it to a self-contained HTML file (works offline):

    ```bash
    pixi run closing-report
    ```
