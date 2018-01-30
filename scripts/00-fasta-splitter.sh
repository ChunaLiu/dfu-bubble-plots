#
# This script is intended to break up your fasta files into more manageable chunks
#

source ./config.sh

PROG=`basename $0 ".sh"`
STDERR_DIR="$CWD/err/$PROG"
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDERR_DIR" "$STDOUT_DIR" "$SPLIT_FA_DIR"

cd "$FASTA_DIR"

export FILES_LIST="$FASTA_DIR/files-list"

pwd

find . -type f -name \*.faa | sed "s/^\.\///" > $FILES_LIST

NUM_FILES=$(lc $FILES_LIST)

echo Found \"$NUM_FILES\" files in \"$FASTA_DIR\"

if [ $NUM_FILES -gt 0 ]; then
    JOB_ID=`qsub -V -N split-fa -e "$STDERR_DIR" -o "$STDOUT_DIR" $SCRIPT_DIR/split_fa.sh`
    echo Submitted job \"$JOB_ID.\"  Adios.
else
    echo Nothing to do.
fi
