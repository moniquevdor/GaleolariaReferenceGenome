#!/bin/bash
#SBATCH -J Braker1             
#SBATCH -o Braker1.out      
#SBATCH -e Braker1.e  
#SBATCH --account=tn20    
#SBATCH -n 1                  
#SBATCH -c 30                
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-user=monique.vandorssen@monash.edu 
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH -t 5-00:00:00

#module load braker3/3.0.3
module load singularity

SING="singularity run -B /fs02 -B /fs03 -B /fs04 -B /scratch -B /projects ../../braker3.sif"

wdir=/fs03/tn20/Monique/referencegenome/5_Annotation/Annotation_H1/

$SING braker.pl --AUGUSTUS_CONFIG_PATH=/fs03/tn20/Monique/referencegenome/5_Annotation/Augustus/config --COMPLEASM_PATH=/fs03/tn20/Monique/referencegenome/5_Annotation/compleasm_kit/ --GENEMARK_PATH=/fs03/tn20/Monique/referencegenome/5_Annotation/GeneMark-ETP/bin/gmes/ --species=GaleoHap1 --useexisting --genome=../ChromAssemblyHap1Final_masked.fasta --softmasking --bam=../RNAseqBams_merged.bam --workingdir=$wdir/braker1