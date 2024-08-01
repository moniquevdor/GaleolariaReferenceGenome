#!/bin/bash

pyhton 2_add_diamond_hits_products.py

module load gffread

#sort
gff3_sort -g Galeolaria_caespitosa_functional_withDiamondProducts_final.gff3 -r -og Galeolaria_caespitosa_functional_withDiamondProducts_final_sorted.gff3

#get fasta
gffread -E -y Galeolaria_caespitosa_proteins_final.fasta -g ../../ChromAssemblyHap1Final_masked.fasta Galeolaria_caespitosa_functional_withDiamondProducts_final_sorted.gff3

#get fasta with names
gffread -E -F -y Galeolaria_caespitosa_proteins_final_names.fasta -g ../../ChromAssemblyHap1Final_masked.fasta Galeolaria_caespitosa_functional_withDiamondProducts_final_sorted.gff3

#get fasta nucleic acid
gffread -F Galeolaria_caespitosa_functional_withDiamondProducts_final_sorted.gff3 -g ../../ChromAssemblyHap1Final_masked.fasta -w Galeolaria_caespitosa_proteins_final_names_NucleicAcid.fasta
