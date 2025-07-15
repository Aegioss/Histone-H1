library(rtracklayer)
library(GenomicRanges)

gtf <- import("Documents/R/cat_chR_MusDroso.gtf")

for (id in unique(gtf$gene_id)){
  gene_subset <- gtf[gtf$gene_id==id]
  gene_nb_exons <- sum(gene_subset$type == "exon")
  
  transcript_subset <- gene_subset[gene_subset$type == "transcript"]
  exons_subset <- gene_subset[gene_subset$type == "exon"]
  
  if (gene_nb_exons>1){
    gene_chr <- unique(seqnames(gene_subset))
    gene_ranges <- ranges(gene_subset[gene_subset$type == "gene"])
    g_name <- unique(gene_subset$gene_name)
    
    if (!(any(ranges(transcript_subset) == gene_ranges))){
      new_transcript <- GRanges(seqnames = gene_chr, 
                                ranges = gene_ranges, 
                                type = "transcript", 
                                gene_id = id, 
                                gene_name = g_name)
      
      idx <- tail(which(mcols(gtf)$gene_id == id), 1)
      gtf <- c(gtf[1:idx], new_transcript, gtf[(idx+1):length(gtf)])
    }
    if (!(any(ranges(exons_subset) == gene_ranges))){
      new_exons <- GRanges(seqnames = gene_chr,
                           ranges = gene_ranges, 
                           type = "exon", 
                           gene_id = id, 
                           gene_name = g_name)
      idx <- tail(which(mcols(gtf)$gene_id == id), 1)
      gtf <- c(gtf[1:idx], new_exons, gtf[(idx+1):length(gtf)])
    }
  }
}

gtf <- gtf[order(start(gtf))]
export(gtf, "SCRATCH/fpan/Genome_Index/chR_index_files/chR_TrExAdded.gtf")