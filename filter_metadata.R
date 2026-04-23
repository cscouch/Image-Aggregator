# filter_metadata.R
# Reads a CoralNet metadata CSV, scans the local directory for successfully
# moved image files, and writes a filtered CSV containing only the rows whose
# filename matches a file that is present locally.
#
# Metadata source : V:/ANALYSIS/CoralNet Metadata Files/2011/HA1101_Image_Metadata.csv
# Local directory : C:/Users/courtney.s.couch/Documents/2011 Marianas PQs/
# Output          : <local_dir>/HA1101_Filtered_Metadata.csv

# ── Configuration ─────────────────────────────────────────────────────────────

metadata_file <- "V:/ANALYSIS/CoralNet Metadata Files/2011/HA1101_Image_Metadata.csv"
local_dir     <- "C:/Users/courtney.s.couch/Documents/2011 Marianas PQs/"
output_file   <- file.path(local_dir, "HA1101_Filtered_Metadata.csv")

# Name of the column in the CSV that holds the image filename.
# Adjust if your CSV uses a different column name (e.g. "Name", "Image", ...).
filename_col  <- "Name"

# ── Read metadata CSV ─────────────────────────────────────────────────────────

if (!file.exists(metadata_file)) {
  stop("Metadata file not found: ", metadata_file)
}

metadata <- read.csv(metadata_file, stringsAsFactors = FALSE, check.names = FALSE)
cat("Total rows in metadata CSV:", nrow(metadata), "\n")

if (!filename_col %in% names(metadata)) {
  stop(
    "Column '", filename_col, "' not found in metadata CSV.\n",
    "Available columns: ", paste(names(metadata), collapse = ", ")
  )
}

# ── Scan local directory for present files ────────────────────────────────────

if (!dir.exists(local_dir)) {
  stop("Local directory not found: ", local_dir)
}

local_files <- list.files(local_dir, full.names = FALSE, recursive = FALSE)
local_files <- local_files[!file.info(file.path(local_dir, local_files))$isdir]
cat("Files present in local directory:", length(local_files), "\n")

if (length(local_files) == 0) {
  message("No files found in local directory. Output CSV will be empty.")
}

# ── Filter metadata ───────────────────────────────────────────────────────────
# Normalise both sides to bare basenames before comparing so that any path
# prefix stored in the CSV does not prevent a match.

csv_basenames   <- basename(metadata[[filename_col]])
local_basenames <- basename(local_files)

keep     <- csv_basenames %in% local_basenames
filtered <- metadata[keep, , drop = FALSE]

cat("Rows matching local files:", nrow(filtered), "\n")

# ── Write filtered CSV ────────────────────────────────────────────────────────

write.csv(filtered, file = output_file, row.names = FALSE)
cat("Filtered metadata saved to:", output_file, "\n")
