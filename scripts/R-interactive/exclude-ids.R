#script to narrow down the taxa in the nt database
#essentially we want:
#1) have list from the centrifuge-inspect --taxid_list nt.cf
#2) remove all taxids that belong to bacteria domain (guess we could do viruses and archaea too)
#3) use that resulting list as the --exclude-ids parameter in the centrifuge run
