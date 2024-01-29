# EasyPeasyGenotype
Package helps to generate tables and plots of data after qPCR. It use the data from lightcycler96 software. package return in console information about numbers of each genotype, give and save data_frame with plate wells and genotype assigned to the well in xlsx format . Return two plots of HRM curves, one plot for combined curves and one for each sample separate.

## Instalation
Check if you have devtools package, if not install it by typing: 

$ install.packages("devtools")

Then install package EasyPeasyGenotype

$devtools::install_github('TomaszDulski/EasyPeasyGenotype')

## Execute the function

Type:

$ EasyPeasyGenotype(file_name = <"name_of_your_file_from_qPCR">, differential_temperature = <set threshold temperature between pics of WT and -/->, het_lowest_bump = <set threshold for heterozygous, see on attached plot>)


