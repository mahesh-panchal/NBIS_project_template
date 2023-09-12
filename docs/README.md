# Docs - Documentation folder

Organise your documentation here.

## Project report

Make a project report rendered from the Quarto Markdown document
found in `report`. [Quarto Markdown](https://quarto.org/docs/authoring/markdown-basics.html) 
and code are intertwinned in the document, which is then rendered to HTML or other output formats.

### Converting the Project report from Quarto Markdown to HTML

1. Update the `citations.bib` file with any new citations of
tools used, and any others that need to be included in the report.

2. Update the `Project_Report.qmd` with content and tools used.

3. Transform the `Project_Report.qmd` file into a self-contained
HTML file using the following command:
    ```
    quarto render Project_Report.md
    ```

## Project website

Quarto can be used to create websites that can be hosted on sites such as Github.
This template instance renders how to use this template in the `how-to` folder.
This website could be used to host more comprehensive descriptions of analyses
performed for the project. Alternatively, the folder can be removed.

### Creating a website folder in docs using quarto

1. Install Quarto if necessary
  ```
  wget <quarto.package.latest>.deb
  sudo dpkg -i <quarto.package.latest>.deb
  ```

2. Use Quarto to make a website project in docs.
  ```
  cd docs
  quarto create-project how-to --type website
  ```

3. Follow instructions on https://quarto.org/docs/publishing/github-pages.html#publish-command 
to publish to the `gh-pages` branch on this repository.

