#!/usr/bin/env python3

import pandas as pd

ANNOTATED_VCF = "results/annotation/annotated.vcf"

KEYWORDS = [
    "pathogenic",
    "likely_pathogenic",
    "ClinVar",
    "COSMIC"
]

results = []

with open(ANNOTATED_VCF) as f:

    for line in f:

        if line.startswith("#"):
            continue

        if any(
            keyword.lower() in line.lower()
            for keyword in KEYWORDS
        ):
            results.append(line.strip())

df = pd.DataFrame(
    {"Clinical_Variant": results}
)

df.to_csv(
    "results/reports/Clinical_Variants.csv",
    index=False
)

print(
    f"Identified {len(results)} clinically relevant variants"
)
