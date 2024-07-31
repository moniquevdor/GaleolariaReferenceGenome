#!/bin/bash
#SBATCH -J GeneMarkST             
#SBATCH -o GeneMarkST.out      
#SBATCH -e GeneMarkST.e 
#SBATCH --account=tn20
#SBATCH --time=7-00:00:00
#SBATCH -n 3
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-user=monique.vandorssen@monash.edu 
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL


# Load modules
module load stringtie/2.1.5
module load minimap2
module load samtools

# Use the *collapsed.gff files from the RNA Processing

# Run GeneMarkS-T to predict protein-coding regions in the transcripts:
../../Augustus/scripts/stringtie2fa.py -g ../ChromAssemblyHap1Final_masked.fasta -f ../GaleolariaH1RNA.collapsed.gff -o cupcake.fa 
../../GeneMarkS-T/gmst.pl --strand direct cupcake.fa.mrna --output gmst.out --format GFF 

# Use the GeneMarkS-T coordinates and the long-read transcripts to create a gene set in GTF format.
../../BRAKER/scripts/gmst2globalCoords.py -t ../GaleolariaH1RNA.collapsed.gff -p gmst.out -o gmst.global.gtf -g ../ChromAssemblyHap1Final_masked.fasta 

# The result of this step is located at $wdir/long_read_protocol/gmst.global.gtf .
