#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/../config/config.sh"

echo "[Step 1] FASTQC quality check..."
cd "$RAW_DIR"
fastqc *.gz -o "$RESULTS_DIR/fastqc" -t "$THREADS"
echo "[Step 1] Done."
