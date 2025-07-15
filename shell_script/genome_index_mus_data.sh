#!/bin/bash
#SBATCH --qos=normal
#SBATCH --job-name=MusSTAR
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --output=MusSTAR%j.out
#SBATCH --error=MusSTAR%j.err
#SBATCH --cpus-per-task=8
#SBATCH --mem=100000

module load STAR || { echo "Failed loading module STAR"; exit 1; }

STAR --runThreadN 8 \
--runMode genomeGenerate \
--genomeDir Mus_StarIndex \
--genomeFastaFiles GRCm38.primary_assembly.genome.fa \
--sjdbGTFfile gencode.vM25.primary_assembly.annotation.gtf || { echo "STAR failed"; exit 2; }

exit 0