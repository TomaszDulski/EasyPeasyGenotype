# EasyPeasyGenotype
Package helps to generate tables and plots of data after qPCR. It use the data from lightcycler96 software. package return in console information about numbers of each genotype, give and save data_frame with plate wells and genotype assigned to the well in .xlsx format. Return two plots of HRM curves, one plot for combined curves and one for each sample separate.

## Instalation
Check if you have devtools package, if not install it by typing: 

install.packages("devtools")

Then install package EasyPeasyGenotype

devtools::install_github('TomaszDulski/EasyPeasyGenotype')

Remember to load the package after installation 

$ library("EasyPeasyGenotype")

## Input file
From lightcycler software. save the Normalized melting peaks plot as a text file. Just click on the plot right mouse buton and export it. Remenber to save text file Samples as a Columns. See the below screenshot. Save the file in the same location of your R script.

![HRM](https://github.com/TomaszDulski/EasyPeasyGenotype/assets/95283499/a035cfbe-f5a2-4b80-afd8-416e50681562)

## Execute the function

Type:

EasyPeasyGenotype::EasyPeasyGenotype( file_name = < "name_of_your_file_from_qPCR" >, \
    differential_temperature = < set threshold temperature between peaks of WT and -/- >, \
    het_lowest_bump = < set threshold for heterozygous, see on attached plot. It has to be under the smaller bump for heterozygous > \
    ) \
\
For generating the 96-wells plate type:

plate_96(argument = <here put the output from the previous function EasyPeasyGenotype. )
    
![plate96](https://github.com/TomaszDulski/EasyPeasyGenotype/assets/95283499/560c9bb4-0166-4d60-b0ec-c7e852ca0f7e)


## Output

Function EasyPeasyGenotype will return to you some information in console of the number of each genotype on your plate. Also result table will be saved in the excel file. The generated plots will be saved in pdf extension. One plot is for combined curves and another presents each sample separate (see examples below). All data will be saved in the same location where is your R script. 

Combined sample:
[tsc2_none_td_combined.pdf](https://github.com/TomaszDulski/EasyPeasyGenotype/files/14097327/tsc2_none_td_combined.pdf)

Separate samples:
[tsc2_none_td_separate.pdf](https://github.com/TomaszDulski/EasyPeasyGenotype/files/14097347/tsc2_none_td_separate.pdf)

Excel table:
[tsc2_none_td.xlsx](https://github.com/TomaszDulski/EasyPeasyGenotype/files/14097516/tsc2_none_td.xlsx)

The output from the plate_96 function:



## Troubleshooting

Keep in mind that this package do not always set the genotypes correctly. Sometimes a curve of single sample might be shifted due to the different amount of DNA matrix in the sample or other factors. Be aware of that and always check the results.  
