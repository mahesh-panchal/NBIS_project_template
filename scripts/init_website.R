#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# Initialise the distill website
library('distill')
website_path = "."
if (!is.null(args[1])){
    website_path = args[1]
}
create_website(dir = website_path, title = "My reproducible research project", gh_pages = TRUE)
