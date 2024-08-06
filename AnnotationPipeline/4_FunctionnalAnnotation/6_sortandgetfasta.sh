#!/bin/bash

#This python script is adapted from Santangelo et al. 2023 and can be found in the folder "python scripts"
python 2_add_diamond_hits_products.py

module load gffread

#sort
gff3_sort -g Galeolaria_caespitosa_functional_withDiamondProducts_final.gff3 -r -og Galeolaria_caespitosa_functional_withDiamondProducts_final_sorted.gff3

#get fasta
gffread -E -y Galeolaria_caespitosa_proteins_final.fasta -g {your_path}/ChromAssemblyHap1Final_masked.fasta Galeolaria_caespitosa_functional_withDiamondProducts_final_sorted.gff3

#get fasta with names
gffread -E -F -y Galeolaria_caespitosa_proteins_final_names.fasta -g {your_path}/ChromAssemblyHap1Final_masked.fasta Galeolaria_caespitosa_functional_withDiamondProducts_final_sorted.gff3

#get fasta nucleic acid
gffread -F Galeolaria_caespitosa_functional_withDiamondProducts_final_sorted.gff3 -g {your_path}/ChromAssemblyHap1Final_masked.fasta -w Galeolaria_caespitosa_proteins_final_names_NucleicAcid.fasta

grep '^>' Galeolaria_caespitosa_proteins_final_names.fasta | \
awk -F 'product=' '{split($2, a, ";"); print a[1]}' | \
sort | \
uniq -c | \
awk '{print $2, $3 "\t" $1}' > products_count.txt
