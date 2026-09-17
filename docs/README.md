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

## Decisions

The [`decisions/`](decisions/) folder holds Architecture Decision Records
(ADRs) and similar documents — the reasoning behind significant,
non-obvious, or hard-to-reverse choices. See
[`decisions/README.md`](decisions/README.md) for the convention and
[`decisions/template.md`](decisions/template.md) to start a new one.

## Closing report

Make a closing report rendered from the Quarto Markdown document found in
`closing_report`. [Quarto Markdown](https://quarto.org/docs/authoring/markdown-basics.html)
and code are intertwinned in the document, which is then rendered to HTML or other output formats.

### Converting the closing report from Quarto Markdown to HTML

1. Update the `citations.bib` file with any new citations of
    tools used, and any others that need to be included in the report.

2. Update the `closing_report.qmd` with content and tools used.

3. Transform the `closing_report.qmd` file into a self-contained
    HTML file using:

    ```bash
    pixi run closing-report
    ```

