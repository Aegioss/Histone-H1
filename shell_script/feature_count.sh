#!/bin/bash
#SBATCH --qos=normal
#SBATCH --array=1-28
#SBATCH --ntasks=1
#SBATCH --job-name=DimCount
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --output=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/logs_FCount/output_%A_%a.out
#SBATCH --error=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/logs_FCount/error_%A_%a.err
#SBATCH --cpus-per-task=10
#SBATCH --mem=32000

module load subread

mkdir -p /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/logs_FCount
mkdir -p /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/FeatureCount

input=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/output.txt)
rna_file=$(basename "$input" | cut -d '.' -f1)

featureCounts -T 10 \
  -a /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/chR_TrExAdded.gtf \
  -o /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/FeatureCount/${rna_file}_gene_counts.txt \
  -p \
  -t exon \
  -g gene_id \
  /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/DrosoMusBam/${rna_file}.sorted.bam