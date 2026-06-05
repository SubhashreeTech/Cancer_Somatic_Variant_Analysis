# Cancer_Somatic_Variant_Analysis
End-to-end WES/WGS cancer somatic variant analysis pipeline for tumor-normal paired samples using GATK Mutect2, VEP annotation, tumor mutational burden calculation, driver gene identification, and clinical interpretation.
# Cancer Somatic Variant Analysis Pipeline

## Overview

An end-to-end cancer genomics workflow for identifying somatic variants from paired tumor-normal Whole Exome Sequencing (WES) or Whole Genome Sequencing (WGS) data.

This pipeline performs quality control, alignment, post-processing, somatic variant discovery, variant annotation, and downstream clinical interpretation using industry-standard cancer genomics tools.

---

## Features

* FastQC & MultiQC quality assessment
* BWA-MEM2 alignment to the reference genome
* Picard duplicate marking
* GATK Base Quality Score Recalibration (BQSR)
* GATK Mutect2 somatic variant calling
* Variant filtering with FilterMutectCalls
* Variant annotation using VEP
* Tumor Mutational Burden (TMB) estimation
* Cancer driver gene identification
* Clinical interpretation using cancer variant databases
* Reproducible Bash-based workflow

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

## Repository Structure

```text
Cancer_Somatic_Variant_Analysis/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── config/
│   └── config.sh
│
├── scripts/
│   └── SomaticVariantPipeline.sh
│
├── workflow/
│   └── workflow.png
│
├── reference/
│
└── results/
    ├── qc/
    ├── alignment/
    ├── variants/
    ├── annotation/
    └── reports/
```

---

## Software Requirements

| Tool     | Version |
| -------- | ------- |
| FastQC   | >= 0.12 |
| MultiQC  | >= 1.20 |
| BWA-MEM2 | >= 2.2  |
| Samtools | >= 1.18 |
| Picard   | >= 3.0  |
| GATK     | >= 4.5  |
| VEP      | >= 111  |
| BCFtools | >= 1.18 |
| Tabix    | >= 1.18 |

---

## Input Files

Tumor and matched normal paired-end FASTQ files:

```text
tumor_R1.fastq.gz
tumor_R2.fastq.gz

normal_R1.fastq.gz
normal_R2.fastq.gz
```

---

## Required Reference Files

The following resources must be specified in `config/config.sh`:

```text
GRCh38.fa
dbsnp.vcf.gz
af-only-gnomad.vcf.gz
pon.vcf.gz
```

### Reference Genome

* GRCh38 / hg38

### Known Variant Resources

* dbSNP
* gnomAD Germline Resource
* Panel of Normals (PoN)

---

## Installation

Clone the repository:

```bash
git clone https://github.com/SubhashreeTech/Cancer_Somatic_Variant_Analysis.git

cd Cancer_Somatic_Variant_Analysis
```

Make scripts executable:

```bash
chmod +x scripts/SomaticVariantPipeline.sh
```

---

## Configuration

Edit:

```bash
config/config.sh
```

Example:

```bash
THREADS=32

REF=/data/reference/GRCh38.fa

DBSNP=/data/reference/dbsnp.vcf.gz

GNOMAD=/data/reference/af-only-gnomad.vcf.gz

PON=/data/reference/pon.vcf.gz
```

Specify software locations:

```bash
FASTQC_BIN=
MULTIQC_BIN=
BWA_BIN=
SAMTOOLS_BIN=
PICARD_BIN=
GATK_BIN=
VEP_BIN=
```

---

## Running the Pipeline

```bash
bash scripts/SomaticVariantPipeline.sh \
tumor_R1.fastq.gz \
tumor_R2.fastq.gz \
normal_R1.fastq.gz \
normal_R2.fastq.gz
```

---

## Pipeline Steps

### 1. Quality Control

Tools:

* FastQC
* MultiQC

Outputs:

```text
results/qc/
```

Generated reports:

* FastQC HTML reports
* MultiQC summary report

---

### 2. Alignment

Tool:

* BWA-MEM2

Output:

```text
tumor.sorted.bam
normal.sorted.bam
```

---

### 3. Duplicate Marking

Tool:

* Picard MarkDuplicates

Output:

```text
tumor.markdup.bam
normal.markdup.bam
```

---

### 4. Base Quality Score Recalibration

Tool:

* GATK

Output:

```text
tumor.recal.bam
normal.recal.bam
```

---

### 5. Somatic Variant Calling

Tool:

* GATK Mutect2

Output:

```text
somatic.vcf.gz
```

---

### 6. Variant Filtering

Tool:

* FilterMutectCalls

Output:

```text
somatic.filtered.vcf.gz
```

---

### 7. Variant Annotation

Tool:

* VEP

Annotations include:

* Gene
* Transcript
* Variant Consequence
* Protein Change
* ClinVar
* COSMIC
* gnomAD

Output:

```text
annotated.vcf
```

---

## Downstream Analyses

### Tumor Mutational Burden (TMB)

Calculates:

```text
Mutations per Megabase (Mut/Mb)
```

Applications:

* Immunotherapy response prediction
* Tumor profiling

---

### Driver Gene Identification

Common cancer genes:

* TP53
* KRAS
* EGFR
* PIK3CA
* BRAF
* PTEN
* APC
* RB1
* IDH1
* ALK

---

### Clinical Interpretation

Clinical annotation databases:

* ClinVar
* COSMIC
* gnomAD
* OncoKB

Applications:

* Precision Oncology
* Biomarker Discovery
* Therapeutic Target Identification

---

## Output Directory

```text
results/
│
├── qc/
│   ├── fastqc/
│   └── multiqc/
│
├── alignment/
│   ├── tumor.recal.bam
│   ├── normal.recal.bam
│   └── metrics/
│
├── variants/
│   ├── somatic.vcf.gz
│   ├── somatic.filtered.vcf.gz
│   └── variant_statistics.txt
│
├── annotation/
│   └── annotated.vcf
│
└── reports/
```

---

## Applications

* Cancer Genomics
* Clinical Genomics
* Precision Oncology
* Biomarker Discovery
* Translational Research
* Tumor Evolution Studies
* WES Analysis
* WGS Analysis

---

## Future Improvements

* CNV Analysis
* Structural Variant Detection
* Mutational Signature Analysis
* MSI Estimation
* HRD Scoring
* Automated Clinical Reporting
* Nextflow Workflow Support
* Docker/Singularity Containers

---

## Citation

If you use this pipeline in your research, please cite the respective software tools:

* FastQC
* MultiQC
* BWA-MEM2
* Picard
* GATK
* VEP

---

## Author

**Subhashree**

Bioinformatics | Cancer Genomics | Clinical Genomics

GitHub: https://github.com/SubhashreeTech

