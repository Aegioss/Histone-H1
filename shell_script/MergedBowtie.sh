#!/bin/bash
#SBATCH --job-name=MergedBowtie
#SBATCH --mail-user="franck.pan@pasteur.fr"
#SBATCH --output=MergedBowtie%j.out
#SBATCH --error=MergedBowtie%j.err
#SBATCH --mem=100000

module load bowtie2 

bowtie2-build merged_droso_mus.fasta merged_index_bowtie;
