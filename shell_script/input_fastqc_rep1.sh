#!/bin/bash
#SBATCH --qos=normal
#SBATCH --array=1-8
#SBATCH --ntasks=1
#SBATCH --job-name=FastqcRep1_%A_%a
#SBATCH --output=/pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/logs_fastqc/rep1_%A_%a.out
#SBATCH --error=/pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/logs_fastqc/rep1_%A_%a.err
#SBATCH --mem=10000

mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/logs_fastqc
mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/REP1_FASTQC

FILES=$(ls /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/Rep1/fastq)
input=$(echo "$FILES" | sed -n "${SLURM_ARRAY_TASK_ID}p")

module load graalvm
module load fastqc

fastqc -o /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/REP1_FASTQC /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/Rep1/fastq/$input