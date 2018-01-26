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

export LIST="$MY_TEMP_DIR"/bam_list

find $OR_DIR $LONG_DIR -iname "*.bam" | sed "s/^\.\///" | sort > $LIST

mkdir -p $DNA_OR_DIR
mkdir -p $DNA_LONG_DIR

NUM_FILES=$(lc $LIST)

echo "Found $NUM_FILES to process"

echo "Splitting them up in batches of $STEP_SIZE"

let i=1

while (( "$i" <= "$NUM_FILES" )); do
    export FILE_START=$i
    echo Doing file $i plus 9 more if possible
    JOB=$(qsub -V -N get-unaligned -j oe -o "$STDOUT_DIR" $WORKER_DIR/getUnaligned.sh)
    if [ $? -eq 0 ]; then
      echo "Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\""
    else
      echo -e "\nError submitting job\n$JOB\n"
    fi
    (( i += $STEP_SIZE )) 
done
