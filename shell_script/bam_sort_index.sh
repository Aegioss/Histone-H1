#!/bin/bash
#SBATCH --qos=normal
#SBATCH --array=2-28
#SBATCH --ntasks=1
#SBATCH --job-name=SamToBam
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --output=logs_align/output_%A_%a.out
#SBATCH --error=logs_align/error_%A_%a.err
#SBATCH --cpus-per-task=10
#SBATCH --mem=32000

module load samtools
module load subread

FILES=$(ls /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/sam_output)
input=$(echo "$FILES" | sed -n "${SLURM_ARRAY_TASK_ID}p")
rna_file=$(basename "$input" | cut -d '.' -f1)

mkdir -p logs_align/
mkdir -p DrosoMusBam/

samtools view -@ 8 \
  -bS /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/sam_output/$input \
  -o /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/DrosoMusBam/${rna_file}.bam &&
  
samtools sort -@ 8 \
  -o /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/DrosoMusBam/${rna_file}.sorted.bam \
  /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/DrosoMusBam/${rna_file}.bam &&
  
samtools index /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/DrosoMusBam/${rna_file}.sorted.bam 


