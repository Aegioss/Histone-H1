library(Biostrings)
library(rtracklayer)
library(GenomicRanges)

mus_chrR_fa = readDNAStringSet("Genome_Index/mm10-rDNA_v1.0.fa")
gtf = import("/home/franck/SCRATCH/fpan/Genome_Index/merged_droso_mus.gtf")

gtf

mus_chrR_fa

names(mus_chrR_fa)
names(mus_chrR_fa) = gsub("^[^_]*_(.*)", "\\1", names(mus_chrR_fa))
names(mus_chrR_fa)
mus_chrR_fa[gtf]
