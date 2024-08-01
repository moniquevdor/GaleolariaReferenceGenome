#!/bin/bash

./diamond blastp --verbose --tmpdir {your_path}/blast_func/diamondtmp --db {your_path}/blast_func/nr/nr --out {your_path}/blast_func/diamond_out.txt --header simple --max-target-seqs 5 --query {your_path}/Galeolaria_caespitosa_proteins_final.fasta --max-hsps 1 --outfmt 6 qseqid qlen sseqid slen stitle pident evalue 

#Filter diamond hits on R with 1_filter_diamond_hits.R
