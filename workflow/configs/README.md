# Configs - Workflow specific configs

This folder contains configuration specific to
the operation of the workflow and it's tools. 
Workflow analysis parameters are instead kept 
in their own folders under the `analyses` folder.

The `compute_resources.config` file contains
the specification of cluster resources to request
from the cluster queue manager. 

The `software_packages.config` file contains
the specification of how to load packages. This
is separated from the `compute_resources.config`
to allow flexibility with how packages are loaded.
My preference is to stick to using containers,
however packages can also be loaded using conda,
or the module system. 

The configuration file for MultiQC is also kept
here.
