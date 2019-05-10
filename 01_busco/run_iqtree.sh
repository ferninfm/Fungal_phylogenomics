#!/bin/bash
cp ./05_trimmed/*.fna ./06_iqtree
cd ./06_iqtree
files=$(ls)
for FILE in $files
do
        iqtree -s $FILE -m MFP -o Xanpa2 -bb 1000 -bnni -nt 8
        rm $FILE
done
cd ..
