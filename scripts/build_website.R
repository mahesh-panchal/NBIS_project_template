#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# Render website
if(!is.null(args[1])){
    setwd(args[1])
}
getwd()
list.files()
rmarkdown::render_site()
