#!/usr/bin/env python

# written by Philipp Resl
# this script converts RNA to DNA sequences


import sys # needed to parse command line arguments

help_message = """
This script will convert fasta files containing RNA sequences to DNA.

Usage: $ RNAtoDNA.py fastaRNAsequencefile.fas > fastaDNAsequencefile.fas
"""

# check if the script has the right number of input parameters
if len(sys.argv) < 2:
	sys.stderr.write(help_message)
	quit()
else:
	FileName = sys.argv[1]

# open the sequence file
RNASequencefile = open(FileName, "r")

for line in RNASequencefile: # loop through all the lines in the file
	if line.startswith(">"):
		print line.strip()
	else:
		line = line.replace("U","T") # replace all Us for Ts
		print line.strip()

RNASequencefile.close() #close the file
