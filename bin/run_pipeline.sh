#!/bin/bash
# Run the full pipeline (skip any step via env vars, e.g. SKIP_FASTQC=1)
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SCRIPTS="$ROOT/scripts"

[[ -z ${SKIP_FASTQC:-} ]]     && bash "$SCRIPTS/01_fastqc.sh"
[[ -z ${SKIP_TRIM:-} ]]       && bash "$SCRIPTS/02_trimmomatic.sh"
[[ -z ${SKIP_HOST:-} ]]       && bash "$SCRIPTS/03_remove_host.sh"
[[ -z ${SKIP_KRAKEN:-} ]]     && bash "$SCRIPTS/04_kraken_bracken.sh"
[[ -z ${SKIP_KRONA:-} ]]      && bash "$SCRIPTS/05_krona_visualization.sh"
[[ -z ${SKIP_PLOTS:-} ]]      && python3 "$SCRIPTS/06_abundance_plots.py"

echo "Pipeline finished."
