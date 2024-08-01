#!/bin/bash

# Run MitoHiFi to pull out mitochondrial genome from raw genome assembly (on M3 cluster)
# https://github.com/marcelauliano/MitoHiFi

module load blast
module load singularity

SING="singularity run -B /fs02 -B /fs03 -B /fs04 -B /scratch -B /projects {your_path}/mitohifi.sif"

$SING mitohifi.py -c {your_path}/hap1_assembly_raw.fa -f NC_061743.1.fasta -g NC_061743.1.gb --mitos -a animal -t 5 -o 5
