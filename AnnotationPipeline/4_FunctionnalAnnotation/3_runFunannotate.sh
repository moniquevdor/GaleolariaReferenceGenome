#!/bin/bash
#SBATCH -J FunctionalAnnot             
#SBATCH -o FunctionalAnnot.out      
#SBATCH -e FunctionalAnnot.e  
#SBATCH --account=tn20 
#SBATCH -n 1                
#SBATCH -c 20                
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-user=monique.vandorssen@monash.edu 
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH -t 24:00:00


# Use Funannotate to combine InterProScan and Eggnog annotations and generate additional functional annotations
funannotate annotate \
  --sbt template.sbt \
  --gff /fs03/tn20/Monique/referencegenome/6_Functional_Annotation/Hap1/FinalGeneSet_fixed_sorted.gff \
  --mito-pass-thru /fs03/tn20/Monique/referencegenome/9_MitoAssembly/Results_combined/final_mitogenome.fasta \
  --fasta /fs03/tn20/Monique/referencegenome/6_Functional_Annotation/Hap1/ChromAssemblyHap1Final_masked.fasta \
  --species "Galeolaria caespitosa" \
  --out /fs03/tn20/Monique/referencegenome/6_Functional_Annotation/Hap1/3_funannotate/annotations \
  --iprscan /fs03/tn20/Monique/referencegenome/6_Functional_Annotation/Hap1/1_interproscan/Galeolaria_caespitosa_proteins.fasta.xml \
  --eggnog /fs03/tn20/Monique/referencegenome/6_Functional_Annotation/Hap1/2_eggnog/GaleoEggNog.emapper.annotations \
  --force \
  --database funannotate_db \
  --busco_db /fs03/tn20/Monique/referencegenome/6_Functional_Annotation/Hap1/3_funannotate/funannotate_db/metazoa
  
