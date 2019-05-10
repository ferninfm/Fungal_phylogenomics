#!/bin/bash
# 
cd ./04_alignments
files=$(ls *.fna)
for FILE in $files
do
    echo $FILE
    trimal -gappyout -in $FILE -out trimmed_${FILE} -fasta -htmlout visualization_${FILE}.html
done
mv trimmed_* ../05_trimmed
mv visualization_* ../05_trimmed
cd ..
