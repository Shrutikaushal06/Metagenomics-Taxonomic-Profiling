raw_data/*.fastq.gz

▼ 

[1] FastQC ──► QC reports

▼ 

[2] Trimmomatic (ILLUMINACLIP, SLIDINGWINDOW:5:20, MINLEN:50)


▼*_paired.fastq.gz 

[3] Bowtie2 --very-sensitive vs GRCh38 ──► nonhost reads

▼ _nonhost_R.fq.gz 

[4] Kraken2 (k2_standard) ──► Bracken

▼ 

[5] Krona (per-sample + combined) 

[6] Pandas/matplotlib stacked bars + heatmap
