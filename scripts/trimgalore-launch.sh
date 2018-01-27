#!/usr/bin/env bash
#
# runs singularity fastqc.img trim_galore to trim adapters and low quality bases
#

set -u
source ./config.sh
export CWD="$PWD"
#batches of N
export STEP_SIZE=5

PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/pbs_logs/$PROG"

init_dir "$STDOUT_DIR" 


# --------------------------------------------------
# singularity is needed to run singularity images
module load singularity
# --------------------------------------------------
cd $PRJ_DIR

export FQLIST="$MY_TEMP_DIR"/"fastq_list"

find $UN_OR_DIR $UN_LONG_DIR -iname "*.fastq" > $FQLIST

mkdir -p $TM_OR_DIR
mkdir -p $TM_LONG_DIR

export TODO="$MY_TEMP_DIR"/"files_todo"

if [ -e $TODO ]; then
    rm $TODO
fi

echo "Checking if trimming has already been done for dna"

while read FASTQ; do

    if [[ $FASTQ =~ "Long" ]]; then

        if [ ! -e "$TM_LONG_DIR/$(basename $FASTQ .fastq)_trimmed.fq" ]; then
            echo $FASTQ >> $TODO
        fi

    else

        if [ ! -e "$TM_OR_DIR/$(basename $FASTQ .fastq)_trimmed.fq" ]; then
            echo $FASTQ >> $TODO
        fi

    fi

done < $FQLIST

NUM_FILES=$(lc $TODO)

echo Found \"$NUM_FILES\" files in \"$PRJ_DIR\" to work on

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N trimgalore -j oe -o "$STDOUT_DIR" $WORKER_DIR/trimgalore.sh)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\" grep me no patterns and I will tell you no lines.
else
  echo -e "\nError submitting job\n$JOB\n"
fi

