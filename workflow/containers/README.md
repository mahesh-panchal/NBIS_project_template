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

## Contents

* Testing an existing public image
* Example Dockerfile specification
* Building a Docker image
* Uploading the Docker image to Github packages
* First use of the image from Github packages

## Testing an existing public image

It can sometimes be difficult to know if a container image has
what you need installed. It's a good idea to pull the image
and test it before including it into the workflow.

One can test a single command,
```bash
docker run --rm quay.io/biocontainers/fastqc:0.11.9--0 fastqc --version
```
or test interactively.
```bash
docker run --name fqc -it quay.io/biocontainers/fastqc:0.11.9--0 bash
> fastqc --version
> exit
```

More generally the command is:
```bash
docker run --rm <image_name>:<tag> <command> <parameters>
```
or, interactively,
```bash
docker run --name <container_id> -it <image_name>:<tag> bash
> <command> <parameters>
> exit
docker rm <container_id>
```

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

## Building a Docker image

To build a Docker image from a Dockerfile you need Docker installed.

Change directory to the folder where the Dockerfile is located,
and then use the following to build the image locally. The `<image_name>`
is what you want to refer to the image by, e.g. the software name,
and the `<tag>` is often the the version, e.g. 1.0.0 .
```bash
docker build -t <image_name>:<tag> .
```

You can then test the tool by calling it from the container.
```bash
docker run --rm <image_name>:<tag> <command> --version
```
Alternatively, make an interactive session in the container, and test.
```bash
docker run --name <container_id> -it <image_name>:<tag> bash
> <command> --version
> exit
docker rm <container_id>
```

## Uploading the Docker image to Github packages


## First use of the image from Github packages
