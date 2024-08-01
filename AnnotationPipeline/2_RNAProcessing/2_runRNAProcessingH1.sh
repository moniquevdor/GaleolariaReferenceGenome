#!/bin/bash

# Load modules
module load samtools/1.9
module load bamtools
module load minimap2
module load stringtie/2.1.5


#   Step 2 - Align RNA read to reference -> *.aligned.bam

# Map to genome
pbmm2 align ChromAssemblyHap1Final_masked.fasta GC-pooled-3.polished.hq.bam GaleolariaH1RNA.aligned.bam --j 24 --preset ISOSEQ --sort --log-level INFO

#   Step 3 - Sort and clean .bam file output from mm2 -> *.SORTED.bam

# Using samtools you can sort the alignments for future analysis
# Confusingly the output comes first (after the -o flag) the last argument is the input (ie the bam you made in the previous step) the -@ flag specifies the number of threads (how much power you want)
samtools sort -@ 10 -o GaleolariaH1RNA.SORTED.bam GaleolariaH1RNA.aligned.bam


#   Step 4 - Assemble transcriptome -> *.gff file and *.gtf file

# Collapse -> *.gff
isoseq3 collapse --do-not-collapse-extra-5exons GaleolariaH1RNA.SORTED.bam GC-pooled-3.flnc.bam GaleolariaH1RNA.collapsed.gff


# Run stringtie -m is minimum alignment length (you might want to go with default as 200), -p is threads, -o is output name
stringtie GaleolariaH1RNA.SORTED.bam -m 200 -p 10 -o GaleolariaH1RNA.gtf


#The gtf file contains information about each transcript (and exons) and where in your reference genome they are located, which you can use to train BRAKER to understand what your species genes look like (ie it picks up on lots of common patterns within sequence to know what specifies a gene, since you have given it a list of sequences which you have experimentally proven to be genes)
