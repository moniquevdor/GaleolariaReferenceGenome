#!/bin/bash
#SBATCH -J Cleanup             
#SBATCH -o Cleanup.out      
#SBATCH -e Cleanup.e  
#SBATCH --account=tn20 
#SBATCH -n 1                
#SBATCH -c 20                
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-user=monique.vandorssen@monash.edu 
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH -t 24:00:00

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
gffread -E -y Galeolaria_caespitosa_proteins_final.fasta -g ../ChromAssemblyHap1Rearranged.masked.fasta Galeolaria_caespitosa_functional_final_sorted.gff3

#get fasta with names
gffread -E -F -y Galeolaria_caespitosa_proteins_final_names.fasta -g ../ChromAssemblyHap1Rearranged.masked.fasta Galeolaria_caespitosa_functional_final_sorted.gff3