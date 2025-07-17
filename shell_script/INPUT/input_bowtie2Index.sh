#!/bin/bash
#SBATCH --qos=normal
#SBATCH --ntasks=1
#SBATCH --job-name=BowtieIndex
#SBATCH --output=/pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/logs_BowtieIndex/BowtieIndex_%j.out
#SBATCH --error=/pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/logs_BowtieIndex/BowtieIndex_%j.err
#SBATCH --mem=50000

mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/logs_BowtieIndex/
mkdir -p /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/BowtieIndex

module load bowtie2 

bowtie2-build /pasteur/appa/scratch/fpan/INPUT_WORK/cat_chR_MusDroso.fasta /pasteur/appa/scratch/fpan/INPUT_WORK/H1_TFs_ChIP/BowtieIndex/BowtieIndex 