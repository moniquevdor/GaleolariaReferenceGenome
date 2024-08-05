#!/bin/bash
#SBATCH -J star_align          
#SBATCH -o star_align.out      
#SBATCH -e star_align.e  
#SBATCH --account=tn20    
#SBATCH -n 1                  
#SBATCH -c 48                                
#SBATCH --mail-user=emily.belcher1@monash.edu 
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH -t 4-00:00:00   
cd /fs03/tn20/Em/2.Star/
module load star
# Set the directory where your fastq.gz files are located
FASTQ_DIR="/fs03/tn20/Em/1.FastP/out_dir"

# Set the directory where you want to store the alignment results
OUTPUT_DIR="/fs03/tn20/Em/2.Star/star_align_output"

# Set the path to your STAR genome index directory
GENOME_DIR="/fs03/tn20/Em/2.Star/Genome_indices"

# Ensure the output directory exists
mkdir -p $OUTPUT_DIR

# Loop through each R1 file in the FASTQ directory
for R1_FILE in $FASTQ_DIR/*_R1.fastq.gz
do
    # Derive the corresponding R2 file name
    R2_FILE=${R1_FILE/_R1.fastq.gz/_R2.fastq.gz}
    
    # Extract the sample name by removing the directory and _R1.fastq.gz
    SAMPLE_NAME=$(basename $R1_FILE _R1.fastq.gz)
    
    # Create a directory for the sample in the output directory
    SAMPLE_OUTPUT_DIR=$OUTPUT_DIR/$SAMPLE_NAME
    mkdir -p $SAMPLE_OUTPUT_DIR

    # Run the STAR aligner
    STAR --runThreadN 6 \
         --genomeDir $GENOME_DIR \
         --readFilesIn $R1_FILE $R2_FILE \
         --readFilesCommand zcat \
         --outFileNamePrefix $SAMPLE_OUTPUT_DIR/ \
         --outSAMtype BAM SortedByCoordinate 

    # Print a message indicating completion for the current sample
    echo "Completed alignment for $SAMPLE_NAME"
done



