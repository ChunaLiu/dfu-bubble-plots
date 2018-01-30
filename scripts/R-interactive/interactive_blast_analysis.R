#interactive_blast_analysis.R

#header be like:
#qaccver saccver pident qcovhsp length mismatch gapopen qstart qend sstart send evalue bitscore staxid


#Long####
setwd("/Users/Scott/dfu-bubble-plots/dna/Long/blast_out/")

temp = list.files(pattern="*centrifuge_report.tsv")
myfiles = lapply(temp, read.delim)
sample_names <- as.list(sub("*centrifuge_report.tsv", "", temp))
myfiles = Map(cbind, myfiles, sample = sample_names)

#OR####
setwd("/Users/Scott/dfu-bubble-plots/dna/OR/blast_out/")
temp = list.files(pattern="*.blast")
myfiles = lapply(temp, function(x) {read.delim(file=x,header=F,col.names = c("qaccver", "saccver", "pident", "qcovhsp", "length", "mismatch", "gapopen", "qstart", "qend", "sstart", "send", "evalue", "bitscore", "staxid"))})
sample_names <- as.list(sub("*.blast", "", temp))
myfiles = Map(cbind, myfiles, sample = sample_names)

blast_table=myfiles[[1]]
