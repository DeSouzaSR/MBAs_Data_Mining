# Packages and dependencies
library(readr)
library(dplyr)
library(arrow)

# 1. File path definitions
astorb_url <- "https://ftp.lowell.edu/pub/elgb/astorb.dat.gz"
temp_gzip <- tempfile(fileext = ".gz")
output_parquet <- "data/processed/astorb_reduced.parquet"

# 2. Download compressed file in binary mode
download.file(
  astorb_url,
  destfile = temp_gzip,
  mode = "wb"
)

# 3. Read selected fields from the Fixed Width Format (FWF) file
#
# Positions based directly on the current Lowell Observatory
# Fortran specification for astorb.dat.

astorb_raw <- read_fwf(
  file = gzfile(temp_gzip),
  
  col_positions = fwf_positions(
    start = c(
      1,    # number
      8,    # name
      43,   # H
      49,   # G
      116,  # M
      127,  # omega
      138,  # Omega
      148,  # inc
      159,  # e
      169   # a
    ),
    
    end = c(
      6,
      25,
      47,
      53,
      125,
      136,
      147,
      157,
      168,
      181
    ),
    
    col_names = c(
      "number",
      "name",
      "H",
      "G",
      "M",
      "omega",
      "Omega",
      "inc",
      "e",
      "a"
    )
  ),
  
  col_types = cols(
    number = col_character(),
    name   = col_character(),
    H      = col_double(),
    G      = col_double(),
    M      = col_double(),
    omega  = col_double(),
    Omega  = col_double(),
    inc    = col_double(),
    e      = col_double(),
    a      = col_double()
  ),
  
  progress = FALSE
)

# 4. Convert asteroid number to integer where possible
astorb_raw <- astorb_raw %>%
  mutate(
    number = parse_integer(number)
  )

# 5. Reorder orbital elements to standard astronomical order
astorb_clean <- astorb_raw %>%
  select(
    number,
    name,
    H,
    G,
    a,
    e,
    inc,
    Omega,
    omega,
    M
  )

# 6. Verify parsing
parsing_issues <- problems(astorb_raw)

if (nrow(parsing_issues) == 0) {
  message("Parsing completed successfully with zero issues.")
} else {
  warning(
    paste(
      "Found",
      nrow(parsing_issues),
      "parsing issues."
    )
  )
}

# 7. Ensure output directory exists
dir.create(
  dirname(output_parquet),
  recursive = TRUE,
  showWarnings = FALSE
)

# 8. Export to Parquet
write_parquet(
  astorb_clean,
  sink = output_parquet
)

# 9. Cleanup
unlink(temp_gzip)

rm(
  astorb_raw,
  astorb_clean,
  parsing_issues
)

gc()