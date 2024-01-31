
plate96 <- function(argument) {
  # Check if packages are installed, and install them if necessary
  required_packages <- c("platetools", "viridis")
  missing_packages <- required_packages[!requireNamespace(required_packages, quietly = TRUE)]

  if (length(missing_packages) > 0) {
    cat("Installing necessary packages before analyzing: ", paste(missing_packages, collapse = ", "), "\n")
    install.packages(missing_packages, dependencies = TRUE)
  } else {
    cat("All required packages are already installed. Ready to do some science\n")
  }

  # Load libraries
  library(platetools)
  library(viridis)


  # Create plate_id
  plate_id <- rep(c("My Plate"), each = 96)

  # Convert Genotype to a factor
  argument$Genotype <- factor(argument$Genotype, levels = c("-/-", "WT", "+/-"))

  # Map factor levels to numeric values
  genotype_numeric <- c("-/-" = -1, "WT" = 0, "+/-" = 1)

  # Map Genotype to numeric values
  argument$Genotype_numeric <- genotype_numeric[argument$Genotype]

  # Now you can use Genotype_numeric for plotting
  plate <- z_grid(data = argument$Genotype_numeric,
         well = argument$sample_name,
         plate_id = plate_id) +
    ggtitle("Genotyped samples on 96 well plate")
return(plate)
}





