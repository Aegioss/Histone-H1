#!/bin/bash
#SBATCH --qos=fast
#SBATCH --job-name=Fastqc
#SBATCH --output=Fastqc%j.out
#SBATCH --error=Fastqc%j.err
#SBATCH --mem=10000

module load graalvm
module load fastqc

fastqc --memory=10000 -o /pasteur/appa/scratch/fpan/Fastqc /pasteur/appa/scratch/fpan/Ashish/RNA_S11589Nr97.2.fastq.gz