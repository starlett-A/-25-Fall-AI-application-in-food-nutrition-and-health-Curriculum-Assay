

# data processing
# Date:2025-12-29

# 1. Loading necessary packages -------------------------------------------------
library(ropls)   # Core analysis package
library(ggplot2) # Picturing package
library(dplyr)   # Data processing package

setwd("D:/R_homework")

# 2. Reading Data ----------------------------------------------------------
cat("\n1. Data reading...\n")
file_path <- "D:/R_homework/Combined_PosNeg_Metabolite_Data.csv"

if (!file.exists(file_path)) {
  stop(paste("❌ File not exist! Reassure path:" , file_path))
}

# Read data, supposing first column as metabolite names 
data_df <- read.csv(file_path, stringsAsFactors = FALSE, 
                    check.names = FALSE, row.names = 1)
cat(" Successfully read! Data dimension:", dim(data_df), "(Metabolite × Sample)\n")


cat("\n2. Data processing...\n") 

# Transpose: rows as samples, columns as metabolites
data_matrix <- t(as.matrix(data_df))
cat("  Transpose done. Dimension (Sample × Metabolite):", dim(data_matrix), "\n")

# 2.1 Checking and Fixing ZEROs
cat("  a. Checking and Fixing ZEROs...\n") 
zero_count <- sum(data_matrix == 0, na.rm = TRUE)
zero_percent <- round(100 * zero_count / length(data_matrix), 1)
cat(sprintf("    Count of ZEROs in my data: %d (%.1f%%)\n", zero_count, zero_percent))

if(zero_percent > 0) {
  # Fill up ZERO value with 1/2 of the non-ZEOR minimum value
  # Find the non-ZERO in every row first
  row_min_nonzero <- apply(data_matrix, 1, function(x) {
    non_zero_values <- x[x > 0]  # Consider the positive value only
    if(length(non_zero_values) > 0) {
      return(min(non_zero_values))
    } else {
      return(1)  # All being ZERO or negative values, use 1 as default
    }
  })
  
  # Fill up ZERO values with 1/2 of the non-ZEOR minimum value in every row 
  for(i in 1:nrow(data_matrix)) {
    zero_indices <- which(data_matrix[i, ] == 0)
    if(length(zero_indices) > 0) {
      replacement_value <- row_min_nonzero[i] / 2
      data_matrix[i, zero_indices] <- replacement_value
    }
  }
  cat("    Done with filling up ZERO values with 1/2 of the non-ZEOR minimum value in every row \n")
}

# 2.2 Fixing missing values
cat("  b. Detecting and fixinig missing values...\n")
if(any(is.na(data_matrix))) {
  missing_count <- sum(is.na(data_matrix))
  missing_percent <- round(100 * missing_count / length(data_matrix), 1)
  cat(sprintf("    Count of missing values in my data: %d (%.1f%%)\n", missing_count, missing_percent))
  
  # Filling the missing values with 1/2 of minimum value in the whole data
  overall_min <- min(data_matrix, na.rm = TRUE)
  data_matrix[is.na(data_matrix)] <- overall_min / 2
  cat("    Done with Filling the missing values with 1/2 of minimum value\n")
} else {
  cat("    Missing values not found\n")
}

# 2.3 Filtering low abundance metabolites
cat("  c. Filtering low abundance metabolites...\n")
# Calculating every metabolite's detecting times in all samples
detection_rate <- apply(data_matrix, 2, function(x) {
  # Defining detecting threshold: 10% of the median of all the non-Zero values
  threshold <- median(x[x > 0]) * 0.1
  sum(x > threshold)
})

# Keeping metabolites detected in at least 50% samples 
min_samples <- nrow(data_matrix) * 0.5
keep_metabolites <- detection_rate >= min_samples
data_matrix_filtered <- data_matrix[, keep_metabolites]

cat(sprintf("    Done with keeping %d/%d metabolites (%.1f%%)\n", 
            sum(keep_metabolites), ncol(data_matrix), 
            100 * sum(keep_metabolites) / ncol(data_matrix)))

# 2.4 Data normalization
cat("  d. Data normalizing...\n")
# ropls: scaleC="standard" set already

# Log transformation 
# data_matrix_normalized <- log2(data_matrix_filtered + 1)

# Saving processed data for later use of machine learning
saveRDS(data_matrix_filtered, "preprocessed_data_matrix.rds")
cat("    Done with data processing! Processed data saved!\n")
