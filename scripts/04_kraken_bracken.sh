#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/../config/config.sh"

echo "[Step 4] Kraken2 + Bracken taxonomic profiling..."

for R1_FILE in "$NONHOST_DIR"/*_nonhost_R1.fq.gz; do
    SAMPLE=$(basename "$R1_FILE" _nonhost_R1.fq.gz)
    R2_FILE="${R1_FILE/_R1/_R2}"

    echo "  --> $SAMPLE"
    kraken2 \
        --db "$KRAKEN_DB" \
        --paired "$R1_FILE" "$R2_FILE" \
        --threads "$THREADS" \
        --out "$TAXA_DIR/${SAMPLE}_kraken2.output" \
        --report "$TAXA_DIR/${SAMPLE}_kraken2.report"

    bracken \
        -d "$KRAKEN_DB" \
        -i "$TAXA_DIR/${SAMPLE}_kraken2.report" \
        -o "$TAXA_DIR/${SAMPLE}_bracken.report" \
        -r "$READ_LEN"
done
echo "[Step 4] Done."
