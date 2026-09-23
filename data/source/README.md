# Source data

The original data as delivered (e.g., sequencing centre deliveries, data
received from a collaborator). Once placed here, make it read-only to
prevent accidental modification:

```bash
chmod -R a-w data/source/<delivery>/
```

Never edit, rename, or reorganise files in place here. Instead, create a
structured, descriptive layout in [`../input/`](../input/README.md) using
symlinks that point back to these files.

*So a result can always be traced back to exactly what was delivered,
even once its own naming or organisation turns out to be awkward to
work with.*
