#!/bin/bash
#SBATCH --qos=normal
#SBATCH --array=1-4
#SBATCH --ntasks=1
#SBATCH --job-name=ChipNative
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --output=/pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/logs_align/output_%A_%a.out
#SBATCH --error=/pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/logs_align/error_%A_%a.err
#SBATCH --cpus-per-task=16
#SBATCH --mem=64000

mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/logs_align
mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/sam
mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/bam
mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/bamMapQ30
mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/featureCount
mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/bigwig

module load bowtie2
module load deepTools
module load samtools
module load subread

line1=$(( (SLURM_ARRAY_TASK_ID - 1) * 2 + 1 ))
line2=$(( line1 + 1 ))

input1=$(sed -n "${line1}p" /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/output.txt)
input2=$(sed -n "${line2}p" /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/output.txt)
file_name=$(echo "$input1" | sed 's/_R1_001.*//')

bowtie2 --threads 16 \
  --very-sensitive \
  -x /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/BowtieIndex/BowtieIndex  \
  -1 /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/fastq/$input1 \
  -2 /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/fastq/$input2 \
  -S /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/sam/${file_name}.sam &&

samtools view -@ 16 \
  -bS /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/sam/${file_name}.sam \
  -o /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/bam/${file_name}.bam &&

samtools view -b \
  -q 30 \
  /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/bam/${file_name}.bam > /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/bamMapQ30/${file_name}_MAPQ30.bam &&

samtools sort -@ 16 \
  -o /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/bamMapQ30/${file_name}_MAPQ30.sorted.bam \
  /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/bamMapQ30/${file_name}_MAPQ30.bam &&
  
samtools index /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/bamMapQ30/${file_name}_MAPQ30.sorted.bam &&

featureCounts -T 16 \
  -a /pasteur/appa/scratch/fpan/INPUT_WORK/chR_TrExAdded.gtf \
  -o /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/featureCount/${file_name}.txt \
  -g gene_id \
  -t exon \
   /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/bamMapQ30/${file_name}_MAPQ30.sorted.bam  &&

bamCoverage --bam /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/bamMapQ30/${file_name}_MAPQ30.sorted.bam  \
  --binSize 1 \
  --filterRNAstrand forward \
  --normalizeUsing RPKM \
  --outFileFormat bigwig \
  --outFileName /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/bigwig/${file_name}_FW.bw \
  -p 16 &&
  
bamCoverage --bam /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/bamMapQ30/${file_name}_MAPQ30.sorted.bam  \
  --binSize 1 \
  --filterRNAstrand reverse \
  --normalizeUsing RPKM \
  --outFileFormat bigwig \
  --outFileName /pasteur/appa/scratch/fpan/INPUT_WORK/H1_ChIP_Native/bigwig/${file_name}_RV.bw \
  -p 16
  