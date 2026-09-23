# Input data

A structured, descriptively named view onto [`../source/`](../source/README.md),
built using symlinks rather than copies:

```bash
ln -s ../source/<delivery>/<file> data/input/<sample>/<meaningful_name>
```

*This keeps `source/` untouched and read-only, while giving workflows and
notebooks (in [`analyses/`](../../analyses/README.md), calling code in
[`code/`](../../code/README.md)) a clean, consistent set of paths to read
from, e.g. as a samplesheet input.*
