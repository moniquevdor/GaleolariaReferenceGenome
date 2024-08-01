#!/bin/bash

# load modules
module load repeatmasker/4.1.1
module load blast

#We create a file containing all the repetitive sequences of the genome, and want to remove those sequences
# BuildDatabase for repeatmodeler2
BuildDatabase -name GaleoHap1 in_output/ChromAssemblyHap1Rearranged.fasta
RepeatModeler -database GaleoHap1 -pa 20 -LTRStruct
#We now have a few different files, the important one is GaleoHap1-families.fa, which contains the repeats

# ProtExcluder: we want to remove protein coding sequences from the repeat file, as we don't want to mask those
#AnnelidProtData.fasta is a file containing known protein coding sequences
#We want to blast the protein sequences against the repeat file
#make database for blast
makeblastdb -in in_output/AnnelidProtData.fasta -input_type fasta -dbtype prot -out AnnelidProtDataDB.fasta

#blast
blastx -query GaleoHap1-families.fa -db AnnelidProtDataDB.fasta -evalue 1e-10 -num_descriptions 10 -out GaleoHap1.lib_blast_results.txt
#blastx output contains sequence alignments between query and subject, aka the protein coding sequences from the repeat file

#We want to exclude those
{your_path}/ProtExcluder1.2/ProtExcluder.pl GaleoHap1.lib_blast_results.txt  GaleoHap1-families.fa 
#The resulting sequences and sequences without matching proteins are combined together and put in “GaleoHap1-families.fanoProtFinal” 

#Now we can remove the repeats (without those that could code for proteins) from the genome
# Masking
RepeatMasker --xsmall -pa 30 -lib GaleoHap1-families.fanoProtFinal in_output/ChromAssemblyHap1Rearranged.fasta
#results in a few files, including ChromAssemblyHap1.fasta.masked
#GaleoHap1.fasta.masked is the genome without repeats

#If we want a file with the different repeats and their position on the genome, we can make that file the following way:
tail -n +4 in_output/ChromAssemblyHap1Rearranged.fasta.out > in_output/GaleoHap1_T.txt
awk '{print $5, $6, $7}' in_output/GaleoHap1_T.txt > in_output/repeatHap1.txt
rm -rf in_output/GaleoHap1_T.txt

