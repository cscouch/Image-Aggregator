# filter_and_copy_images.R
# Reads a CoralNet image list, filters paths by specific criteria,
# and copies the matching image files into a flat destination directory.
#
# Filter criteria: path must contain "FISH" AND one of (AGR|AGU|ASU|FDP|MAU|PAG)
# Input:  V:/ANALYSIS/CoralNet Image Lists/2011/HA1101_Image_List.txt
# Output: C:/Users/courtney.s.couch/Documents/2011 Marianas PQs/

# ── Configuration ─────────────────────────────────────────────────────────────

input_file  <- "V:/ANALYSIS/CoralNet Image Lists/2011/HA1101_Image_List.txt"
output_dir  <- "C:/Users/courtney.s.couch/Documents/2011 Marianas PQs/"

# ── Read image list ────────────────────────────────────────────────────────────

if (!file.exists(input_file)) {
  stop("Input file not found: ", input_file)
}

image_paths <- readLines(input_file, warn = FALSE)
image_paths <- trimws(image_paths)
image_paths <- image_paths[nzchar(image_paths)]   # drop blank lines

cat("Total images in list:", length(image_paths), "\n")

# ── Apply filter ───────────────────────────────────────────────────────────────
# Keep only paths that contain "FISH" AND at least one of the site codes.

site_pattern <- "AGR|AGU|ASU|FDP|MAU|PAG"

matches <- image_paths[
  grepl("FISH", image_paths, ignore.case = FALSE) &
  grepl(site_pattern, image_paths, ignore.case = FALSE)
]

cat("Images matching filter:", length(matches), "\n")

if (length(matches) == 0) {
  message("No files matched the filter criteria. Nothing to copy.")
  quit(save = "no", status = 0)
}

# ── Create destination directory ───────────────────────────────────────────────

if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
  cat("Created output directory:", output_dir, "\n")
}

# ── Copy files ─────────────────────────────────────────────────────────────────
# Files are copied into a flat destination folder (basename only).

copied   <- 0
skipped  <- 0
missing  <- 0   # source file not found on disk
errors   <- 0   # file.copy() returned FALSE

for (src in matches) {
  if (!file.exists(src)) {
    warning("Source file not found, skipping: ", src)
    missing <- missing + 1
    next
  }

  dest <- file.path(output_dir, basename(src))

  if (file.exists(dest)) {
    message("Already exists, skipping: ", basename(src))
    skipped <- skipped + 1
    next
  }

  ok <- file.copy(from = src, to = dest, overwrite = FALSE)
  if (ok) {
    copied <- copied + 1
  } else {
    warning("Failed to copy: ", src)
    errors <- errors + 1
  }
}

# ── Summary ────────────────────────────────────────────────────────────────────

cat("\n── Copy summary ──────────────────────────────\n")
cat("  Copied       :", copied,  "\n")
cat("  Skipped      :", skipped, "\n")
cat("  Missing src  :", missing, "\n")
cat("  Copy errors  :", errors,  "\n")
cat("  Output       :", output_dir, "\n")
