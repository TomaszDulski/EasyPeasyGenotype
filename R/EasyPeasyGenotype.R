
#' EasyPeasyGenotype
#'
#' @param file_name .txt file exported from lightcycler96 software, save column as a sample
#' @param differential_temperature set critical temp. between picks of WT, and -/-. in case of tsc2 it's 80.5
#' @param het_lowest_bump set threshold of Resolight value in temperature period of 76-78 C, where value is below heterozygous bump and above curves for WT and -/-
#'
#' @return print in console information about numbers of each genotype, function also give data_frame with plate wells and genotype assigned to the well. Return two plots of HRM curves, one plot for combined curves, and one for each curve separate
#' @export
#'
#' @examples EasyPeasyGenotype(file_name = tsc2_none.txt, differential_temperature = 80.5, het_lowest_bump = 0.115


EasyPeasyGenotype <- function(file_name, # .txt file exported from lightcycler96 software, save column as a sample
                              differential_temperature, # set critical temp. between picks of WT, and -/-. in case of tsc2 it's 80.5
                              het_lowest_bump # set threshold of Resolight value in temperature period of 76-78 C, where value is below heterozygous bump and above curves for WT and -/-
) {
  # Check if packages are installed, and install them if necessary
  required_packages <- c("ggplot2", "reshape2", "tidyverse", "readr", "openxlsx")
  missing_packages <- required_packages[!requireNamespace(required_packages, quietly = TRUE)]

  if (length(missing_packages) > 0) {
    print("Installing necessary packages before analyzing: ", paste(missing_packages, collapse = ", "))
    install.packages(missing_packages, dependencies = TRUE)
  } else {
    print("All required packages are already installed. Ready to do some science")
  }

  library(ggplot2)
  library(reshape2)
  library(tidyverse)
  library(readr)
  library(openxlsx)

  setwd(getwd())
  file_path <- file_name

  # Read the tab-delimited text file .csv
  #data <- read.table(file_path, header = TRUE, sep = "/t")
  #for txt.file
  data <-
    read_delim(file_path,
               delim = "\t",
               locale = locale(encoding = "UTF-16LE"))

  print("Data file loaded succesfully !!!")

  # Create empty data frame to store results
  result_df <-
    data.frame(
      sample_name = character(),
      highest_value = numeric(),
      temp_at_highest = numeric(),
      Genotype = character(),
      stringsAsFactors = FALSE
    )

  # Iterate over each column starting from the 2nd column (assuming the 1st column is Temperature..dF.dT)
  for (col in 2:ncol(data)) {
    # Extract column data
    temperature_points <- data[[1]]
    pick_data <- as.double(data[[col]])

    # Find the highest value in the pick_data
    highest_value <- max(pick_data, na.rm = TRUE)

    # Find the corresponding temperature value at the highest point
    temp_at_highest <- temperature_points[which.max(pick_data)]

    #low temp
    subset_data <- data[data[[1]] >= 76 & data[[1]]  <= 78,]
    #subset_data <- data[data$Temperature..dF.dT >= 76 & data$Temperature..dF.dT <= 78, ]
    pick_data2 <- as.double(subset_data[[col]])
    highest_value_sub_for_het <- max(pick_data2, na.rm = TRUE)

    # Determine the Genotype based on conditions
    # genotype <- if (temp_at_highest <
    #                 differential_temperature) {
    #   if (highest_value_sub_for_het > het_lowest_bump) {
    #     "+/-"
    #   } else {
    #     "-/-"
    #   }
    # } else {
    #   if (highest_value_sub_for_het > het_lowest_bump) {
    #     "+/-"
    #   } else {
    #     "WT"
    #   }
    # }

    # Determine the Genotype based on conditions
    genotype <- if (highest_value_sub_for_het < 0.03 | highest_value_sub_for_het > 0.15) {
      "Unknown"
    } else if (temp_at_highest < differential_temperature) {
      if (highest_value_sub_for_het > het_lowest_bump) {
        "+/-"
      } else {
        "-/-"
      }
    } else {
      if (highest_value_sub_for_het > het_lowest_bump) {
        "+/-"
      } else {
        "WT"
      }
    }

    # Store results in the new data frame
    result_df <-
      rbind(
        result_df,
        data.frame(
          sample_name = colnames(data)[col],
          highest_value = highest_value,
          temp_at_highest = temp_at_highest,
          highest_value_sub_for_het = highest_value_sub_for_het,
          Genotype = genotype
        )
      )
  }

  # Count occurrences of each genotype in the result_df dataframe
  genotype_counts <- table(result_df$Genotype)

  # Print counts to the console
  cat("Genotype Counts:\n")
  cat("WT:", genotype_counts["WT"], "\n")
  cat("+/-:", genotype_counts["+/-"], "\n")
  cat("-/-:", genotype_counts["-/-"], "\n")
  cat("Unknown:", genotype_counts["Unknown"], "\n")
  # Print the new data frame
  result_df_sub <- result_df[c(1,5)]

  result_df_sub$sample_name <- gsub(pattern = "ResoLight", replacement = "", x = result_df_sub$sample_name)
  print(result_df_sub)
  print("Data table generated successfully !!!")

  df_long <- reshape2::melt(data, id.vars = colnames(data[1]))
  df_long_add <-
    df_long %>% dplyr::left_join(., result_df, by = c("variable" = "sample_name"))

  df_long_add$variable <- gsub(pattern = "ResoLight", replacement = "", x = df_long_add$variable)

  # Reorder the levels of the 'variable' factor based on their order in df_long_add
  df_long_add$variable <- factor(df_long_add$variable, levels = unique(df_long_add$variable))

  plot_draft_separate <-
    ggplot(df_long_add, aes(x = df_long_add[[1]], y = value, color = Genotype)) +
    geom_line() +
    facet_wrap( ~ variable, scales = "free_y") +
    labs(title = "Curves of ResoLight for Different Samples",
         x = "Temperature",
         y = "ResoLight dF/dT") +
    geom_vline(xintercept = differential_temperature, linetype = "dashed", color = "black", size = 5) +
    theme_minimal() +
    theme(strip.text = element_text(size = 50),   # Adjust facet label size
          axis.text = element_text(size = 50),    # Adjust scale text size
          plot.title = element_text(size = 50))

  # Assuming df_long_add contains the relevant data
  # Modify the ggplot code to include all curves on one plot
  plot_draft_combined <-
    ggplot(df_long_add,
           aes(
             x = df_long_add[[1]],
             y = value,
             color = Genotype,
             group = variable
           )) +
    geom_line() +
    labs(title = "Curves of ResoLight for Different Samples",
         x = "Temperature",
         y = "ResoLight dF/dT") +
    geom_vline(xintercept = differential_temperature, linetype = "dashed", color = "black", size = 7) +
    theme_minimal() +
    theme(legend.position = "top",                  # Place legend on top
          axis.text = element_text(size = 50),      # Adjust scale text size
          axis.title = element_text(size = 50),     # Adjust axis title size
          legend.text = element_text(size = 50),    # Adjust legend text size
          plot.title = element_text(size = 50))     # Adjust plot title size
  # Print the plot
  print(plot_draft_separate)
  # Print the plot
  print(plot_draft_combined)

  file_path <- gsub(".txt$", "", file_path)

  print("Saving table")

  openxlsx::write.xlsx(x = result_df_sub,
                       file = paste0(file_path, ".xlsx"),
                       rowNames = TRUE)
  print("Table generated and saved successfully !!!")

  print("Saving plots")
  ggsave(paste0(file_path, "_separate.pdf"), plot = plot_draft_separate,
         width = 100, height = 100, limitsize = FALSE)
  ggsave(paste0(file_path, "_combined.pdf"), plot = plot_draft_combined,
         width = 100, height = 100, limitsize = FALSE)

  print("Plots generated and saved successfully !!!")
}
