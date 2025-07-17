library(GenomicRanges)
library(rtracklayer)
library(dplyr)
library(txdbmaker)
library(readr)


txdb <- makeTxDbFromGFF("/home/franck/SCRATCH/fpan/Genome_Index/chR_index_files/rsem_9_06_25_filtered.gtf", format="gtf")
k <- keys(txdb, keytype = "TXNAME")
tx2gene_df <- select(txdb, keys = k, columns = "GENEID", keytype = "TXNAME")
write_csv(tx2gene_df, "/home/franck/SCRATCH/fpan/Genome_Index/chR_index_files/SalmonRNA/QuantOutput_gcBias/tx2gene.rsem.filtered.csv")