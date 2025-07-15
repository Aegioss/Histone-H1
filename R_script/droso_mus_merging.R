# Merging droso and mus musculus data >> Fasta & GTF files
library(Biostrings)
library(GenomicRanges)
library(rtracklayer)

dmel_fa_path <- "/home/franck/Documents/R/dmel-all-chromosome-r6.62.fasta"
dmel_gtf_path <- "/home/franck/Documents/R/dmel-all-r6.62.gtf"
mus_fa_path <- "/home/franck/Documents/R/GRCm38.primary_assembly.genome.fa"
mus_gtf_path <- "/home/franck/Documents/R/gencode.vM25.primary_assembly.annotation.gtf"

dmel_fa <- readDNAStringSet(dmel_fa_path) #read droso fasta file
dmel_gtf <- import(dmel_gtf_path) # read droso gtf file
mus_fa <- readDNAStringSet(mus_fa_path) # read mus fasta file
mus_gtf <- import(mus_gtf_path) # read droso fasta file

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

# From FASTA file names, keep only the tag "ID" as the name for both droso and mus
new_names_dmel <- c()
for( x in names(dmel_fa)){
  extracted_name <-  as.list(unlist(strsplit(x, " ")))[1]
  new_names_dmel <- append(new_names_dmel, paste0("Droso_", extracted_name))
}
names(dmel_fa) <- new_names_dmel
new_names_mus <- c()
for (x in names(mus_fa)){
  extracted_name <- as.list(unlist(strsplit(x, " ")))[1]
  new_names_mus <- append(new_names_mus, extracted_name)
}
names(mus_fa) <- new_names_mus


# Concatenate both FASTA and GTF file together and export it
merged_fa <- c(dmel_fa, mus_fa)
merged_gtf <- suppressWarnings(c(new_dmel_gtf, mus_gtf))
export(merged_fa, "/home/franck/Documents/R/merged_droso_mus.fasta")
export(merged_gtf, "/home/franck/Documents/R/merged_droso_mus.gtf")

names(dmel_fa)

merged_fa
unique(runValue(seqnames(new_dmel_gtf)))
merged_gtf
names(merged_fa)[!(runValue(seqnames(merged_gtf)) %in% names(merged_fa))]

names(dmel_fa)[!(names(dmel_fa) %in% runValue(seqnames(dmel_gtf)))]
unique(runValue(seqnames(mus_gtf)))
