#!/bin/bash
#SBATCH --job-name=MusBowtie
#SBATCH --mail-user="franck.pan@pasteur.fr"
#SBATCH --output=MusBowtie%j.out
#SBATCH --error=MusBowtie%j.err
#SBATCH --mem=100000

module load bowtie2 

bowtie2-build GRCm38.primary_assembly.genome.fa mus_index_bowtie;
