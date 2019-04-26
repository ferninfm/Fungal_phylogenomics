#!/usr/bin/Rscript
#---------------------------------------------------#
#  NAIVE PARSING OF BUSCO OUTPUT FOR PHYLOGENOMICS  #
#  FFM 2016                                         #
#  fernandf@uni-graz.at                             #
#---------------------------------------------------#

parse.buscos<-function(tabla,dna,short.names,outpath)
	{
		require(ape)
		for (j in 1:length(tabla))
  	      		{
  			      a<-read.table(tabla[j])
			      a<-as.matrix(a)
			      a<-a[a[,2]=="Complete",]
			      b<-read.dna(dna[j],format="fasta")
			      if (is.list(b)==FALSE) b<-as.list(b)
			      for (i in 1:dim(a)[1])
			      {
				foo.dim<-c(min(as.numeric(a[i,4:5])),max(as.numeric(a[i,4:5])))
				if (foo.dim[1]<1) foo.dim[1]<-1
				if (foo.dim[2]>length(b[as.character(a[i,3])][[1]])) foo.dim[2]<-length(b[as.character(a[i,3])][[1]])
				foo.seq<-as.matrix(b[as.character(a[i,3])])
				foo.seq<-foo.seq[foo.dim[1]:foo.dim[2]]
				foo.file<-paste(outpath,a[i,1],".fasta",sep="")
				foo.name<-short.names[j]
  				write (paste(">",foo.name,sep=""),foo.file,append=T)
  				write(paste(as.character(foo.seq),collapse=""),foo.file,append=T)
				}
			}
		}
#
# Get arguments
#
args <- commandArgs(trailingOnly = TRUE)
#
# Conditional info
#
if(length(args)<4){
    cat("NAIVE PARSING OF BUSCO OUTPUT FOR PHYLOGENOMICS\n\n---------------------------------------\n\nInsufficient arguments were supplied in the command line.\n\n----------------------------\n\nThe default arguments are:\n\t-tabla: path to the busco table\n\t-dna: path to the genome assembly file in fasta format\n\t-short.names: sample/species name\n\t-outpath: path to the output folder\n\n---------------------------------------\n\nExample of use: Rscript parse_busco.r ./01_uno/x1.txt ./01_uno/x1.fasta x1 ./03_alignments/")
}else{
parse.buscos(tabla=args[1],dna=args[2],short.names=args[3],outpath=args[4])
}
#parse.buscos(tabla=c('/home/symbiont/genomics_course/day-4/task_2/input_files/x1.txt',
#	'/home/symbiont/genomics_course/day-4/task_2/input_files/x2.txt',
#	'/home/symbiont/genomics_course/day-4/task_2/input_files/x3.txt',
#	'/home/symbiont/genomics_course/day-4/task_2/input_files/x4.txt',
#	'/home/symbiont/genomics_course/day-4/task_2/input_files/xanpa.txt'),
#dna=c('/home/symbiont/genomics_course/day-4/task_2/input_files/x1.fasta',
#    '/home/symbiont/genomics_course/day-4/task_2/input_files/x2.fasta',
#    '/home/symbiont/genomics_course/day-4/task_2/input_files/x3.fasta',
#    '/home/symbiont/genomics_course/day-4/task_2/input_files/x4.fasta',
#    '/home/symbiont/genomics_course/day-4/task_2/input_files/xanpa.fasta'),
#short.names=c("X1","X2","X3","X4","Xanpa"),
#outpath="/home/symbiont/genomics_course/day-4/task_2/fastas/")
