#!/bin/bash
#SBATCH --qos=normal
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --job-name=RNAseq
#SBATCH --output=log/rnaseq_%j.out
#SBATCH --error=log/rnaseq_%j.err
#SBATCH --cpus-per-task=16
#SBATCH --mem=50000

mkdir -p log

source /pasteur/appa/homes/fpan/miniconda3/etc/profile.d/conda.sh

conda activate nfcore_env

nextflow run rnaseq -profile conda \
  --input Ashish.SampleSheet.csv \
  --fasta /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/cat_chR_MusDroso.fasta \
  --gtf /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/AddedMonoExPreMrna_13_06.gtf \
  -c myconfig.config \
  -with-report report.html -with-trace trace.txt
