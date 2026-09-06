#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/../config/config.sh"

KRONA_OUT="$RESULTS_DIR/krona"
mkdir -p "$KRONA_OUT"

echo "[Step 5] Building Krona charts..."

# Per-sample Krona
for sample in "${SAMPLES[@]}"; do
    IN="$TAXA_DIR/${sample}_nonhost_R1.fq.gz_nonhost_R1.fq.gz_kraken2.output"
    if [[ ! -f "$IN" ]]; then
        echo "  (skip) missing: $IN"; continue
    fi
    awk '$1=="C" {print $2 "\t" $3}' "$IN" > "$KRONA_OUT/${sample}.krona.txt"
    ktImportTaxonomy -t 2 -o "$KRONA_OUT/${sample}.krona.html" \
        "$KRONA_OUT/${sample}.krona.txt"
done

# Combined Krona across samples
COMMA_LIST=""
LABEL_LIST=""
for sample in "${SAMPLES[@]}"; do
    TXT="$KRONA_OUT/${sample}.krona.txt"
    [[ -f "$TXT" ]] || continue
    COMMA_LIST+="${TXT},${sample} "
done

ktImportTaxonomy -c -t 2 \
    -o "$KRONA_OUT/all_samples.krona.html" \
    $COMMA_LIST
echo "[Step 5] Done -> $KRONA_OUT"
