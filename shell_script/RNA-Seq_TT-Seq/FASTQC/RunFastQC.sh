#!/bin/bash
#SBATCH --qos=fast
#SBATCH --job-name=Fastqc_%A_%a
#SBATCH --output=logs/output_%A_%a.out
#SBATCH --error=logs/error_%A_%a.err
#SBATCH --mem=10000

FILES=$(ls /pasteur/appa/scratch/fpan/Ashish)
input=$(echo "$FILES" | sed -n "${SLURM_ARRAY_TASK_ID}p")

module load graalvm
module load fastqc

fastqc --memory=10000 -o /pasteur/appa/scratch/fpan/Fastqc /pasteur/appa/scratch/fpan/Ashish/$input