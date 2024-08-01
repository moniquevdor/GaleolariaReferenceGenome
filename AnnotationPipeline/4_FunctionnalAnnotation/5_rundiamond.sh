#!/bin/bash
#SBATCH -J Diamond             
#SBATCH -o Diamond.out      
#SBATCH -e Diamond.e  
#SBATCH --account=tn20 
#SBATCH -n 1                
#SBATCH -c 20                
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-user=monique.vandorssen@monash.edu 
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH -t 24:00:00


./diamond blastp --verbose --tmpdir /fs03/tn20/Monique/referencegenome/6_Functional_Annotation/Hap1/5_diamond/blast_func/diamondtmp/ --db /fs03/tn20/Monique/referencegenome/6_Functional_Annotation/Hap1/5_diamond/blast_func/nr/nr --out /fs03/tn20/Monique/referencegenome/6_Functional_Annotation/Hap1/5_diamond/blast_func/diamond_out.txt --header simple --max-target-seqs 5 --query /fs03/tn20/Monique/referencegenome/6_Functional_Annotation/Hap1/4_cleanup/Galeolaria_caespitosa_proteins_final.fasta --max-hsps 1 --outfmt 6 qseqid qlen sseqid slen stitle pident evalue 

#Filter diamond hits on R

#Add diamon hits with python script
