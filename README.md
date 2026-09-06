Metagenomics Pipeline

End-to-end shotgun-metagenomics workflow for Illumina paired-end reads:quality control → adapter trimming → host depletion → taxonomic profiling → visualization.

Stages

#	Step	Tool	Output
1	Quality check	FastQC	results/fastqc/
2	Adapter trimming	Trimmomatic	output/*_paired.fastq.gz
3	Host depletion	Bowtie2	nonhost/*_nonhost_R*.fq.gz
4	Taxonomy	Kraken2 + Bracken	taxonomy/*_kraken2.report, *_bracken.report
5	Krona charts	ktImportTaxonomy	results/krona/*.html
6	Abundance plots	Python (pandas/matplotlib)	lineage_abundance_plots/
Usage

Edit config/config.sh (paths, threads, samples, DBs).
Place raw *_R1.fastq.gz / *_R2.fastq.gz in RAW_DIR.
Run:
bash bin/run_pipeline.sh
 Skip stages selectively:

bash

SKIP_FASTQC=1 bash bin/run_pipeline.sh
Re-run only visualization:
bash

bash scripts/05_krona_visualization.sh
python3 scripts/06_abundance_plots.py
Requirements

 Trimmomatic 0.39, Bowtie2, Kraken2, Bracken, FastQC, KronaTools
 Python ≥ 3.8 with pandas, matplotlib
Reproducibility

All parameters live in config/config.sh. Tag releases with git:

bash

git tag -a v1.0 -m "Initial pipeline"
