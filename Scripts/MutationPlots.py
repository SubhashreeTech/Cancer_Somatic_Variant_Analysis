#!/usr/bin/env python3

import gzip
import pandas as pd
import matplotlib.pyplot as plt

VCF = "results/variants/somatic.filtered.vcf.gz"

snv_types = {
    "C>A": 0,
    "C>G": 0,
    "C>T": 0,
    "T>A": 0,
    "T>C": 0,
    "T>G": 0
}

with gzip.open(VCF, "rt") as f:

    for line in f:

        if line.startswith("#"):
            continue

        fields = line.strip().split("\t")

        ref = fields[3]
        alt = fields[4]

        if len(ref) == 1 and len(alt) == 1:

            mutation = f"{ref}>{alt}"

            if mutation in snv_types:
                snv_types[mutation] += 1

df = pd.DataFrame(
    list(snv_types.items()),
    columns=["Mutation", "Count"]
)

plt.figure(figsize=(8, 5))

plt.bar(
    df["Mutation"],
    df["Count"]
)

plt.title("Mutation Spectrum")

plt.xlabel("SNV Type")

plt.ylabel("Count")

plt.tight_layout()

plt.savefig(
    "results/reports/MutationSpectrum.png",
    dpi=600
)

print("Mutation Spectrum Plot Generated")
