#!/usr/bin/env bash

#
#This script is intended to run kronatools on your samples 
#
unset module
set -u
source ./config.sh
export CWD="$PWD"

echo Setting up log files...
PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/pbs_logs/$PROG"

init_dir "$STDOUT_DIR"

#This is where you would put stuff to find all your samples
#And then make a list of files, change $NUM_FILES, etc.

echo Making output dir...
mkdir -p $KRONA_OR_DIR
mkdir -p $KRONA_LONG_DIR

JOB=$(qsub -V -N krona -j oe -o "$STDOUT_DIR" $WORKER_DIR/krona_chart.sh)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you. Do or do not. There is no try.
else
  echo -e "\nError submitting job\n$JOB\n"
fi
