#!/bin/bash
#SBATCH -J MitoHiFi             
#SBATCH -o MitoHiFi.out      
#SBATCH -e MitoHiFi.e  
#SBATCH --account=tn20  
#SBATCH -p genomics
#SBATCH --qos=genomics  
#SBATCH --ntasks 1                  
#SBATCH --cpus-per-task 5                
#SBATCH --mem=16G
#SBATCH --mail-user=monique.vandorssen@monash.edu 
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH -t 0:30:00

# Run MitoHiFi to pull out mitochondrial genome from raw genome assembly (on M3 cluster)
# https://github.com/marcelauliano/MitoHiFi

module load blast
module load singularity

SING="singularity run -B /fs02 -B /fs03 -B /fs04 -B /scratch -B /projects /fs03/tn20/Monique/referencegenome/containers/mitohifi.sif"


$SING mitohifi.py -c /fs03/tn20/Monique/referencegenome/genome/FinalGenome/GenomeAssembly/FinalAssembly/Scaffold_level/hap1_assembly_raw.fa -f NC_061743.1.fasta -g NC_061743.1.gb --mitos -a animal -t 5 -o 5