# Docs - Documentation folder

Keep your documentation here. 

This is where the Project report resides.

## Converting the Project report from Markdown to HTML

1. Update the `citations.bib` file with any new citations of 
tools used, and any others that need to be included in the report.

2. Update the `Project_Report.md` with content and tools used.

3. Transform the `Project_Report.md` file into a self-contained 
HTML file using the following command:
    ```
    pandoc --toc --filter pandoc-citeproc --template template.html --css template.css --self-contained -o Project_Report.html Project_Report.md
    ```

