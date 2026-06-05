#!/usr/bin/env python3

import pandas as pd

ANNOTATED_VCF = "results/annotation/annotated.vcf"

DRIVER_GENES = [
    "TP53",
    "KRAS",
    "EGFR",
    "PIK3CA",
    "BRAF",
    "PTEN",
    "APC",
    "RB1",
    "IDH1",
    "ALK"
]

hits = []

with open(ANNOTATED_VCF) as f:
    for line in f:

        if line.startswith("#"):
            continue

        for gene in DRIVER_GENES:
            if gene in line:
                hits.append(gene)

if len(hits) == 0:
    pd.DataFrame(
        {"Gene": [], "Mutation_Count": []}
    ).to_csv(
        "results/reports/Driver_Genes.csv",
        index=False
    )

else:

    df = pd.Series(hits).value_counts()

    df = df.reset_index()

    df.columns = ["Gene", "Mutation_Count"]

    df.to_csv(
        "results/reports/Driver_Genes.csv",
        index=False
    )

print("Driver Gene Analysis Completed")
