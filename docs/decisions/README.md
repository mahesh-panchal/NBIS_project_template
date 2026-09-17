# Decisions

Architecture Decision Records (ADRs) and similar decision documents go
here — a short-lived record of *why* a significant choice was made, kept
next to (not instead of) the code it affects.

Write one when a decision is non-obvious, hard to reverse, or likely to
be questioned later — e.g., choosing a workflow manager, a data layout
change, or dropping a tool. Skip it for anything easily seen from the
code or commit message.

Number records sequentially and never renumber or delete one — if a
decision changes, write a new record that supersedes it:

```
decisions/
 | - template.md                        Copy this to start a new record
 | - 0001-<short-title>.md
 \ - 0002-<short-title>.md
```

Use [`template.md`](template.md) for the format.
