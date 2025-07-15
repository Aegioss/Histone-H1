#!/bin/bash
#SBATCH --qos=normal
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --job-name=FAI
#SBATCH --output=log/fai_%j.out
#SBATCH --error=log/fai_%j.err
#SBATCH --cpus-per-task=1
#SBATCH --mem=16000

module load samtools

samtools faidx /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/cat_chR_MusDroso.fasta
