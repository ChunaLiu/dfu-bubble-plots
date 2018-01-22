#script to narrow down the taxa in the nt database
#essentially we want:
#1) have list from the centrifuge-inspect --taxid_list nt.cf
#2) remove all taxids that belong to bacteria domain (guess we could do viruses and archaea too)
#3) use that resulting list as the --exclude-ids parameter in the centrifuge run

library(taxize)

setwd("~/dfu-bubble-plots/taxa")

allTaxa <- read.delim("taxa_tree",header = F,quote = "")

allTaxa <- allTaxa[,c(1,3,5)]

colnames(allTaxa)=c("child","parent","childRank")

phylumUnderBact <- allTaxa[allTaxa$parent==2,]

classUnderBact <- allTaxa[allTaxa$parent %in% phylumUnderBact$child,]

ordersUnderBact <- allTaxa[allTaxa$parent %in% classUnderBact$child,]

familiesUnderBact <- allTaxa[allTaxa$parent %in% ordersUnderBact$child,]

genusUnderBact <- allTaxa[allTaxa$parent %in% familiesUnderBact$child,]

speciesUnderBact <- allTaxa[allTaxa$parent %in% genusUnderBact$child,]

#omg, all we really have to do is find the kingdom taxids that are not in
#["bacteria","virus","archaea"]
#since centrifuge will do:
#--exclude-taxids
#A comma-separated list of taxonomic IDs that will be excluded in classification #procedure. The descendants from these IDs will also be exclude.

unique(allTaxa$childRank)

superKingdoms <- allTaxa[allTaxa$childRank=="superkingdom",]

classification(x=superKingdoms$child, db="ncbi",return_id = F,start=0)
#weird, it gets bacteria, archaea and eukaryota but not viruses (10239) or
#viroids (12884)

kingdoms <- allTaxa[allTaxa$childRank=="kingdom",]

classification(x=kingdoms$child, db="ncbi",return_id = F,start=0)

classification(allTaxa[allTaxa$childRank=="subkingdom",]$child, db="ncbi",return_id = F,start=0)

noRank = allTaxa[allTaxa$childRank=="no rank",]

#classification($child, db="ncbi",return_id = F,start=0)


#ok, for --exclude-taxids, let's do:
# 2759 Eurkaryota
# 81077 Artificial Sequences (which includes those "synthetic constructs")
