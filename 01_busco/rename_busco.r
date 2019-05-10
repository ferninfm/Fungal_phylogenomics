#!/usr/bin/Rscript
#---------------------------------------------------#
#  NAIVE PARSING OF BUSCO OUTPUT FOR PHYLOGENOMICS  #
#  FFM 2019                                         #
#  fernandf@uni-graz.at                             #
#---------------------------------------------------#
Sys.setenv(LANG="en_US.UTF-8")
#
# Get arguments
#
args <- commandArgs(trailingOnly = TRUE)
#
# Conditional info
#
if(length(args)<2)
    {
    cat("NAIVE PARSING OF BUSCO OUTPUT FOR PHYLOGENOMICS\n\n---------------------------------------\n\nI
    Insufficient arguments were supplied in the command line.
    \n\n----------------------------\n\n
    You must provide a path to the folder where single gene fasta files are placed\n
    the number of individuals required for the downstream use of BUSCO
    Example of use: Rscript rename_busco.r \"./03_fastas\" 10\n\n")
    }else{
  #
  # Check and install ape
  #
  if (!require("ape",character.only = TRUE))
      {
        install.packages("ape",dep=TRUE)
        if(!require("ape",character.only = TRUE)) stop("Ape Package not found")
      }
  if (!require("seqinr",character.only = TRUE))
      {
      install.packages("seqinr",dep=TRUE)
      if(!require("seqinr",character.only = TRUE)) stop("Sequinr Package not found")
      }
  if (!require("reshape2",character.only = TRUE))
      {
      install.packages("reshape2",dep=TRUE)
      if(!require("reshape2",character.only = TRUE)) stop("reshape2 Package not found")
      }
  require (ape)
  require (seqinr)
  require (reshape2)
  #
  #Start processing
  #
  setwd(args[1])
  foo<-list.files(args[1])
  all_fastas_nuc<-list()
  all_fastas_aa<-list()
  #
  # work with dna.fasta
  #
  i=1
  for (FILE in foo[sapply(strsplit(foo,"\\."),`[`,2)=="fna"])
    {
    foo_seq<-read.dna(FILE,format="fasta",as.matrix=FALSE)
    names(foo_seq)<-substr(sapply(strsplit(names(foo_seq),":"),`[`,2),3,8)
    if (length(foo_seq)>=args[2])
      {
      write.dna(foo_seq,paste("renamed_",FILE,sep=""),format="fasta",nbcol=-1,colsep="")
      }
    all_fastas_nuc[[i]]<-names(foo_seq)
    names(all_fastas_nuc)[i]<-FILE
    i=i+1
  }
  #
  # work with aa fasta
  #
  for (FILE in foo[sapply(strsplit(foo,"\\."),`[`,2)=="faa"])
  {
    foo_seq<-read.fasta(FILE,seqtype="AA")
    names(foo_seq)<-substr(sapply(strsplit(names(foo_seq),":"),`[`,2),3,8)
     if (length(foo_seq)>=args[2])
      {
      write.fasta(foo_seq,paste("renamed_",FILE,sep=""),names=names(foo_seq))
      }
  }
  all_fastas_nuc<-t(table(melt(all_fastas_nuc)))
  all_fastas_nuc<-cbind(all_fastas_nuc,completeness=rowSums(all_fastas_nuc))
  foo<-all_fastas_nuc[all_fastas_nuc[,"completeness"]>=args[2],]
  all_fastas_nuc<-rbind(all_fastas_nuc,representation=colSums(all_fastas_nuc))
  foo<-rbind(foo,representation=colSums(foo))
  writeLines("#\n#######################################\n# Complete dataset\n","report_completeness.txt")
  write.table(all_fastas_nuc,"report_completeness.txt",sep="\t",quote=FALSE,append=TRUE)
  writeLines("#\n#######################################\n# Reduced dataset\n","report_completeness.txt")
  write.table(all_fastas_nuc,"report_completeness.txt",sep="\t",quote=FALSE,append=TRUE)
  pdf("completeness_histogram.pdf")
  hist(all_fastas_nuc[,"completeness"],col="blue")
  abline(v=args[2],col="red")
  dev.off()
}

