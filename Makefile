# Makefile for Uppmax Environment.

# General variables
UID := $$( id -u )
GROUP := $$( id -g )

# Conda settings
CONDA_PKGM := mamba  # Conda package manager to use

# Run Nextflow workflow
analysis:
	cd analyses/YYYY-MM-DD_workflow_dev; \
		./run_nextflow.sh

workflow-test:
	cd analyses/YYYY-MM-DD_workflow_dev; \
		./run_nextflow.sh

# Builds conda environment to execute workflow
nextflow-env:
	$(CONDA_PKGM) env create --prefix "conda/nextflow-env" \
		-f "workflow/nextflow_conda-env.yml"

# Render How-to webpages
how-to:
	cd docs/how-to && quarto publish gh-pages --no-browser

# Render Report
report:
	cd docs/report && quarto render Project_Report.qmd

# Link template
git-link-template:
	git remote add template https://github.com/mahesh-panchal/NBIS_project_template

# Merge changes from template to current branch
git-merge-template:
	git fetch template
	git merge template/main --allow-unrelated-histories

# Phony targets
.PHONY: analysis workflow-test
.PHONY: nextflow-env
.PHONY: how-to
.PHONY: report
.PHONY: git-link-template git-merge-template
