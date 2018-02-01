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

export FQLIST="$MY_TEMP_DIR"/"fastq_list"

find $TM_OR_DIR $TM_LONG_DIR -iname "*_trimmed.fq" > $FQLIST

mkdir -p $BLAST_OR_DIR
mkdir -p $BLAST_LONG_DIR

export TODO="$MY_TEMP_DIR"/"files_todo"

if [ -e $TODO ]; then
    rm $TODO
fi

echo "Checking if blast has already been done for a file"

while read FASTQ; do

    if [[ $FASTQ =~ "Long" ]]; then

        if [ ! -e "$BLAST_LONG_DIR/$(basename $FASTQ _trimmed.fq).blast" ]; then
            echo $FASTQ >> $TODO
        fi

    else

        if [ ! -e "$BLAST_OR_DIR/$(basename $FASTQ _trimmed.fq).blast" ]; then
            echo $FASTQ >> $TODO
        fi

    fi

done < $FQLIST

NUM_FILES=$(lc $TODO)

echo Found \"$NUM_FILES\" files in \"$PRJ_DIR\" to work on

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N blastn -j oe -o "$STDOUT_DIR" $WORKER_DIR/blast.sh)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\" why me worry?.
else
  echo -e "\nError submitting job\n$JOB\n"
fi

