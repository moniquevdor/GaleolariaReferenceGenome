#!/bin/bash

#These python scripts are adapted from Santangelo et al. 2023 and can be found in the folder "python scripts"
python 1_fixEC_incrementCDS_addLocusTags.py

python 2_fixProducts_ncbiErrors_mod.py

pyhton 3_fixOverlaps.py

pyhton 4_fixkeep_longest_isoform.py

#load modules
module load gffread

#sort
gff3_sort -g 4_Galeolaria_caespitosa_functional_longest.gff3 -r -og Galeolaria_caespitosa_functional_final_sorted.gff3

#get fasta
gffread -E -y Galeolaria_caespitosa_proteins_final.fasta -g {your_path}/ChromAssemblyHap1Rearranged.masked.fasta Galeolaria_caespitosa_functional_final_sorted.gff3

#get fasta with names
gffread -E -F -y Galeolaria_caespitosa_proteins_final_names.fasta -g {your_path}/ChromAssemblyHap1Rearranged.masked.fasta Galeolaria_caespitosa_functional_final_sorted.gff3
