#!/bin/bash

module load singularity
module load samtools

#Run tsebra

{your_path}/TSEBRA/bin/tsebra.py -g {your_path}/braker1/braker.gtf,{your_path}/braker2/braker.gtf -e {your_path}/braker1/hintsfile.gff,{your_path}/braker2/hintsfile.gff -l {your_path}/long_read_protocol/gmst.global.gtf -c long_reads_mod.cfg -o FinalGeneSet.gtf

#The final gene set is located at $wdir/tsebra/FinalGeneSet.gtf .

#fix names with tsebra
python {your_path}/TSEBRA/bin/rename_gtf.py --gtf FinalGeneSet.gtf --prefix galc --translation_tab translation.tab --out FinalGeneSet_renamed.gtf

#convert to gff3
SING="singularity run -B /fs02 -B /fs03 -B /fs04 -B /scratch -B /projects ../../agat_1.0.0--pl5321hdfd78af_0.sif"
$SING agat_convert_sp_gxf2gxf.pl --gtf FinalGeneSet_renamed.gtf -o FinalGeneSet_renamed.gff

#clean gff output
gfftk sanitize -f {your_path}/ChromAssemblyHap1Final_masked.fasta -g FinalGeneSet_renamed.gff -o FinalGeneSet_fixed.gff

#sort zip and index
sort -k1,1 -k4,4n -s FinalGeneSet_fixed.gff > FinalGeneSet_fixed_sorted.gff
bgzip FinalGeneSet_fixed_sorted.gff -o FinalGeneSet_fixed_sorted.gff.gz
tabix FinalGeneSet_fixed_sorted.gff.gz

#get fasta
gffread -E -y Galeolaria_caespitosa_proteins.fasta -g {your_path}/ChromAssemblyHap1Final_masked.fasta FinalGeneSet_fixed_sorted.gff

#module load busco/5.1.3
#busco scores
#busco -i Galeolaria_caespitosa_proteins.fasta -m proteins -l eukaryota_odb10 -f --out busco.out

mkdir OUT
mv FinalGeneSet* OUT/
mv Galeolaria_caespitosa_proteins.fasta OUT/
cp *cfg OUT/
mv *tab OUT/
#mv busco.out/short_summary.specific.eukaryota_odb10.busco.out.txt OUT/

###Intermediate file checking
#gtf to gff
#$SING agat_convert_sp_gxf2gxf.pl --gtf braker.gtf -o check.gff
#gfftk sanitize -f {your_path}/ChromAssemblyHap1Final_masked.fasta -g check.gff -o check_fixed.gff
#sort -k1,1 -k4,4n -s check_fixed.gff > check_fixed_sorted.gff
#gff to fasta
#gffread -E -y check_fixed_sorted_b.fasta -g {your_path}/ChromAssemblyHap1Final_masked.fasta check_fixed_sorted.gff



