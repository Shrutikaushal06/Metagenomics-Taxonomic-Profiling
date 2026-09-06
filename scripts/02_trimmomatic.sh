#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/../config/config.sh"

echo "[Step 2] Trimmomatic adapter trimming..."

for R1_FILE in "$RAW_DIR"/*_R1.fastq.gz; do
    SAMPLE=$(basename "$R1_FILE" _R1.fastq.gz)
    R2_FILE="${R1_FILE/_R1/_R2}"

    echo "  --> $SAMPLE"
    java -jar "$TRIMMOMATIC_JAR" PE \
        -threads "$THREADS" \
        "$R1_FILE" "$R2_FILE" \
        "$QC_DIR/${SAMPLE}_R1_paired.fastq.gz"  "$QC_DIR/${SAMPLE}_R1_unpaired.fastq.gz" \
        "$QC_DIR/${SAMPLE}_R2_paired.fastq.gz"  "$QC_DIR/${SAMPLE}_R2_unpaired.fastq.gz" \
        ILLUMINACLIP:"$TRIMMOMATIC_ADAPTERS":2:30:10 \
        LEADING:3 TRAILING:3 \
        SLIDINGWINDOW:5:20 \
        MINLEN:50
done
echo "[Step 2] Done."
