#!/bin/bash

# load modules
module load samtools/1.9
module load bamtools

#   Step 1 - Remove residual adapters, primers & poly(A) tails

# Primer removal and demultiplexing with Lima
lima GC-pooled-3.hifi_reads.bam IsoSeq_Primers.fasta GC-pooled-3.hifi_reads.fl.bam --isoseq --peek-guess

# Trimming of poly(A) tails
isoseq3 refine GC-pooled-3.hifi_reads.fl.5p--3p.bam IsoSeq_Primers.fasta GC-pooled-3.flnc.bam --require-polya 

# An intermediate flnc.bam file is produced which contains the FLNC reads. To convert to FASTA format, run:
bamtools convert -format fasta -in GC-pooled-3.flnc.bam > GC-pooled-3.flnc.fasta
#Now, flnc.fasta is the full-length, non-concatemer FASTA file you can use to align back to the genome for analysis

# Cluster FLNC reads and generate polished transcripts (HQ Transcript Isoforms)
isoseq3 cluster GC-pooled-3.flnc.bam GC-pooled-3.polished.bam --verbose --use-qvs
