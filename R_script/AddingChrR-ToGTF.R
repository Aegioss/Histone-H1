library(rtracklayer)
library(GenomicRanges)

gtf_chR <- import("Documents/R/mm10-rDNA_v1.0.gtf")
gtf_mus <- import("Documents/R/gencode.vM25.primary_assembly.annotation.gtf")

gtf_chR <- gtf_chR[seqnames(gtf_chR)=="chrR"]
gtf_split <- split(gtf_chR, gtf_chR$gene_id)

genes <- GRanges()
gene_id <- unique(gtf_chR$gene_id)

for (name in gene_id){
  subset <- gtf_split[[name]]
  tr_row <- subset[subset$type=="transcript"]
  i <- min(start(subset))
  j <- max(end(subset))
  new_gene <- GRanges(
    seqnames = "chrR",
    ranges = IRanges(start = i, end = j),
    strand = strand(tr_row),
    type = "gene",
    gene_id = name
  )
  genes <- c(genes, new_gene)
}
gtf_split
for (name in gene_id){
  print(gtf_split[[name]])
}
gtf_chR <- c(gtf_chR, genes)
gtf_split <- split(gtf_chR, gtf_chR$gene_id)

full_gtf <- suppressWarnings(c(gtf_mus, gtf_chR))

type_order <- c("gene" = 1, "transcript" = 2, "exon" = 3)
type_priority <- type_order[as.character(mcols(full_gtf)$type)]

full_gtf <- full_gtf[order(start(full_gtf), type_priority)]
full_gtf

export(full_gtf, "SCRATCH/fpan/Genome_Index/chR_index_files/chR_Added.gtf")
export(full_gtf, "Documents/R/chR_Added.gtf")
