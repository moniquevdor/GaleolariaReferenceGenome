#!/bin/bash

emapper.py -i {your_path}/Galeolaria_caespitosa_proteins.fasta \
            --data_dir eggnog_db/ \
            --itype proteins \
            -o GaleoEggNog \
            --override 
