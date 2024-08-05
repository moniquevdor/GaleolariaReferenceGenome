#!/bin/bash

#load modules
module load star

#generate genome index
STAR --runThreadN 6 --runMode genomeGenerate --genomeDir {your_path}/Genome_indices/ --genomeFastaFiles {your_path}/ChromAssemblyHap1Rearranged.fasta --genomeSAindexNbases 13  

# Set the directory where your fastq.gz files are located
FASTQ_DIR="{your_path}/out_dir"

# Set the directory where you want to store the alignment results
OUTPUT_DIR="{your_path}/star_align_output"

# Set the path to your STAR genome index directory
GENOME_DIR="{your_path}/Genome_indices"

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


