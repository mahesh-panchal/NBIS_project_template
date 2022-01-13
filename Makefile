# Makefile for Uppmax Environment.

# General variables
UID := $$( id -u )
GROUP := $$( id -g )

# Conda settings
CONDA_PKGM := mamba                                         # Conda package manager to use

# R settings
# CONTAINER_CMD := docker run --user "$(UID):$(GROUP)" --rm -v "${PWD}:/home/rstudio" -w /home/rstudio
CONTAINER_CMD := singularity exec
DISTILL_IMG := ghcr.io/mahesh-panchal/rocker/distill:4.1.2  # Image name and version
WEBSITE_DIR := website
REPORT_DIR := docs

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

# Build the RMarkdown report
report:
	$(CONTAINER_CMD) $(DISTILL_IMG) Rscript scripts/build_report.R

clean-report:

# Publish Distill website to local gh-pages branch
gh-pages: $(WEBSITE_DIR)/docs/index.html
	git subtree push --prefix $(WEBSITE_DIR)/docs . gh-pages

# Publish Distill website to gh-pages branch on Github
gh-pages-origin: $(WEBSITE_DIR)/docs/index.html
	git subtree push --prefix $(WEBSITE_DIR)/docs origin gh-pages

# Builds the Distill website
website: $(WEBSITE_DIR)/_site.yml
	$(CONTAINER_CMD) $(DISTILL_IMG) Rscript scripts/build_website.R $(WEBSITE_DIR)

$(WEBSITE_DIR)/_site.yml:
	$(CONTAINER_CMD) $(DISTILL_IMG) Rscript scripts/init_website.R $(WEBSITE_DIR)

clean-website:
	rm -rf $(WEBSITE_DIR)

.PHONY: analysis workflow-test
.PHONY: nextflow-env
.PHONY: gh-pages gh-pages-origin
.PHONY: report clean-report
.PHONY: website clean-website
