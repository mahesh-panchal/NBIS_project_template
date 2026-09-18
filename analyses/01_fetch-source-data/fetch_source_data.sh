#! /usr/bin/env bash

# Exit on unset variables, errors, or pipe failures
set -euo pipefail

# Fetches the small public nf-core test dataset used by 02_workflow_dev,
# demonstrating the source/ -> input/ pattern from
# docs/advice/data_management.md. Real projects replace this with
# whatever actually delivers the project's source data (sequencing
# centre transfer, collaborator upload, ...).

project_root=$( dirname "$( dirname "$PWD" )" )
source_dir="$project_root/data/source/sarscov2_test"
input_dir="$project_root/data/input/sarscov2_test"
base_url="https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/genomics/sarscov2/illumina/fastq"

mkdir -p "$source_dir" "$input_dir"

if [ -f "$source_dir/test_1.fastq.gz" ]; then
    echo "Source data already fetched at $source_dir - nothing to do." >&2
else
    for read in test_1 test_2; do
        curl -fsSL "$base_url/${read}.fastq.gz" -o "$source_dir/${read}.fastq.gz"
    done

    # Write-protect the source data once fetched - nothing downstream
    # should modify or delete it.
    chmod -R a-w "$source_dir"
fi

# Structured, descriptively named view onto source/, built with symlinks.
ln -sf "../../source/sarscov2_test/test_1.fastq.gz" "$input_dir/sarscov2_test_R1.fastq.gz"
ln -sf "../../source/sarscov2_test/test_2.fastq.gz" "$input_dir/sarscov2_test_R2.fastq.gz"

echo "Source data ready in $source_dir, linked into $input_dir"
