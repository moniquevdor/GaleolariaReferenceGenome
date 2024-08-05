#!/bin/bash

module load fastp

for a in *R1.fastq.gz
do b=${a//R1.fastq.gz/R2.fastq.gz}
#echo $a $b
fastp -i $a -I $b -o {your_path}/out_$a -O {your_path}/out_dir/out_$b -h {your_path}/out_html/$a.html -j /{your_path}/out_json/$a.json
done
