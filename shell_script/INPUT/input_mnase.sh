#!/bin/bash
#SBATCH --qos=normal
#SBATCH --array=1-6
#SBATCH --ntasks=1
#SBATCH --job-name=Mnase
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --output=/pasteur/appa/scratch/fpan/INPUT_WORK/H1_MNase/logs/output_%A_%a.out
#SBATCH --error=/pasteur/appa/scratch/fpan/INPUT_WORK/H1_MNase/logs/error_%A_%a.err
#SBATCH --cpus-per-task=16
#SBATCH --mem=64000

mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_MNase/logs
mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_MNase/bamSortedMapQ20
mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_MNase/featureCount
mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_MNase/bigwig

module load deepTools
module load samtools
module load subread

input=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /pasteur/appa/scratch/fpan/INPUT_WORK/H1_MNase/output.txt)
file_name=$(echo "$input" | sed 's/_mapq20.*//')

samtools sort -@ 16 \
  -o /pasteur/appa/scratch/fpan/INPUT_WORK/H1_MNase/bamSortedMapQ20/${file_name}_MAPQ20.sorted.bam \
  /pasteur/appa/scratch/fpan/INPUT_WORK/H1_MNase/bam/${input} &&
  
samtools index /pasteur/appa/scratch/fpan/INPUT_WORK/H1_MNase/bamSortedMapQ20/${file_name}_MAPQ20.sorted.bam &&

featureCounts -T 16 \
  -a /pasteur/appa/scratch/fpan/INPUT_WORK/chR_TrExAdded.gtf \
  -o /pasteur/appa/scratch/fpan/INPUT_WORK/H1_MNase/featureCount/${file_name}.txt \
  -g gene_id \
  -t exon \
   /pasteur/appa/scratch/fpan/INPUT_WORK/H1_MNase/bamSortedMapQ20/${file_name}_MAPQ20.sorted.bam  &&

bamCoverage --bam /pasteur/appa/scratch/fpan/INPUT_WORK/H1_MNase/bamSortedMapQ20/${file_name}_MAPQ20.sorted.bam  \
  --binSize 1 \
  --filterRNAstrand forward \
  --normalizeUsing RPKM \
  --outFileFormat bigwig \
  --outFileName /pasteur/appa/scratch/fpan/INPUT_WORK/H1_MNase/bigwig/${file_name}_FW.bw \
  -p 16 &&
  
bamCoverage --bam /pasteur/appa/scratch/fpan/INPUT_WORK/H1_MNase/bamSortedMapQ20/${file_name}_MAPQ20.sorted.bam  \
  --binSize 1 \
  --filterRNAstrand reverse \
  --normalizeUsing RPKM \
  --outFileFormat bigwig \
  --outFileName /pasteur/appa/scratch/fpan/INPUT_WORK/H1_MNase/bigwig/${file_name}_RV.bw \
  -p 16
  