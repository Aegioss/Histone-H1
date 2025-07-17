#!/bin/bash
#SBATCH --qos=normal
#SBATCH --array=1-28
#SBATCH --job-name=ChRStarFinish
#SBATCH --mail-user=franck.pan@pasteur.fr
#SBATCH --output=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/logs_Star/ChRStarFinish%A%a.out
#SBATCH --error=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files/logs_Star/ChRStarFinish%A%a.err
#SBATCH --cpus-per-task=16
#SBATCH --mem=100000

module load STAR
module load samtools
module load subread

line1=$(( (SLURM_ARRAY_TASK_ID - 1) * 2 + 1 ))
line2=$(( line1 + 1 ))

input1=$(sed -n "${line1}p" /pasteur/appa/scratch/fpan/fastqc_filename.txt)
input2=$(sed -n "${line2}p" /pasteur/appa/scratch/fpan/fastqc_filename.txt)
rna_file=$(echo "$input1" | cut -d '.' -f1)
default_path=/pasteur/appa/scratch/fpan/Genome_Index/chR_index_files

mkdir -p ${default_path}/logs_Star
mkdir -p ${default_path}/StarMapped_bam
mkdir -p ${default_path}/StarFCount

STAR \
--outSAMtype BAM SortedByCoordinate \
--readFilesCommand zcat \
--runThreadN 16 \
--sjdbGTFfile ${default_path}/chR_TrExAdded.gtf \
--genomeDir ${default_path}/ChRStarIndex \
--readFilesIn /pasteur/appa/scratch/fpan/trimmed_output/$input1 /pasteur/appa/scratch/fpan/trimmed_output/$input2 \
--outFileNamePrefix ${default_path}/StarMapped_bam/${rna_file}_Mapped &&

samtools view -b \
  -q 30 \
  ${default_path}/StarMapped_bam/${rna_file}_MappedAligned.sortedByCoord.out.bam > ${default_path}/StarMapped_bam/${rna_file}_MappedAligned_30.sortedByCoord.out.bam &&

featureCounts -T 16 \
  -a ${default_path}/chR_TrExAdded.gtf \
  -o ${default_path}/StarFCount/${rna_file}Star_counts.txt \
  -g gene_id \
  -t exon \
  ${default_path}/StarMapped_bam/${rna_file}_MappedAligned_30.sortedByCoord.out.bam