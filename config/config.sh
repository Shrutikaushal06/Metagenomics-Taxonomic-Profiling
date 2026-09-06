#!/bin/bash
# ============================================================
#  Central configuration for the metagenomics pipeline
#  Source this file from every step:  source config/config.sh
# ============================================================

# ---- Project paths ----
PROJECT_ROOT="/ibdc-scratch2/home/IBDCHPCU0158/metagenomics"
RAW_DIR="${PROJECT_ROOT}/raw_data"
QC_DIR="${PROJECT_ROOT}/output"
NONHOST_DIR="${PROJECT_ROOT}/nonhost"
TAXA_DIR="${PROJECT_ROOT}/taxonomy"
RESULTS_DIR="${PROJECT_ROOT}/results"
LOG_DIR="${PROJECT_ROOT}/logs"

# ---- Compute ----
THREADS=16
READ_LEN=150

# ---- Tools / databases ----
TRIMMOMATIC_JAR="/ibdc-hpc/apps1/trimmomatic/trimmomatic-0.39.jar"
TRIMMOMATIC_ADAPTERS="/ibdc-hpc/apps1/trimmomatic/adapters/TruSeq3-PE-2.fa"
HUMAN_DB="/ibdc-scratch2/home/IBDCHPCU0158/metagenomics/human_index/GRCh38_noalt_as"
KRAKEN_DB="/ibdc-analysis/IBDC-BRAHM-ANALYSIS/genome/krakendb/k2_standard/"
KRONA_DB=""  # set if you have a custom Krona taxonomy DB

# ---- Samples (edit as needed) ----
SAMPLES=(INCSS001115 INCSS001116 INCSS001117 INCSS001118 INCSS001119)

# ---- Create dirs ----
mkdir -p "$QC_DIR" "$NONHOST_DIR" "$TAXA_DIR" "$RESULTS_DIR" "$LOG_DIR"
