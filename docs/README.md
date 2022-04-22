# Docs - Documentation folder

Keep your documentation here.

The Project report is kept here and updated as the analyses continues.
[Markdown](https://www.markdownguide.org/cheat-sheet/) is used to write
up the report, which is converted to HTML at the end for portability.

## Contents

* How I work
* Converting a Project report from Markdown to HTML

## How I work

For a description of how I work see [How I work](docs/HowToWork.md).

## Converting the Project report from Markdown to HTML

1. Update the `citations.bib` file with any new citations of
tools used, and any others that need to be included in the report.

2. Update the `Project_Report.qmd` with content and tools used.

3. Transform the `Project_Report.qmd` file into a self-contained
HTML file using the following command:
    ```
    quarto render Project_Report.md
    ```
