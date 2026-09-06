#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/../config/config.sh"

echo "[Step 3] Host DNA depletion with Bowtie2..."

for R1_FILE in "$QC_DIR"/*_R1_paired.fastq.gz; do
    SAMPLE=$(basename "$R1_FILE" _R1_paired.fastq.gz)
    R2_FILE="${R1_FILE/_R1_paired/_R2_paired}"

    echo "  --> $SAMPLE"
    bowtie2 \
        -x "$HUMAN_DB" \
        -1 "$R1_FILE" -2 "$R2_FILE" \
        --very-sensitive \
        --threads "$THREADS" \
        --un-conc-gz "$NONHOST_DIR/${SAMPLE}_nonhost_R%.fq.gz" \
        -S /dev/null
done
echo "[Step 3] Done."
