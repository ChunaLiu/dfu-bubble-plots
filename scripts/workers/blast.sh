#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=12:mem=34gb
#PBS -l walltime=12:00:00
#PBS -l cput=144:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

set -u

CONFIG="$SCRIPT_DIR/config.sh"

if [[ -e $CONFIG ]]; then
    source $CONFIG
else
    echo "no config file"
    exit 1
fi

module load blast

echo "Started at $(date) on host $(hostname)"

TMP_FILES=$(mktemp)

get_lines $TODO $TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

echo "Found $NUM_FILES files to process"

while read FASTQ; do

    BASE=$(basename $FASTQ _trimmed.fq)

    echo "Blasting $FASTQ against $BLASTDB"

    if [[ $FASTQ =~ "Long" ]]; then

      fastq-to-fasta.py -o- $FASTQ | blastn -db $BLASTDB \
          -query - -num_alignments $NUMALNS -perc_identity $IDENT \
          -qcov_hsp_perc $QCOV -num_threads 12 \
          -out $BLAST_LONG_DIR/$BASE.blast \
          -outfmt '6 qaccver saccver pident qcovhsp length mismatch gapopen qstart qend sstart send evalue bitscore staxid'

    else

       fastq-to-fasta.py -o- $FASTQ | blastn -db $BLASTDB \
          -query - -num_alignments $NUMALNS -perc_identity $IDENT \
          -qcov_hsp_perc $QCOV -num_threads 12 \
          -out $BLAST_OR_DIR/$BASE.blast \
          -outfmt '6 qaccver saccver pident qcovhsp length mismatch gapopen qstart qend sstart send evalue bitscore staxid'
    
    fi

    echo "Done with $BASE hopefully that worked"

done < "$TMP_FILES"

echo "Done at $(date)"
