

files <- list.files(path = "/home/franck/SCRATCH/fpan/Genome_Index/chR_index_files/StarFCount/", pattern = "*.txt$", full.names = TRUE)
files
read_counts <- function(file) {
  df <- read.table(file, header = TRUE, sep = "\t", comment.char = "#")
  sample_name <- tools::file_path_sans_ext(basename(file)) 
  df <- df[, c("Geneid", colnames(df)[ncol(df)])] 
  colnames(df)[2] <- sample_name
  return(df)
}

count_list <- lapply(files, read_counts)
merged <- Reduce(function(x, y) merge(x, y, by = "Geneid"), count_list)
rownames(merged) <- merged$Geneid
merged <- merged[, -1]
merged

write.csv(merged, "/home/franck/SCRATCH/fpan/Genome_Index/chR_index_files/STARQ30_counts_matrix.csv")
