#!/bin/bash
#SBATCH --qos=normal
#SBATCH --job-name=ChRStar
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --output=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/logs_Star/ChRStar%j.out
#SBATCH --error=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/logs_Star/ChRStar%j.err
#SBATCH --cpus-per-task=16
#SBATCH --mem=100000

module load STAR 

mkdir -p /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/logs_Star

STAR --runThreadN 16 \
--runMode genomeGenerate \
--genomeDir /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/ChRStarIndex \
--genomeFastaFiles /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/cat_chR_MusDroso.fasta \
--sjdbGTFfile /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/chR_TrExAdded.gtf 
