#!/bin/bash
#SBATCH -J Interpro             
#SBATCH -o Interpro.out      
#SBATCH -e Interpro.e  
#SBATCH --account=tn20 
#SBATCH -n 1                
#SBATCH -c 20                
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-user=monique.vandorssen@monash.edu 
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH -t 24:00:00

module load interproscan

# Generate functional annotations using InterProScan
interproscan.sh -i ../Galeolaria_caespitosa_proteins.fasta \
            -f xml,gff3 \
            -goterms \
            --pathways \
            --seqtype p \
            --verbose 