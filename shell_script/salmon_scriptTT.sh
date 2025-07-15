#!/bin/bash
#SBATCH --qos=normal
#SBATCH --array=13-24
#SBATCH --ntasks=1
#SBATCH --job-name=SalmonTT
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --output=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/SalmonTT/logs/output_%A_%a.out
#SBATCH --error=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/SalmonTT/logs/error_%A_%a.err
#SBATCH --cpus-per-task=16
#SBATCH --mem=50000

mkdir -p /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/SalmonTT/logs

module load salmon

line1=$(( (SLURM_ARRAY_TASK_ID - 1) * 2 + 1 ))
line2=$(( line1 + 1 ))

input1=$(sed -n "${line1}p" /pasteur/appa/scratch/fpan/fastqc_filename.txt)
input2=$(sed -n "${line2}p" /pasteur/appa/scratch/fpan/fastqc_filename.txt)
rna_file=$(echo "$input1" | cut -d '.' -f1)

salmon quant -i /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/SalmonTT/SalmonTTIndex -l A \
         -1  /pasteur/appa/scratch/fpan/trimmed_output/$input1 \
         -2  /pasteur/appa/scratch/fpan/trimmed_output/$input2 \
         -p 16 \
         -o /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/SalmonTT/QuantOutput/${rna_file}_quant