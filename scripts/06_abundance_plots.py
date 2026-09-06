#!/usr/bin/env python3
"""Build lineage TSV, stacked-bar plots, and a species heatmap from Kraken2 reports."""
import glob, os, sys
import pandas as pd
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

INPUT_PATTERN = "*_kraken2.report"
OUTDIR = "lineage_abundance_plots"
os.makedirs(OUTDIR, exist_ok=True)

RANK_ORDER = {"D":1, "P":2, "C":3, "O":4, "F":5, "G":6, "S":7}
RANK_NAMES = {"D":"Domain","P":"Phylum","C":"Class","O":"Order",
               "F":"Family","G":"Genus","S":"Species"}

# ---- Build lineage TSV ----
all_data = []
for f in glob.glob(INPUT_PATTERN):
    sample = f.split("_nonhost")[0]
    lineage = []
    with open(f) as fh:
        for line in fh:
            parts = line.rstrip("\n").split("\t")
            if len(parts) < 6: continue
            percentage, reads, direct_reads = parts[0:3]
            rank, taxid, name = parts[3].strip(), parts[4].strip(), parts[5].strip()
            if rank == "U" or rank not in RANK_ORDER: continue
            lvl = RANK_ORDER[rank]
            lineage = lineage[:lvl-1]
            lineage.append(name)
            all_data.append([sample, rank, taxid, name, percentage,
                             reads, direct_reads, ";".join(lineage)])

df = pd.DataFrame(all_data, columns=[
    "Sample","Rank","TaxID","Name","Percentage","Reads","Direct_Reads","Lineage"])
df.to_csv("all_samples_lineage.tsv", sep="\t", index=False)
print(f"Created all_samples_lineage.tsv  ({len(df)} records)")

# ---- Per-rank stacked bars ----
for rc, rn in RANK_NAMES.items():
    rdf = df[df["Rank"] == rc]
    if rdf.empty: continue
    ab = rdf.pivot_table(index="Sample", columns="Name",
                         values="Percentage", aggfunc="sum", fill_value=0)
    ab.to_csv(f"{OUTDIR}/{rn.lower()}_abundance.tsv", sep="\t")
    top = ab.mean(axis=0).sort_values(ascending=False).head(20).index
    ax = ab[top].plot(kind="bar", stacked=True, figsize=(14,8))
    ax.set_xlabel("Sample"); ax.set_ylabel("Relative abundance (%)")
    ax.set_title(f"{rn}-level microbial abundance")
    plt.xticks(rotation=45, ha="right")
    plt.legend(title=rn, bbox_to_anchor=(1.02,1), loc="upper left")
    plt.tight_layout()
    plt.savefig(f"{OUTDIR}/{rn.lower()}_abundance_stacked_bar.png", dpi=300, bbox_inches="tight")
    plt.close()

# ---- Species heatmap ----
sp = df[df["Rank"]=="S"].pivot_table(index="Name", columns="Sample",
                                      values="Percentage", aggfunc="sum", fill_value=0)
top_sp = sp.mean(axis=1).sort_values(ascending=False).head(20).index
hm = sp.loc[top_sp]

fig, ax = plt.subplots(figsize=(10,12))
im = ax.imshow(hm.values, aspect="auto")
ax.set_xticks(range(len(hm.columns))); ax.set_xticklabels(hm.columns, rotation=45, ha="right")
ax.set_yticks(range(len(hm.index)));   ax.set_yticklabels(hm.index)
ax.set_xlabel("Sample"); ax.set_ylabel("Species"); ax.set_title("Top 20 species abundance")
plt.colorbar(im, ax=ax).set_label("Relative abundance (%)")
plt.tight_layout()
plt.savefig(f"{OUTDIR}/species_abundance_heatmap.png", dpi=300, bbox_inches="tight")
plt.close()
print(f"Saved: {OUTDIR}/species_abundance_heatmap.png")
