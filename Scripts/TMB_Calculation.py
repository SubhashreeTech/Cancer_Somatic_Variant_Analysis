#!/usr/bin/env python3

import gzip
import pandas as pd

VCF = "results/variants/somatic.filtered.vcf.gz"

EXOME_SIZE_MB = 38

count = 0

with gzip.open(VCF, "rt") as f:
    for line in f:
        if not line.startswith("#"):
            count += 1

tmb = round(count / EXOME_SIZE_MB, 2)

report = pd.DataFrame({
    "Total_Somatic_Variants": [count],
    "Exome_Size_MB": [EXOME_SIZE_MB],
    "TMB_Mutations_per_MB": [tmb]
})

report.to_csv(
    "results/reports/TMB_Report.csv",
    index=False
)

print(f"TMB = {tmb} Mut/Mb")
