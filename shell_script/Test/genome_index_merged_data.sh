#!/bin/bash
#SBATCH --qos=normal
#SBATCH --job-name=MergedSTAR
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --output=MergedSTAR%j.out
#SBATCH --error=MergedSTAR%j.err
#SBATCH --cpus-per-task=8
#SBATCH --mem=100000

module load STAR || { echo "Failed loading module STAR"; exit 1; }

STAR --runThreadN 8 \
--runMode genomeGenerate \
--genomeDir DrosoMus_StarIndex \
--genomeFastaFiles merged_droso_mus.fasta \
--sjdbGTFfile merged_droso_mus.gtf || { echo "STAR failed"; exit 2; }

exit 0