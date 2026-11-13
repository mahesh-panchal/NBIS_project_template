#!/usr/bin/env bash
# Insert this project's extra sections into the freshly fetched upstream
# report (docs/closing_report/NBIS_Quarto_Report.qmd). Run by
# `pixi run closing-report-init`.
#
# Insertion points are matched on exact upstream heading lines. If upstream
# renames one, this fails loudly instead of silently dropping a section.
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
report="${1:?usage: apply.sh <report.qmd>}"
out=$(mktemp)

for anchor in '## Data responsibility' '## Data' '# Results'; do
    grep -qxF "$anchor" "$report" || {
        echo "apply.sh: anchor '$anchor' not found in $report; upstream changed." >&2
        echo "Update docs/closing_report_additions/apply.sh to match." >&2
        exit 1
    }
done

# Order within the report:
#   ## Project allocation   before  ## Data responsibility
#   ## Workflow, ## Software  before  ## Data
#   ## Reproducibility      before  # Results
#   # Recommendations, # References   at the end
# The bibliography line goes at the end of the YAML header.
awk -v dir="$here" '
function cat_file(f,   line) {
    while ((getline line < (dir "/" f)) > 0) print line
    close(dir "/" f)
    print ""
}
$0 == "---" { fm++; if (fm == 2) print "bibliography: citations.bib" }
$0 == "## Data responsibility" { cat_file("allocation.qmd") }
$0 == "## Data"                { cat_file("methods.qmd") }
$0 == "# Results"              { cat_file("reproducibility.qmd") }
{ print }
END {
    print ""
    cat_file("recommendations.qmd")
    cat_file("references.qmd")
}
' "$report" > "$out"

cat "$out" > "$report"
rm "$out"
cp "$here/citations.bib" "$(dirname "$report")/citations.bib"
