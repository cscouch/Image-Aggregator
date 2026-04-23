# Image-Aggregator

Compiles images from disparate folders into one location.

---

## filter_and_copy_images.R

Reads a CoralNet image list, filters the paths by specific criteria, and copies
the matching image files into a single flat destination directory.

### Requirements

* R (≥ 3.5)
* Access to the network drive containing the source images (`V:/`)

### Configuration

Open `filter_and_copy_images.R` and confirm the two path variables at the top of
the script match your environment:

| Variable | Default value |
|---|---|
| `input_file` | `V:/ANALYSIS/CoralNet Image Lists/2011/HA1101_Image_List.txt` |
| `output_dir` | `C:/Users/<username>/Documents/2011 Marianas PQs/` |

### Filter criteria

An image path is copied only when **both** conditions are true:

1. The path contains the string `FISH`
2. The path contains at least one of the site codes: `AGR`, `AGU`, `ASU`, `FDP`, `MAU`, or `PAG`

### Usage

Run the script from an R console or RStudio:

```r
source("filter_and_copy_images.R")
```

Or from a terminal (Windows):

```bat
Rscript filter_and_copy_images.R
```

### Output

Matching files are copied into the destination folder as a flat list (no
sub-directory structure is preserved).  The script prints a summary on
completion:

```
Total images in list: 1500
Images matching filter: 42

── Copy summary ──────────────────────────────
  Copied       : 42
  Skipped      : 0
  Missing src  : 0
  Copy errors  : 0
  Output       : C:/Users/<username>/Documents/2011 Marianas PQs/
```
