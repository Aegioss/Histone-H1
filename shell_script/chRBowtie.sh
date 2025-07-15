#!/bin/bash
#SBATCH --qos=normal
#SBATCH --job-name=chRBowtie
#SBATCH --mail-type=ALL
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --output=logs/chRBowtie%j.out
#SBATCH --error=logs/chRBowtie%j.err
#SBATCH --mem=100000

module load bowtie2 

bowtie2-build cat_chR_MusDroso.fasta chR_MusDroso_index_bowtie;
