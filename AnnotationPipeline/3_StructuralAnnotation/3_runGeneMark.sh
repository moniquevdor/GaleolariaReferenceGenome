#!/bin/bash

# Load modules
module load stringtie/2.1.5
module load minimap2
module load samtools

# Use the *collapsed.gff files from the RNA Processing

# Run GeneMarkS-T to predict protein-coding regions in the transcripts:
{your_path}/Augustus/scripts/stringtie2fa.py -g {your_path}/ChromAssemblyHap1Final_masked.fasta -f {your_path}/GaleolariaH1RNA.collapsed.gff -o cupcake.fa 
{your_path}/GeneMarkS-T/gmst.pl --strand direct cupcake.fa.mrna --output gmst.out --format GFF 

# Use the GeneMarkS-T coordinates and the long-read transcripts to create a gene set in GTF format.
{your_path}/BRAKER/scripts/gmst2globalCoords.py -t {your_path}/GaleolariaH1RNA.collapsed.gff -p gmst.out -o gmst.global.gtf -g {your_path}/ChromAssemblyHap1Final_masked.fasta 

# The result of this step is located at $wdir/long_read_protocol/gmst.global.gtf .
