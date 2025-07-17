#!/bin/bash
#SBATCH --qos=normal
#SBATCH --array=1-8
#SBATCH --ntasks=1
#SBATCH --job-name=BowtieAlign
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --output=/pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/logs_align/output_%A_%a.out
#SBATCH --error=/pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/logs_align/error_%A_%a.err
#SBATCH --cpus-per-task=16
#SBATCH --mem=64000

mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/logs_align
mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/sam
mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/bam
mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/bamMapQ30
mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/featureCount
mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/bigwig

module load bowtie2
module load deepTools
module load samtools
module load subread

line1=$(( (SLURM_ARRAY_TASK_ID - 1) * 2 + 1 ))
line2=$(( line1 + 1 ))

input1=$(sed -n "${line1}p" /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/output.txt)
input2=$(sed -n "${line2}p" /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/output.txt)
file_name=$(echo "$input1" | sed 's/_DSG.*//')

bowtie2 --threads 16 \
  --very-sensitive \
  -x /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/BowtieIndex/BowtieIndex \
  -1 /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/fastq/$input1 \
  -2 /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/fastq/$input2 \
  -S /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/sam/${file_name}.sam &&

samtools view -@ 16 \
  -bS /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/sam/${file_name}.sam \
  -o /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/bam/${file_name}.bam &&

samtools view -b \
  -q 30 \
  /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/bam/${file_name}.bam > /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/bamMapQ30/${file_name}_MAPQ30.bam &&

samtools sort -@ 16 \
  -o /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/bamMapQ30/${file_name}_MAPQ30.sorted.bam \
  /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/bamMapQ30/${file_name}_MAPQ30.bam &&
  
samtools index /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/bamMapQ30/${file_name}_MAPQ30.sorted.bam &&

featureCounts -T 16 \
  -a /pasteur/appa/scratch/fpan/INPUT_WORK/chR_TrExAdded.gtf \
  -o /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/featureCount/${file_name}.txt \
  -g gene_id \
  -t exon \
   /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/bamMapQ30/${file_name}_MAPQ30.sorted.bam  &&

bamCoverage --bam /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/bamMapQ30/${file_name}_MAPQ30.sorted.bam  \
  --binSize 1 \
  --filterRNAstrand forward \
  --normalizeUsing RPKM \
  --outFileFormat bigwig \
  --outFileName /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/bigwig/${file_name}_FW.bw \
  -p 16 &&
  
bamCoverage --bam /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/bamMapQ30/${file_name}_MAPQ30.sorted.bam  \
  --binSize 1 \
  --filterRNAstrand reverse \
  --normalizeUsing RPKM \
  --outFileFormat bigwig \
  --outFileName /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/bigwig/${file_name}_RV.bw \
  -p 16
  
