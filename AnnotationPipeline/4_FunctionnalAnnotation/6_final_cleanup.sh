#!/bin/bash

#This python script is adapted from Santangelo et al. 2023 and can be found in the folder "python scripts"
python 2_add_diamond_hits_products.py

module load subread
module load minimap2
module load samtools
module load gffread

minimap2 -ax splice -uf --secondary=no ChromAssemblyHap1_Mito_Final_masked.fasta GC-pooled-3.hifi_reads.fastq > aligned_isoseq.sam

samtools view -bS aligned_isoseq.sam | samtools sort -o aligned_isoseq_sorted.bam
samtools index aligned_isoseq_sorted.bam

featureCounts -T 4 -s 0 -a Final_Annotation_Hap1.gtf -o ISOSEQ_counts.txt -g gene_id -T 8 -t exon aligned_isoseq_sorted.bam

awk 'NR > 1 && $NF > 0 {print $1}' ISOSEQ_counts.txt > mapped_genes_ISOSEQ.txt

cat gene_hits_RNAseq.txt mapped_genes_ISOSEQ.txt > gene_hits.txt

python get_hypothetical.py

python remove_genes.py

#get fasta
gffread -E -y Final_Functionnal_Annotation_H1.fasta -g ChromAssemblyHap1_Mito_Final_masked.fasta Final_Functionnal_Annotation_H1.gff3
#get fasta with names
gffread -E -F -y Final_Functionnal_Annotation_H1_names.fasta -g ChromAssemblyHap1_Mito_Final_masked.fasta Final_Functionnal_Annotation_H1.gff3

#get fasta nucleic acid
gffread -F Final_Functionnal_Annotation_H1.gff3 -g ChromAssemblyHap1_Mito_Final_masked.fasta -w Final_Functionnal_Annotation_H1_NucleicAcid.fasta
