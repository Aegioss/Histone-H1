#!/bin/bash
#SBATCH --qos=normal
#SBATCH --array=25-28
#SBATCH --ntasks=1
#SBATCH --job-name=bigwig
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --output=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/bigwig/logs/output_%A_%a.out
#SBATCH --error=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/bigwig/logs/error_%A_%a.err
#SBATCH --cpus-per-task=16
#SBATCH --mem=50000

mkdir -p /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/bigwig
mkdir -p /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/bigwig/logs

module load deepTools

file=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/output.txt)
real_file=$(echo "$file" | cut -d '.' -f1)
file30="${real_file}MAPQ30.sorted"


bamCoverage --bam /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/Bowtie_MAPQ30/${file30}.bam \
  --binSize 1 \
  --filterRNAstrand forward \
  --normalizeUsing RPKM \
  --outFileFormat bigwig \
  --outFileName /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/bigwig/${real_file}_forward.bw \
  -p 16 &&
  
bamCoverage --bam /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/Bowtie_MAPQ30/${file30}.bam \
  --binSize 1 \
  --filterRNAstrand reverse \
  --normalizeUsing RPKM \
  --outFileFormat bigwig \
  --outFileName /pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/bigwig/${real_file}_reverse.bw \
  -p 16
  
