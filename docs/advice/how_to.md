# How to use this template

This repository is a template for research/support projects to produce
reproducible output. It relies on a small set of tools working together:

- **Git**: version control, and a way to make exploratory changes that are
  revertable.
- **Nextflow**: workflow manager, for processing data across a wide variety
  of execution systems. See [`code.md`](code.md).
- **Pixi**: declares and installs the tools a project needs. See
  [`environment.md`](environment.md).
- **Apptainer/Docker**: container platforms providing isolated,
  reproducible compute environments.
- **Quarto**: publishing system for the closing report (and, optionally,
  other documentation), mixing Markdown with executable code.
- **Mermaid diagrams**: a textual way to describe diagrams, rendered
  natively by Quarto and GitHub — used in `analyses/README.md`'s History
  section.

## Starting a new project

- Make a private project repository from this template on GitHub.
  1. Select `New Repository` on GitHub from the `+` symbol in the top right corner.
  2. Select this template repository under `Repository template`.
  3. Set the owner appropriately (e.g. `NBISweden`).
  4. Name the repository following your organisation's convention (e.g. `SMS-<id>-<year>-<short_description>`).
  5. Ensure the repository is private, then click `Create repository`.
  6. Add a link to the tracking issue/ticket (e.g. Redmine) in the repository's URL/description field.
- Clone it to wherever computations will run (e.g. an HPC compute allocation):
  ```bash
  cd /proj/naiss20XX-YY-ZZ
  git clone git@github.com:<org>/<repo>.git <project_root>
  ```
- Clone it locally too, if you'll also work from a local machine:
  ```bash
  cd ~/Documents/Projects
  git clone <user>@<hpc-login-node>:/proj/naiss20XX-YY-ZZ/<project_root>
  ```
- Update the root `README.md` with the project info, tasks to be
  performed, and any allocation/storage details.

If compute and local work both push to the same repository, keep the
branch used on the compute allocation (usually `main`) distinct from the
branch you push from locally (usually a feature branch), so a `git push`
from either side doesn't clobber the other's in-progress state.

## Working habits

- Use the organised folder structure described in
  [`data_management.md`](data_management.md) rather than improvising a
  different layout.
- Keep a stable `main` git branch; use feature branches for new analyses
  or workflow changes (see Git workflow below).
- Make a test data set for development purposes — see
  [`nextflow_workflow.md`](nextflow_workflow.md#test-data).
- Parameters and configuration are committed to version control, alongside
  the code that uses them (see [`analyses.md`](analyses.md)).
- If a run fails, debug it in the Nextflow work directory — see
  [`nextflow_workflow.md`](nextflow_workflow.md#troubleshooting).

## Git workflow

Analysis/workflow development follows the
[GitFlow model](http://datasift.github.io/gitflow/IntroducingGitFlow.html):

- Stable `main` branch.
- Mostly-stable `dev` branch — develops a line of analysis.
- Feature branches to try things out.

```bash
git checkout -b <new_feature>
# ... make changes, commit as you go ...
git add <file>
git commit -m "What I did"
```

A mistake in the last commit can be fixed with `git commit --amend`
(only before pushing/sharing that commit).

Once a feature branch works, merge it back. `merge` tacks the changes onto
the end of the branch; `rebase` re-applies your commits on top of the
latest target branch — pick whichever keeps history clearest for the
change in hand.

```bash
# Update dev branch with changes from origin
git checkout dev
git pull --rebase

# Bring dev's changes into the feature branch
git checkout <new_feature>
git rebase dev
# IMPORTANT: resolving conflicts with stable code is your responsibility

# Merge the finished feature into dev
git checkout dev
git merge <new_feature>
git branch -d <new_feature>
```

## References

- [Version control with Git](https://swcarpentry.github.io/git-novice/) — Software Carpentries course.
- [How to undo (almost) anything in git](https://github.blog/2015-06-08-how-to-undo-almost-anything-with-git/).
- Accidentally deleted a tracked file? `git restore <filename>`.
- Do not add large (> 100MB) files, and never commit sensitive information
  (usernames, passwords, API keys) to a git repository.
- [Reproducible Computational Environments Using Containers: Introduction to Docker](https://carpentries-incubator.github.io/docker-introduction/) — Software Carpentries course.
- [Dockerfile best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/).
- [Introduction to Singularity/Apptainer](https://carpentries-incubator.github.io/singularity-introduction/) — Software Carpentries course. Build custom images in Docker first, for increased portability.
- Public container image sources: [Biocontainers](https://biocontainers.pro/registry), [Rocker](https://www.rocker-project.org/images/) (R), [Python Data science](https://hub.docker.com/r/civisanalytics/datascience-python/).
- [Nextflow Training from Seqera](https://seqera.io/training/) and the [Nextflow documentation](https://www.nextflow.io/docs/latest/index.html).
- [Introduction to Bioinformatics workflows with Nextflow and nf-core](https://carpentries-incubator.github.io/workflows-nextflow/) — Software Carpentries course.
