#!/bin/bash
#SBATCH -J SortFasta             
#SBATCH -o SortFasta.out      
#SBATCH -e SortFasta.e  
#SBATCH --account=tn20 
#SBATCH -n 1                
#SBATCH -c 20                
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-user=monique.vandorssen@monash.edu 
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH -t 24:00:00

#This python script is adapted from Santangelo et al. 2023 and can be found in the folder "python scripts"
python 2_add_diamond_hits_products.py

module load gffread

#sort
gff3_sort -g Galeolaria_caespitosa_functional_withDiamondProducts_final.gff3 -r -og Galeolaria_caespitosa_functional_withDiamondProducts_final_sorted.gff3

#get fasta
gffread -E -y Galeolaria_caespitosa_proteins_final.fasta -g ../../ChromAssemblyHap1Final_masked.fasta Galeolaria_caespitosa_functional_withDiamondProducts_final_sorted.gff3

#get fasta with names
gffread -E -F -y Galeolaria_caespitosa_proteins_final_names.fasta -g ../../ChromAssemblyHap1Final_masked.fasta Galeolaria_caespitosa_functional_withDiamondProducts_final_sorted.gff3

#get fasta nucleic acid
gffread -F Galeolaria_caespitosa_functional_withDiamondProducts_final_sorted.gff3 -g ../../ChromAssemblyHap1Final_masked.fasta -w Galeolaria_caespitosa_proteins_final_names_NucleicAcid.fasta
