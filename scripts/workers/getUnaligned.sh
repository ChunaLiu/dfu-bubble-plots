#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=6:mem=34gb
#PBS -l walltime=12:00:00
#PBS -l cput=12:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

source $SCRIPT_DIR/config.sh

set -u

module load samtools

echo "Started at $(date) on host $(hostname)"

TMP_FILES=$(mktemp)

get_lines $LIST $TMP_FILES $FILE_START $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

echo "Found $NUM_FILES files to process"

while read BAM; do

    BASE=$(basename $BAM .bam)

    echo "Getting non-human reads from $BASE"

    if [[ $BAM =~ "Long" ]]; then

        samtools view -b -f 4 $BAM > "$DNA_LONG_DIR"/"$BASE".bam.un

    else

        samtools view -b -f 4 $BAM > "$DNA_OR_DIR"/"$BASE".bam.un
    
    fi

    echo "Done with $BASE hopefully that worked"

done < "$TMP_FILES"

echo "Done at $(date)"
