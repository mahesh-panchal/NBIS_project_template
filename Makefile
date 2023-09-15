# Makefile for Uppmax Environment.

# General variables
UID := $$( id -u )
GROUP := $$( id -g )

# Conda settings
CONDA_PKGM := mamba                                         # Conda package manager to use

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

.PHONY: analysis workflow-test
.PHONY: nextflow-env
.PHONY: how-to
.PHONY: report
