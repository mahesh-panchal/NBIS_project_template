# Using this Repository

If you fork a copy of this repository to your own Github namespace, you
can make your own version of a repository to use as a template.

Once you clone it locally, you can then add this repository as a template
so you can keep your own changes to your forked copy, but still pull in
updates from this repository.

```bash
git remote add template <template_url>
```

Changes to the template can be incorporated using:

```bash
git fetch template
git checkout <branch-to-merge-to>
git merge template/<branch-to-merge>
```
