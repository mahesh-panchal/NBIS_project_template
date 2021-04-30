# Containers - Custom container folder

Use this folder to keep Container image specifications.

Note:
There are many images already out there. Please use a
public image before trying to create your own.

Many tool images can be found from:
* [Biocontainers](https://biocontainers.pro)
* [The Rocker Project](https://www.rocker-project.org)

If an image contains part of what you need, please
build an image on top of it. 

## Example Dockerfile specification

An example `Dockerfile` that builds on top of an image with package managers included.

```
# Select a base image, e.g., an OS or another image with tools included.
# https://hub.docker.com/r/continuumio/miniconda3/dockerfile
FROM continuumio/miniconda3:4.8.2

# Select the shell
SHELL ["/bin/bash", "-c"]

# Add metadata
LABEL description="Software Description" \
      author="Mahesh Binzer-Panchal" \
      version="1.0.0"

# Update and install software dependencies 
# with APT (Advanced Packaging  Tool)
RUN apt-get update --fix-missing && \
    apt-get install -y procps ghostscript

# Install tools using the conda package manager
RUN conda update -n base conda && \
    conda install -c conda-forge -c bioconda \
	python=3.6 mafft=7.455 blast=2.9.0 openssl=1.1.1e perl-bioperl=1.7.2 && \
    conda clean --all -f -y

# Manual installation in another directory
WORKDIR /opt
RUN git clone --depth 1 https://github.com/<namespace>/<repository> && \
    cd <repository> && \
    pip install matplotlib==2.2.3 && \
    pip install seaborn==0.8.1 && \
    pip install weblogo==3.6.0 && \
    pip install biopython

# Set environment variables
ENV PATH="/opt/<repository>:${PATH}"

# Provide a default command (entry point)
CMD [ "<script>.py" ]
```
