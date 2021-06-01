# Containers - Custom container folder

Use this folder to keep custom container image specifications.
Make a directory for the tool, and keep the `Dockerfile`/`Singularityfile` in
there.
```
 containers/
  | - <tool_name_X>/
  |   \ - Dockerfile
  \ - <tool_name_Y>/
      \ - Dockerfile
```

My favoured method of storing Docker images for private user projects is to upload
them to Github packages under the private repository.

Note: Github `docker.pkg.github.com` will soon be superceded by `ghrc.io`. Packages will
also no longer be stored at the repository level, but at the owner level.
A new method of storing private images will be needed.

### Note:
* There are many images already out there. Please use a
public image before trying to create your own.
* If you're using Singularity try to download Singularity
images (since they are files) rather than building Singularity
images from a Docker image.

Many tool images can be found from:
* [Biocontainers](https://biocontainers.pro) - Both Docker and Singularity
* [The Rocker Project](https://www.rocker-project.org) - R Docker images
* [Multi conda package Containers](https://github.com/BioContainers/multi-package-containers) - How to make multipackage conda containers.
* [Bioconductor R packages](https://www.bioconductor.org/help/docker/) - R Bioconductor images.

If an image contains part of what you need, please
build an image on top of it, for example miniconda or mamba based packages.

R packages are often needed in groups. If you use a common set of
R packages consider providing a more general container with tools
specific to a topic. For example see [R docker images for Statistical
Modelling](https://hub.docker.com/r/asachet/rocker-ml).

## Contents

* Testing an existing public image
* Example Dockerfile specification
* Building a Docker image
* Uploading the Docker image to Github packages
* First use of the image from Github packages
* Example Singularityfile specification
* Building a Singularity image using the cloud builder

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

Docker images can be built locally and pushed to Github packages:
```bash
docker build -t docker.pkg.github.com/<registry>/<repository>/<image_name>:<tag> .
docker push docker.pkg.github.com/<registry>/<repository>/<image_name>:<tag>
```

Note that `<registry>`,`<repository>`, and `<image_name>` will all be lowercase,
even if they have uppercase characters. A Personal Access Token (PAT) is also
needed to publish, install, and delete packages (See [Documentation](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-docker-registry#authenticating-to-github-packages)).

See [Github's Container Registry Documentation](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#pushing-container-images) for
more information.

## First use of the image from Github packages

Using container images (or data in general) from Github requires authentication,
usually in the form of the Personal Access Token (PAT). Singularity requires
setting some environment variables in order to authenticate on Github, however
this causes issues pulling from Public repositories which don't require authentication.

To assist with this, I've created my own functions to toggle this on and off in
my `.bashrc` file.
```bash
ghauth-enable () {
    source $HOME/.gh-auth.sh
    export -p SINGULARITY_DOCKER_USERNAME SINGULARITY_DOCKER_PASSWORD
}

ghauth-disable () {
    unset SINGULARITY_DOCKER_USERNAME SINGULARITY_DOCKER_PASSWORD
}
```

where `.gh-auth.sh` contains:
```bash
SINGULARITY_DOCKER_USERNAME='$oauthtoken'
SINGULARITY_DOCKER_PASSWORD='<github_personal_access_token>'
```
and has `rw` permissions only for myself (`600`).

When I first run a process via Nextflow (e.g. testing a process) it will
create the Singularity image locally in the Nextflow work directory.
I enable github authentication before running and then disable afterwards.
For subsequent runs of the process/container, Nextflow then uses the locally
cached copy.
```bash
ghauth-enable
./run_nextflow.sh
ghauth-disable
```

## Example Singularityfile specification

An example `Singularityfile` that builds on top of an image with package managers included.

```
# The method of building the image ( see https://sylabs.io/guides/3.7/user-guide/definition_files.html )
Bootstrap: docker
# Select a base image, e.g., an OS or another image with tools included.
# https://hub.docker.com/r/continuumio/miniconda3/dockerfile
From: continuumio/miniconda3:4.8.2

# Add metadata
%labels
    Description Software Description
    Author Mahesh Binzer-Panchal
    Version 1.0.0

# Update and install software dependencies
# with APT (Advanced Packaging  Tool)
%post
    apt-get update --fix-missing
    apt-get install -y procps ghostscript

# Install tools using the conda package manager
%post
    conda update -n base conda
    conda install -c conda-forge -c bioconda \
	python=3.6 mafft=7.455 blast=2.9.0 openssl=1.1.1e perl-bioperl=1.7.2
    conda clean --all -f -y

# Manual installation in another directory
%post
    cd /opt
    git clone --depth 1 https://github.com/<namespace>/<repository>
    cd <repository>
    pip install matplotlib==2.2.3
    pip install seaborn==0.8.1
    pip install weblogo==3.6.0
    pip install biopython

# Set environment variables
%environment
    export PATH "/opt/<repository>:${PATH}"

```

## Building a Singularity image using the cloud builder

Details can be found on the [Singularity Remote Cloud Builder](https://cloud.sylabs.io/builder).
You need a Sylabs cloud token from the remote builder for this to work (easily acquired).
```bash
singularity build --remote <tool>-<version>.sif /path/to/Singularityfile
```
