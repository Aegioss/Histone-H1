#!/bin/bash
#SBATCH --qos=normal
#SBATCH --array=1-28
#SBATCH --ntasks=1
#SBATCH --job-name=BowtieAlign
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --output=logs_align/output_%A_%a.out
#SBATCH --error=logs_align/error_%A_%a.err
#SBATCH --cpus-per-task=10
#SBATCH --mem=32000

module load bowtie2

line1=$(( (SLURM_ARRAY_TASK_ID - 1) * 2 + 1 ))
line2=$(( line1 + 1 ))

input1=$(sed -n "${line1}p" /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/output.txt)
input2=$(sed -n "${line2}p" /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/output.txt)
rna_file=$(echo "$input1" | cut -d '.' -f1)

mkdir -p logs_align/
mkdir -p sam_output/

bowtie2 --threads 10 \
  --very-sensitive \
  -x /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/Bowtie2/chR_MusDroso_index_bowtie \
  -1 /pasteur/appa/scratch/fpan/trimmed_output/$input1 \
  -2 /pasteur/appa/scratch/fpan/trimmed_output/$input2 \
  -S sam_output/$rna_file.sam