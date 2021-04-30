# How I work

Cloning this repository as a template should have set up a lot of things for you.

General advice:
* Use git branches to add new features, and make sure the `main` branch is always stable.
* Make a test data set from the users data, and use that to test code as you develop.
* To understand what a Nextflow construct does, make an example test like in [Nextflow Patterns](http://nextflow-io.github.io/patterns/index.html). Nextflow also has a (GUI) console mode to test syntax (`nextflow console`).

## Adding a new Nextflow process

1. Make a new branch.

  ```bash
  git branch -d <add_process>
  ```

2. Edit the process into the workflow:

  ```groovy
  process <name> {

	  <directives>

	  input:
	    path <filename_var>

	  output:
	    path "<filename>", emit: <file_type>
	    path "*"  // Captures everything. Use when you don't know what the output is.

	  script:
	  """
	  """
  }
  ```

3. Add the container path and resources to the configs.

4. Test with the test data.
