library(DESeq2)

df <- read.csv("/home/franck/SCRATCH/fpan/Genome_Index/chR_index_files/combined_counts_matrix.csv", header = TRUE, sep = ",")

data <- read.csv("/home/franck/SCRATCH/fpan/Genome_Index/chR_index_files/combined_counts_matrix.csv", header = TRUE, sep = ",")
rownames(data) <- data$X
data <- data[, -1]

countMatrix <- as.matrix(data)

countMatrix

is_droso <- grepl("^Droso_", df$X)
is_droso
result <- data.frame(Sample = colnames(df)[-1], Sum_Droso = NA, Sum_Mus = NA, Ratio = NA, PercMus = NA)
for (i in 2:ncol(df)) {
  result$Sum_Droso[i - 1] <- sum(df[is_droso, i], na.rm = TRUE)
  result$Sum_Mus[i - 1] <- sum(df[!is_droso, i], na.rm = TRUE)
  result$Ratio[i - 1] <- result$Sum_Mus[i - 1]/result$Sum_Droso[i - 1]
  result$PercMus[i - 1] <- (result$Sum_Mus[i - 1]*100)/(result$Sum_Mus[i - 1]+result$Sum_Droso[i - 1])
}
result

pca_data <- t(countMatrix)
gene_vars <- apply(pca_data, 2, var)
pca_data_filtered <- pca_data[, gene_vars > 0]
pca_data_filtered
pca_result <- prcomp(pca_data_filtered, scale. = TRUE)
pca_result

var_explained <- (pca_result$sdev)^2 / sum(pca_result$sdev^2)
barplot(var_explained[1:28],
        names.arg = paste0("PC", 1:28),
        las = 2,
        col = "grey",
        main = "Explained Variance",
        ylab = "Proportion of Explained Variance")

plot(pca_result$x[,1], pca_result$x[,2],
     xlab = "PC1",
     ylab = "PC2",
     pch = 5)
text(pca_result$x[25:28,1], pca_result$x[25:28,2], rownames(
  pca_result$x[25:28,]))

text(pca_result$x[1:12,1], pca_result$x[1:12,2], rownames(
  pca_result$x[1:12,]))
