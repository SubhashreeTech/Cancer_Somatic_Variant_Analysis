#!/bin/bash

##############################################################################
# Cancer Somatic Variant Analysis Pipeline
# Author: Subhashree
##############################################################################

set -e
set -o pipefail

#############################
# CONFIGURATION
#############################

THREADS=32

REF="reference/GRCh38.fa"

DBSNP="reference/dbsnp.vcf.gz"

GNOMAD="reference/af-only-gnomad.vcf.gz"

PON="reference/pon.vcf.gz"

TUMOR_R1=$1
TUMOR_R2=$2

NORMAL_R1=$3
NORMAL_R2=$4

OUTDIR="results"

mkdir -p ${OUTDIR}/{qc,alignment,variants,annotation,reports}

echo "Pipeline Started"
date

##############################################################################
# STEP 1 - FASTQC
##############################################################################

echo "Running FastQC..."

fastqc \
${TUMOR_R1} \
${TUMOR_R2} \
${NORMAL_R1} \
${NORMAL_R2} \
-o ${OUTDIR}/qc \
-t ${THREADS}

##############################################################################
# STEP 2 - MULTIQC
##############################################################################

echo "Running MultiQC..."

multiqc \
${OUTDIR}/qc \
-o ${OUTDIR}/qc

##############################################################################
# STEP 3 - ALIGNMENT
##############################################################################

echo "Aligning Tumor..."

bwa-mem2 mem \
-t ${THREADS} \
${REF} \
${TUMOR_R1} \
${TUMOR_R2} | \
samtools sort -@ ${THREADS} \
-o ${OUTDIR}/alignment/tumor.sorted.bam

samtools index \
${OUTDIR}/alignment/tumor.sorted.bam

echo "Aligning Normal..."

bwa-mem2 mem \
-t ${THREADS} \
${REF} \
${NORMAL_R1} \
${NORMAL_R2} | \
samtools sort -@ ${THREADS} \
-o ${OUTDIR}/alignment/normal.sorted.bam

samtools index \
${OUTDIR}/alignment/normal.sorted.bam

##############################################################################
# STEP 4 - MARK DUPLICATES
##############################################################################

echo "Marking Duplicates..."

picard MarkDuplicates \
I=${OUTDIR}/alignment/tumor.sorted.bam \
O=${OUTDIR}/alignment/tumor.markdup.bam \
M=${OUTDIR}/alignment/tumor.metrics.txt

picard MarkDuplicates \
I=${OUTDIR}/alignment/normal.sorted.bam \
O=${OUTDIR}/alignment/normal.markdup.bam \
M=${OUTDIR}/alignment/normal.metrics.txt

samtools index ${OUTDIR}/alignment/tumor.markdup.bam
samtools index ${OUTDIR}/alignment/normal.markdup.bam

##############################################################################
# STEP 5 - BQSR
##############################################################################

echo "Running BQSR..."

gatk BaseRecalibrator \
-R ${REF} \
-I ${OUTDIR}/alignment/tumor.markdup.bam \
--known-sites ${DBSNP} \
-O tumor.recal.table

gatk ApplyBQSR \
-R ${REF} \
-I ${OUTDIR}/alignment/tumor.markdup.bam \
--bqsr-recal-file tumor.recal.table \
-O ${OUTDIR}/alignment/tumor.recal.bam

gatk BaseRecalibrator \
-R ${REF} \
-I ${OUTDIR}/alignment/normal.markdup.bam \
--known-sites ${DBSNP} \
-O normal.recal.table

gatk ApplyBQSR \
-R ${REF} \
-I ${OUTDIR}/alignment/normal.markdup.bam \
--bqsr-recal-file normal.recal.table \
-O ${OUTDIR}/alignment/normal.recal.bam

##############################################################################
# STEP 6 - SOMATIC CALLING
##############################################################################

echo "Running Mutect2..."

gatk Mutect2 \
-R ${REF} \
-I ${OUTDIR}/alignment/tumor.recal.bam \
-I ${OUTDIR}/alignment/normal.recal.bam \
-tumor Tumor \
-normal Normal \
--germline-resource ${GNOMAD} \
--panel-of-normals ${PON} \
-O ${OUTDIR}/variants/somatic.vcf.gz

##############################################################################
# STEP 7 - FILTER MUTECT CALLS
##############################################################################

echo "Filtering Variants..."

gatk FilterMutectCalls \
-V ${OUTDIR}/variants/somatic.vcf.gz \
-R ${REF} \
-O ${OUTDIR}/variants/somatic.filtered.vcf.gz

##############################################################################
# STEP 8 - VEP ANNOTATION
##############################################################################

echo "Annotating Variants..."

vep \
-i ${OUTDIR}/variants/somatic.filtered.vcf.gz \
-o ${OUTDIR}/annotation/annotated.vcf \
--cache \
--assembly GRCh38 \
--everything \
--fork 8

##############################################################################
# STEP 9 - PYTHON ANALYSIS
##############################################################################

python3 scripts/TMB_Calculation.py
python3 scripts/DriverGeneAnalysis.py
python3 scripts/ClinicalInterpretation.py
python3 scripts/MutationPlots.py

echo "Pipeline Finished"
date


