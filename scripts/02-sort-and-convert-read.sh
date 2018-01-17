#!/usr/bin/env bash

#
#script that takes the single bam from TCGA
#1)sorts it by query/read name
#2)converts it to fastq
#3)repairs them so you have forward, reverse, and singleton files
#

set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=10

PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

export LIST="$PRJ_DIR"/bam_list

find $HARMONIZED -iname "*.bam" | sed "s/^\.\///" | sort > $LIST

NUM_FILES=$(lc $LIST)

echo "Found $NUM_FILES to process"

echo "Splitting them up in batches of $STEP_SIZE"

let i=1

while (( "$i" <= "$NUM_FILES" )); do
    export FILE_START=$i
    echo Doing file $i plus 9 more if possible
    JOB=$(qsub -V -N sort-and-prep -j oe -o "$STDOUT_DIR" $WORKER_DIR/sort-and-prep.sh)
    if [ $? -eq 0 ]; then
      echo "Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\""
    else
      echo -e "\nError submitting job\n$JOB\n"
    fi
    (( i += $STEP_SIZE )) 
done
