# Configs - Workflow specific configs

This folder contains configuration specific to
the operation of the workflow and it's tools.
Workflow analysis parameters are instead kept
in their own folders under the `analyses` folder.

The `compute_resources.config` file contains
the specification of cluster resources to request
from the cluster queue manager.

Package configuration is declared in the process
description block to keep package configuration
information visible. It is also coded to allow
the use of Conda, Docker, or Singularity as package
managers. The format is taken directly from nf-core.

Tool specific configuration files, for example, for
MultiQC are also kept here.
