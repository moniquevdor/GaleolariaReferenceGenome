#!/bin/bash

module load interproscan

# Generate functional annotations using InterProScan
interproscan.sh -i {your_path}/Galeolaria_caespitosa_proteins.fasta \
            -f xml,gff3 \
            -goterms \
            --pathways \
            --seqtype p \
            --verbose 
