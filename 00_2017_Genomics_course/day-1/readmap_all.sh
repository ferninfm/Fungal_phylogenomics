#!/bin/bash
# written by Philipp Resl

#get list of file:
cd trimmed_reads
files=$(ls renamed_*R1*)
cd ..
echo "Building index file:"
#build index from trusted fungal contigs file.
bowtie2-build ~/data/peltigera/Peltigera_membranacea/additional_data/Pmem_fungal_scaffolds_DNA_cleaned-up/Pmem_mycobiont_scaffold_1line.fasta ./02_bowtie/Pmem_fungal_index.build
echo "building index done"
samfile_base=pmem_readmap_
counter=0
for d in $files
do
	name1=./trimmed_reads/$d
	d2=$(echo $d | sed -e "s/_R1_/_R2_/g")
	name2=./trimmed_reads/$d2
	echo $d
	echo $d2
	((++counter))
	samfile=$samfile_base$counter
	bowtie2 -p 24 -q --phred33 --fr -x ./02_bowtie/Pmem_fungal_index.build -1 $name1 -2 $name2 -S ./02_bowtie/$samfile.sam
	echo "Reads mapped"
	samtools view -bS ./02_bowtie/$samfile.sam | samtools sort - ./02_bowtie/$samfile
	echo "Bamfile created"
done
echo "Merge and sort all files"
#merg sort and index big BMA file
samtools merge -r ./02_bowtie/all_samples_merged.bam ./02_bowtie/*.bam
samtools sort ./02_bowtie/all_samples_merged.bam ./02_bowtie/all_samples_merged_sorted
samtools index ./02_bowtie/all_samples_merged_sorted.bam ./02_bowtie/all_samples_merged_sorted.bai