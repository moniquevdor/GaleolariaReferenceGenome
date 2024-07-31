#!/bin/bash
#SBATCH -J Braker2             
#SBATCH -o Braker2.out      
#SBATCH -e Braker2.e  
#SBATCH --account=tn20    
#SBATCH -n 1                  
#SBATCH -c 35                                
#SBATCH --mail-user=monique.vandorssen@monash.edu 
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH -t 7-00:00:00

module load singularity

SING="singularity run -B /fs02 -B /fs03 -B /fs04 -B /scratch -B /projects ../../braker3.sif"

wdir=/fs03/tn20/Monique/referencegenome/5_Annotation/Annotation_H1/

$SING braker.pl --AUGUSTUS_CONFIG_PATH=/fs03/tn20/Monique/referencegenome/5_Annotation/Augustus/config --COMPLEASM_PATH=/fs03/tn20/Monique/referencegenome/5_Annotation/compleasm_kit/ --GENEMARK_PATH=/fs03/tn20/Monique/referencegenome/5_Annotation/GeneMark-ETP/bin/ --species=GaleoHap1 --useexisting --genome=../ChromAssemblyHap1Final_masked.fasta --softmasking --prot_seq=../AnnelidProtein.fasta --workingdir=$wdir/braker2

# --epmode 