#!/bin/bash
#SBATCH -J Eggnog             
#SBATCH -o Eggnog.out      
#SBATCH -e Eggnog.e  
#SBATCH --account=tn20 
#SBATCH -n 1                
#SBATCH -c 20                
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-user=monique.vandorssen@monash.edu 
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH -t 40:00:00

emapper.py -i ../Galeolaria_caespitosa_proteins.fasta \
            --data_dir eggnog_db/ \
            --itype proteins \
            -o GaleoEggNog \
            --override 