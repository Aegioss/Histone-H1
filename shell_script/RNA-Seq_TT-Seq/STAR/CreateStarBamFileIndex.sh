#!/bin/bash
#SBATCH --qos=normal
#SBATCH --array=1-28
#SBATCH --ntasks=1
#SBATCH --job-name=StarIndex
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --output=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/logs_Star/StarIndex%A%a.out
#SBATCH --error=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/logs_Star/StarIndex%A%a.err
#SBATCH --mem=32000


module load samtools


input=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/output.txt)
rna_file=$(basename "$input" | cut -d '.' -f1)
default_path=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files

samtools index ${default_path}/StarMapped_bam/${rna_file}_MappedAligned_30.sortedByCoord.out.bam 