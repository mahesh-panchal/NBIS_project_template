# Data

This folder organises all data used and produced by the project.
See [docs/advice/data_management.md](../docs/advice/data_management.md) for
the full description of how data flows between the subfolders below.

```
data/
 | - source/                     Original delivered/source data (write-protected)
 | - input/                      Structured input, symlinked from source/
 \ - results/                    Workflow/notebook outputs
```

On systems with a separate storage allocation (e.g., a NAISS storage
project on UPPMAX), this folder is typically a symlink to, or mounted
from, that allocation rather than living inside the git repository.
