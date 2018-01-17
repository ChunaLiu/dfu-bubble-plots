#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=12:mem=68gb
#PBS -l walltime=24:00:00
#PBS -l cput=288:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

source $SCRIPT_DIR/config.sh

set -u

echo "Started at $(date) on host $(hostname)"

TMP_FILES=$(mktemp)

get_lines $LIST $TMP_FILES $FILE_START $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

echo "Found $NUM_FILES files to process"

while read BAM; do

    DIR=$(dirname $BAM)

    BASE=$(basename $BAM)

    echo "Sorting $BASE"

    samtools sort -n -@ 12 $BAM -o "$DIR"/sorted.bam

    echo "Converting $BASE to fastq"

    bamToFastq -i "$DIR"/sorted.bam -fq "$DIR"/sorted.fastq

    echo "Making forward, reverse and singleton files for $BASE"

    ~/bin/bbmap/repair.sh in="$DIR"/sorted.fastq \
        out="$DIR"/sorted.1.fastq \
        out2="$DIR"/sorted.2.fastq \
        outs="$DIR"/sorted.singleton.fastq

    echo "Done with $BASE hopefully that worked"

done < "$TMP_FILES"

echo "Done at $(date)"
