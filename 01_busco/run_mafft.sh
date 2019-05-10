#!/bin/bash
# 
cd ./03_fastas
files=$(ls renamed_*.fna)
cd ..
for FILE in $files
do
    echo $FILE
    mafft --auto ./03_fastas/$FILE > ./04_alignments/aligned_${FILE}
done
