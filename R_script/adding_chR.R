library(Biostrings)
library(rtracklayer)
library(GenomicRanges)


dmel_fa <- readDNAStringSet("Documents/R/dmel-all-chromosome-r6.62.fasta")
dmel_gtf <- import("Documents/R/dmel-all-r6.62.gtf")
mus_chrR_fa = readDNAStringSet("Documents/R/mm10-rDNA_v1.0.fa")
mus_gtf = import("Documents/R/chR_Added.gtf")


names(mus_chrR_fa) <- gsub("^[^_]*_([^_]*).*", "\\1", names(mus_chrR_fa))
names(mus_chrR_fa) <- ifelse(grepl("^(GL|JH)", names(mus_chrR_fa)), paste0(names(mus_chrR_fa), ".1"), names(mus_chrR_fa))

names(dmel_fa)
names(dmel_fa) <- paste0("Droso_", gsub(" .*$", "", names(dmel_fa)))

# Retrieve every value from seqnames of droso gtf file to add flag "Droso_" before
# Recreate a Rle to use for the new Granges object
# Copy old gtf with the new Rle with flagged names
new_values <- unlist(lapply("Droso_", paste0, runValue(seqnames(dmel_gtf))))
new_values <- new_values
new_seqnames <- Rle(new_values, runLength(seqnames(dmel_gtf)))
new_dmel_gtf <- GRanges(new_seqnames,
                        ranges(dmel_gtf, use.mcols=TRUE),
                        strand=strand(dmel_gtf))

# Rename column "gene_symbol" as "gene_name"
# Add flag "Droso_" before each "gene_id" and "gene_name"
names(mcols(new_dmel_gtf))[names(mcols(dmel_gtf)) == "gene_symbol"] <- "gene_name"
new_droso_id <- unlist(lapply("Droso_", paste0, mcols(new_dmel_gtf)$gene_id))
new_droso_gene_name <- unlist(lapply("Droso_", paste0, mcols(new_dmel_gtf)$gene_name))
mcols(new_dmel_gtf)$gene_id <- new_droso_id
mcols(new_dmel_gtf)$gene_name <- new_droso_gene_name

seqlengths(mus_chrR_fa["chrR"])
idx <- which(seqnames(mus_gtf) == "chrR")
end(mus_gtf[477:479]) <- c(45306,45306,45306)



mus_chrR_fa["chrR"]
mus_chrR_fa[mus_gtf]
dmel_fa[new_dmel_gtf]



# Concatenate both FASTA and GTF file together and export it
cat_fa <- c(mus_chrR_fa, dmel_fa)
cat_gtf <- suppressWarnings(c(mus_gtf, new_dmel_gtf))

cat_fa[cat_gtf]

export(cat_fa, "Documents/R/cat2_chR_MusDroso.fasta")
export(cat_gtf, "Documents/R/cat2_chR_MusDroso.gtf")

cat_gtf
mus_chrR_fa
