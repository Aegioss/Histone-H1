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


txdb <- makeTxDbFromGFF("/home/franck/SCRATCH/fpan/Genome_Index/chR_index_files/AddedMonoExPreMrna_13_06.gtf", format="gtf")
k <- keys(txdb, keytype = "TXNAME")
tx2gene_df <- select(txdb, keys = k, columns = "GENEID", keytype = "TXNAME")
write_csv(tx2gene_df, "/home/franck/SCRATCH/fpan/Genome_Index/chR_index_files/SalmonRNA/QuantOutput_AddedPreMrna/tx2gene.monoExo.filtered.csv")

gtf_mono_exon <- import("/home/franck/SCRATCH/fpan/Genome_Index/chR_index_files/rsem_9_06_25_filtered.gtf")
exons_gtf <- gtf_mono_exon[gtf_mono_exon$type == "exon"]
df_subset <- as.data.frame(exons_gtf)

exon_counts <- df_subset %>%
  group_by(transcript_id) %>%
  summarise(exon_count = n()) %>%
  filter(exon_count == 1)
mono_exon_id <- exon_counts$transcript_id

TrExMrna_gtf <- gtf_mono_exon[gtf_mono_exon$type=="transcript" | gtf_mono_exon$type=="exon" | gtf_mono_exon$type=="mRNA"]
TrExMrna_gtf[TrExMrna_gtf$transcript_id==mono_exon_id[1]]

premrna <- exons_gtf[exons_gtf$transcript_id %in% mono_exon_id]
premrna$type <- "mRNA"
gtf_mono_exon <- c(gtf_mono_exon, premrna)
gtf_mono_exon <- gtf_mono_exon[order(gtf_mono_exon$gene_id,
  gtf_mono_exon$type,
  seqnames(gtf_mono_exon),
  start(ranges(gtf_mono_exon)),
  end(ranges(gtf_mono_exon)))]

export(gtf_mono_exon, "/home/franck/SCRATCH/fpan/Genome_Index/chR_index_files/AddedMonoExPreMrna_13_06.gtf")
