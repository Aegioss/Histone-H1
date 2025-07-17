#!/bin/bash
#SBATCH --qos=normal
#SBATCH --array=1-28
#SBATCH --ntasks=1
#SBATCH --job-name=BamMAPQ30
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --output=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/logs_BamMAPQ30/BamMAPQ30_%A_%a.out
#SBATCH --error=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/logs_BamMAPQ30/BamMAPQ30_%A_%a.err
#SBATCH --cpus-per-task=16
#SBATCH --mem=100000

module load samtools
module load subread

default_path=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files
input=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${default_path}/output.txt)
rna_file=$(basename "$input" | cut -d '.' -f1)

mkdir -p ${default_path}/BowtieFCount_MAPQ30
mkdir -p ${default_path}/logs_BamMAPQ30
mkdir -p ${default_path}/Bowtie_MAPQ30

samtools view -b \
  -q 30 \
  ${default_path}/DrosoMusBam/${rna_file}.sorted.bam > ${default_path}/Bowtie_MAPQ30/${rna_file}MAPQ30.sorted.bam &&
  
samtools index ${default_path}/Bowtie_MAPQ30/${rna_file}MAPQ30.sorted.bam &&
  
featureCounts -T 16 \
  -a ${default_path}/chR_TrExAdded.gtf \
  -o ${default_path}/BowtieFCount_MAPQ30/${rna_file}BCount30.txt \
  -g gene_id \
  -t exon \
   ${default_path}/Bowtie_MAPQ30/${rna_file}MAPQ30.sorted.bam 