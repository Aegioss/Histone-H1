#!/bin/bash
#SBATCH --qos=normal
#SBATCH --array=1-28
#SBATCH --job-name=Filtering_%A_%a
#SBATCH --output=logs_trimgalore/output_%A_%a.out
#SBATCH --error=logs_trimgalore/error_%A_%a.err
#SBATCH --mem=10000
#SBATCH --cpus-per-task=4

FILES=$(ls /pasteur/appa/scratch/fpan/Ashish)

line1=$(( (SLURM_ARRAY_TASK_ID - 1) * 2 + 1 ))
line2=$(( line1 + 1 ))

input1=$(echo "$FILES" | sed -n "${line1}p")
input2=$(echo "$FILES" | sed -n "${line2}p")

mkdir -p trimmed_output/

module load graalvm
module load fastqc
module load cutadapt
module load TrimGalore

trim_galore --paired \
  --cores 4 \
  --stringency 3 \
  --gzip \
  --fastqc \
  -o trimmed_output/ \
  /pasteur/appa/scratch/fpan/Ashish/$input1 /pasteur/appa/scratch/fpan/Ashish/$input2