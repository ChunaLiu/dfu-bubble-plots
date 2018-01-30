#Config.sh contains commonly used directories
#and functions if you need them
#main project directory and also where singularity images bind /work to
export BIND="/rsgrps/bhurwitz/cecilj/BLAST_01scott/BLAST"
export PRJ_DIR=$BIND

#scripts and such
export SCRIPT_DIR="$PRJ_DIR/scripts"
export WORKER_DIR="$SCRIPT_DIR/workers"

#main download / working directory
export OR_DIR="/rsgrps/bhurwitz/hurwitzlab/data/raw/GWATTS/WGS/DFUDengORsamples_confirmed_correct"
export LONG_DIR="/rsgrps/bhurwitz/hurwitzlab/data/raw/GWATTS/WGS/DFUDengLongitudinal_confirmed_correct"

#sample names
export SAMPLE_NAMES=(cancer control)

# place to put temp stuff like lists of files
export MY_TEMP_DIR="$PRJ_DIR/lists_of_files"

#Centrifuge Database Name ... up to but not including the ".1.cf"
#now using the full ncbi "nt" database
export CENT_DB="/rsgrps/bhurwitz/hurwitzlab/data/reference/cent_db/uncompressed/p+h+v"
export DB=$(basename $CENT_DB)

#what the name of the singularity centdb would be
export SING_CENT="/centdb"

#singularity images to run programs
export SING_IMG="/rsgrps/bhurwitz/scottdaniel/singularity-images"
#singularity directories subject to change
#common to all
export SING_WD="/work"
#in taxoner.img and bowcuff.img
export SING_BT2="/bt2"
#in bowcuff.img for bowtie2 output
export SING_OUT="/out"
#in taxoner.img
export SING_META="/metadata"
export SING_PRJ="/scripts"

#dna and reads (this is also where reports and trimmed reads go)
export Nos_PROKKAcalls_DIR="/rsgrps/bhurwitz/cecilj/PROKKA/BLASTdir"

#unaligned to human
export UN_OR_DIR="$DNA_OR_DIR/unaligned"
export UN_LONG_DIR="$DNA_LONG_DIR/unaligned"
#trimmed and qc'ed
export MINTRIMLEN=80
export TM_OR_DIR="$DNA_OR_DIR/trimmed"
export TM_LONG_DIR="$DNA_LONG_DIR/trimmed"
#blast stuff
export BLASTDB="/genome/refseq_protein"
export NUMALNS="1" #first best hit
export IDENT="70" #70% identity
export QCOV="85" #85% query coverage
export Nos_PBLAST_OUT="$DNA_OR_DIR/blast_out"

#centrifuge directory
export CFUGE_OR_DIR="$DNA_OR_DIR/cfuge"
export CFUGE_LONG_DIR="$DNA_LONG_DIR/cfuge"

#krona charts
export KRONA_OUT_DIR="$PRJ_DIR/krona_out"

#PATRIC bacterial genomes
export GENOME_DIR="$PRJ_DIR/genomes"

#PATRIC bowtie2 directory (for bowtie2 genome indices)
export BT2_DIR="$PRJ_DIR/bt2_index"
export GENOME="all.fa"
export GFF="allCDS.gff"
export RRNAGFF="rRNA.gff"

#bowtie2 output ALN = alignments
export ALN_DIR="$PRJ_DIR/alignments"

#export TESTFILE="/rsgrps/bhurwitz/scottdaniel/mg-sample-data/dna/cfuge/DNA_control_centrifuge_report.tsv"

###CENTRIFUGE STUFF####
#######################

#Single or Paired End Reads? (single || paired)
#IMPORTANT: For paired end files see README.md for additional information
export TYPE="single"

#FASTA/Q File Extension (common extensions include fasta, fa, fastq, fastq)
#DO NOT INCLUDE the dot "."
#examples : SRR1592394_1_val_1.fq.gz, SRR1592394_2_val_2.fq.gz
export FILE_EXT="fastq"

#Plot file name and title (No spaces, use _)
#export PLOT_FILE="HumanCRCbacteria"
#export PLOT_TITLE="HumanCRCbacteria"

#File type (Fasta or Fastq | fasta = f; fastq = q)
export FILE_TYPE="q"

#Exclude hits by stating taxid in following format ("taxid1,taxid2")
#9606 is human
#32630 are synthetic contructs (e.g. random illumina hexamer primer)
#374840 common contaminant = Enterobacteria phage phiX174 sensu lato
#1747 propionibacterium acnes = bacteria usually found on human skin
## 2759 Eurkaryota
# 81077 Artificial Sequences (which includes those "synthetic constructs")
#1456186 uncultured marine thaumarchaeote KM3_53_F08
#35779 Aster yellows phytoplasma
#Papio   9554
#Pan 9596
#Macaca radiata  9548
#export EXCLUDE="81077,374840,1747,1456186,35779,2759"
export EXCLUDE=""
#--exclude-taxids
#A comma-separated list of taxonomic IDs that will be excluded in classification procedure. The descendants from these IDs will also be exclude.

#include human back in per dr. watts' advice
#2 Bacteria superkingdom
#2157 Archaea superkingdom
#10239 Viruses
#12884 Viroids
#export INCLUDE="9606"
export INCLUDE=""
#--host-taxids
#A comma-separated list of taxonomic IDs that will be preferred in classification procedure. The descendants from these IDs will also be preferred. In case some of a read's assignments correspond to these taxonomic IDs, only those corresponding assignments will be reported.
#NB: the "include" list will override the exclude list... i.e. if INCLUDE="2" then 
#aster yellows phytoplasma (35779) would still be included
#
#
# --------------------------------------------------
function init_dir {
    for dir in $*; do
        if [ -d "$dir" ]; then
            rm -rf $dir/*
        else
            mkdir -p "$dir"
        fi
    done
}

# --------------------------------------------------
function lc() {
    wc -l $1 | cut -d ' ' -f 1
}

# --------------------------------------------------
function get_lines() {
  FILE=$1
  OUT_FILE=$2
  START=${3:-1}
  STEP=${4:-1}

  if [ -z $FILE ]; then
    echo No input file
    exit 1
  fi

  if [ -z $OUT_FILE ]; then
    echo No output file
    exit 1
  fi

  if [[ ! -e $FILE ]]; then
    echo Bad file \"$FILE\"
    exit 1
  fi

  awk "NR==$START,NR==$(($START + $STEP - 1))" $FILE > $OUT_FILE
}
