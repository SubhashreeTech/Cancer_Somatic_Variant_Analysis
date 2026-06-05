# Cancer_Somatic_Variant_Analysis
End-to-end WES/WGS cancer somatic variant analysis pipeline for tumor-normal paired samples using GATK Mutect2, VEP annotation, tumor mutational burden calculation, driver gene identification, and clinical interpretation.
# Cancer Somatic Variant Analysis Pipeline

## Overview

An end-to-end cancer genomics workflow for identifying somatic variants from paired tumor-normal Whole Exome Sequencing (WES) or Whole Genome Sequencing (WGS) data.

The pipeline performs:

- Quality Control
- Alignment
- Duplicate Marking
- Base Quality Score Recalibration
- Somatic Variant Calling
- Variant Filtering
- Functional Annotation
- Tumor Mutational Burden Analysis
- Driver Gene Identification
- Clinical Interpretation

---

## Workflow

```text
FASTQ
 │
 ▼
FastQC
 │
 ▼
MultiQC
 │
 ▼
BWA-MEM2
 │
 ▼
Picard MarkDuplicates
 │
 ▼
GATK BQSR
 │
 ▼
GATK Mutect2
 │
 ▼
FilterMutectCalls
 │
 ▼
VEP Annotation
 │
 ▼
TMB Analysis
 │
 ▼
Driver Gene Analysis
 │
 ▼
Clinical Interpretation
```

---

## Software Requirements

| Tool | Version |
|--------|--------|
| FastQC | >=0.12 |
| MultiQC | >=1.20 |
| BWA-MEM2 | >=2.2 |
| Samtools | >=1.18 |
| Picard | >=3.0 |
| GATK | >=4.5 |
| VEP | >=111 |
| Python | >=3.10 |

---

## Installation

Clone repository:

```bash
git clone https://github.com/SubhashreeTech/Cancer_Somatic_Variant_Analysis.git

cd Cancer_Somatic_Variant_Analysis
```

---

## Running Pipeline

```bash
bash scripts/SomaticVariantPipeline.sh \
tumor_R1.fastq.gz \
tumor_R2.fastq.gz \
normal_R1.fastq.gz \
normal_R2.fastq.gz
```

---

## Output Files

```text
results/
├── qc/
├── alignment/
├── variants/
├── annotation/
└── reports/
```

---

## Downstream Analyses

### Tumor Mutational Burden (TMB)

Calculates:

```text
Mutations per Megabase
```

### Driver Gene Analysis

Detects mutations in:

- TP53
- KRAS
- EGFR
- PIK3CA
- BRAF
- PTEN
- APC

### Clinical Interpretation

Uses annotations from:

- ClinVar
- COSMIC
- gnomAD
- OncoKB

---

## Applications

- Precision Oncology
- Clinical Genomics
- Cancer Research
- Biomarker Discovery
- Tumor Evolution Studies

---

## Author

Subhashree

Bioinformatics | Cancer Genomics | Clinical Genomics
