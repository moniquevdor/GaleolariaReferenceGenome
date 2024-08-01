#!/bin/bash

# Use Funannotate to combine InterProScan and Eggnog annotations and generate additional functional annotations
funannotate annotate \
  --sbt template.sbt \
  --gff {your_path}/FinalGeneSet_fixed_sorted.gff \
  --mito-pass-thru {your_path}/final_mitogenome.fasta \
  --fasta {your_path}/ChromAssemblyHap1Final_masked.fasta \
  --species "Galeolaria caespitosa" \
  --out {your_path}/annotations \
  --iprscan {your_path}/Galeolaria_caespitosa_proteins.fasta.xml \
  --eggnog {your_path}/GaleoEggNog.emapper.annotations \
  --force \
  --database funannotate_db \
  --busco_db {your_path}/funannotate_db/metazoa
  
