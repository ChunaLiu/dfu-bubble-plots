#!/usr/bin/env bash
#
# runs blastn
#

set -u
source ./config.sh
export CWD="$PWD"
#batches of N
export STEP_SIZE=1

PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/pbs_logs/$PROG"

init_dir "$STDOUT_DIR" 

cd $PRJ_DIR

export FaaLIST="$MY_TEMP_DIR"/"faa_list"

find $GENE_CALLS "*.faa" > $FaaLIST

mkdir -p $BLAST_DIR


export TODO="$MY_TEMP_DIR"/"files_todo"

if [ -e $TODO ]; then
    rm $TODO
fi

echo "Checking if trimming has already been done for dna"

#while read FASTQ; do
#
#        if [ ! -e "$BLAST_DIR/$(basename $FASTQ _trimmed.fq).blast" ]; then
#            echo $FASTQ >> $TODO
#        fi

#done < $FaaLIST

NUM_FILES=$(lc $TODO)

echo Found \"$NUM_FILES\" files in \"$PRJ_DIR\" to work on

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N trimgalore -j oe -o "$STDOUT_DIR" $WORKER_DIR/blast.sh)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\" why me worry?.
else`
  echo -e "\nError submitting job\n$JOB\n"
fi

