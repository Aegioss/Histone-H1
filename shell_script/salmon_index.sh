#!/bin/bash
#SBATCH --qos=fast
#SBATCH --job-name=SalmonIndex
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --output=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/SalmonRNA/logs/output_%j.out
#SBATCH --error=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/SalmonRNA/logs/error_%j.err
#SBATCH --cpus-per-task=16
#SBATCH --mem=50000

module load salmon
module load R/3.6.2
module load STAR
module load RSEM

mkdir -p /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/SalmonRNA/logs
mkdir -p /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/SalmonRNA/RSEM_REF_AddedPreMrna
  
rsem-prepare-reference \
            --gtf /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/AddedMonoExPreMrna_13_06.gtf \
            --num-threads 16 \
            /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/cat_chR_MusDroso.fasta \
            /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/SalmonRNA/RSEM_REF_AddedPreMrna/SalmonRNA &&
            
salmon index -t /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/SalmonRNA/RSEM_REF_AddedPreMrna/SalmonRNA.transcripts.fa \
  -i /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/SalmonRNA/SalmonRnaIndexAddedPreMrna \
  -p 16 