

#' Making 96 wells plate
#'
#' @param argument put a generated input from EasyPeasyGenotype function
#'
#' @return 96 wells plot
#' @export
#'
#' @examples
plate_96 <- function(argument) {

  set.seed(123)

  # argumenthape the data for plotting
  argument$Row <- factor(substr(argument$sample_name, 1, 1), levels = rev(LETTERS[1:8]))
  argument$Column <- substr(argument$sample_name, 2, nchar(argument$sample_name))
  argument$Column <- as.numeric(argument$Column)
  argument$Column <- factor(argument$Column, levels = c(1:9, 10:12))

  # Create the plot with circles
  plate <- ggplot(argument, aes(x = Column, y = Row, fill = Genotype, label = Genotype)) +
    geom_point(shape = 21, color = "black", size = 19) + # Use shape 21 for filled circles
    geom_text(color = "black", size = 5.5, vjust = 0.5, hjust = 0.5) + # Add labels with slightly larger size
    scale_fill_manual(values = c("WT" = "lightblue", "+/-" = "green", "-/-" = "pink", "Unknown" = "black")) + # Define colors
    labs(title = "96-Well Plate Layout", x = "Column", y = "Row", fill = "Genotype") + # Add labels
    theme_minimal() + # Minimalistic theme
    theme(axis.text.x = element_text( vjust = 0.5, hjust = 1),
          axis.title = element_text(size = 12)) # Adjust axis title size

  print("Saving plots")
  ggsave("plate.pdf", plot = plate,
         width = 10, height = 10, limitsize = FALSE)

  print("Plot generated and saved successfully !!!")

  return(plate)

}

