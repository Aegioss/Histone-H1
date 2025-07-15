library(Biostrings)
library(rtracklayer)
library(GenomicRanges)

gtf <- import("/home/franck/Documents/R/cat2_chR_MusDroso.gtf")

Genes_transcript <- GRanges()
Genes_exon <- GRanges()
split_gtf <- split(gtf, mcols(gtf)$gene_id)
genes_multiple_exons <- names(Filter(function(x) sum(mcols(x)$type == "exon") > 1, split_gtf))

Gene<-gtf[gtf$type=="gene"]
Gene <- Gene[mcols(Gene)$gene_id %in% genes_multiple_exons]


Genes_transcript <- Gene
Genes_exon <- Gene

Genes_transcript$transcript_id<-paste("PreMrna",Gene$gene_id,sep="")
Genes_transcript$type<-"transcript"
Genes_transcript


Genes_exon$transcript_id<-paste("PreMrna",Gene$gene_id,sep="")
Genes_exon$type<-"exon"
Genes_exon

gtf <- c(gtf, Genes_transcript, Genes_exon)

type_order <- c("gene" = 1, "transcript" = 2, "exon" = 3)

gtf_sorted <- gtf[order(
  mcols(gtf)$gene_id,  
  type_order[mcols(gtf)$type], 
  mcols(gtf)$transcript_id, 
  start(gtf)  
)]


export(gtf_sorted, "/home/franck/SCRATCH/fpan/Genome_Index/chR_index_files/chR_TrExAdded.gtf")
export(gtf_sorted, "/home/franck/Documents/R/chR_TrExAdded.gtf")
