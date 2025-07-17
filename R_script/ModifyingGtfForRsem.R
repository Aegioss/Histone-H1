library(GenomicRanges)
library(rtracklayer)
library(dplyr)
library(txdbmaker)
library(readr)

gtf <- import("/home/franck/SCRATCH/fpan/Genome_Index/chR_index_files/chR_TrExAdded.gtf")


exons <- gtf[gtf$type == "exon"]
exon_df <- as.data.frame(exons)
strand_counts <- exon_df %>%
  group_by(transcript_id) %>%
  summarise(unique_strands = n_distinct(strand)) %>%
  filter(unique_strands > 1)
bad_tx <- strand_counts$transcript_id


gtf_filtered <- gtf[!(gtf$transcript_id %in% bad_tx)]
gtf_filtered <- gtf_filtered[!(strand(gtf_filtered)=="*")]


export(gtf_filtered, "/home/franck/SCRATCH/fpan/Genome_Index/chR_index_files/rsem_9_06_25_filtered.gtf")



