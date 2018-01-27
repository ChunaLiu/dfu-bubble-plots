#!/usr/bin/env bash

#
#script to bam to fastq#


set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=10

PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/pbs_logs/$PROG"

init_dir "$STDOUT_DIR"

export LIST="$MY_TEMP_DIR"/bam_un_list

find $DNA_OR_DIR $DNA_LONG_DIR -iname "*.bam.un" | sed "s/^\.\///" | sort > $LIST

NUM_FILES=$(lc $LIST)

echo "Found $NUM_FILES to process"

echo "Splitting them up in batches of $STEP_SIZE"

let i=1

while (( "$i" <= "$NUM_FILES" )); do
    export FILE_START=$i
    echo Doing file $i plus 9 more if possible
    JOB=$(qsub -V -N bamToFastq -j oe -o "$STDOUT_DIR" $WORKER_DIR/bamToFastq.sh)
    if [ $? -eq 0 ]; then
      echo "Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\""
    else
      echo -e "\nError submitting job\n$JOB\n"
    fi
    (( i += $STEP_SIZE )) 
done
