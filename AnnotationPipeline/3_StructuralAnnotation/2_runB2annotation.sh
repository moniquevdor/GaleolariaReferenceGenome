#!/bin/bash

module load singularity

SING="singularity run -B /fs02 -B /fs03 -B /fs04 -B /scratch -B /projects ../../braker3.sif"

wdir={your_path_to_directory}

$SING braker.pl --AUGUSTUS_CONFIG_PATH={your_path}/Augustus/config --COMPLEASM_PATH={your_path}/compleasm_kit/ --GENEMARK_PATH={your_path}/GeneMark-ETP/bin/ --species=GaleoHap1 --useexisting --genome={your_path}/ChromAssemblyHap1Final_masked.fasta --softmasking --prot_seq={your_path}/AnnelidProtein.fasta --workingdir=$wdir/braker2
