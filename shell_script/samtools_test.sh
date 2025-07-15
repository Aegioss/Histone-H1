#!/bin/bash
#SBATCH --qos=normal
#SBATCH --ntasks=1
#SBATCH --job-name=Sam_test
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --output=logs_align/output_%j.out
#SBATCH --error=logs_align/error_%j.err
#SBATCH --cpus-per-task=10
#SBATCH --mem=32000

module load samtools
module load subread

FILES=$(ls /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/sam_output)
input=$(echo "$FILES" | sed -n "1p")
rna_file=$(basename "$input" | cut -d '.' -f1)

mkdir -p logs_align/
mkdir -p DrosoMusBam/

samtools view -@ 10 \
  -bS /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/sam_output/$input \
  -o /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/DrosoMusBam/${rna_file}.bam &&
  
samtools sort -@ 10 \
  -o /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/DrosoMusBam/${rna_file}.sorted.bam \
  /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/DrosoMusBam/${rna_file}.bam &&
  
samtools index /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/DrosoMusBam/${rna_file}.sorted.bam 