#!/usr/bin/env bash

#make some krona charts

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=6:mem=35gb
#PBS -l walltime=8:00:00
#PBS -l cput=8:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

CONFIG=$SCRIPT_DIR/config.sh

if [[ -e $CONFIG ]]; then
    source $CONFIG
else
    echo "errg no config"
    exit 1
fi

echo "Time started: $(date)"

cd $UNIQ_BLAST_OR

echo Making Krona Charts
time ktImportTaxonomy \
    -o $KRONA_OR_DIR/or_samples.html \
    -q 1 \
    -t 14 \
    -s 13 \
    IonXpress_037_ORSample_179-2R.best_single_hits \
    IonXpress_027_ORsample_7-2.best_single_hits \
    IonXpress_035_ORSample_71-2R.best_single_hits \
    IonXpress_039_ORSample_199-2.best_single_hits \
    IonXpress_033_ORsample_112-2.best_single_hits \
    IonXpress_026_ORsample_6-2.best_single_hits \
    IonXpress_040_ORSample_200-2.best_single_hits \
    IonXpress_028_ORsample_8-2.best_single_hits \
    IonXpress_032_ORsample_94-2.best_single_hits \
    IonXpress_024_ORsample_5-2R.best_single_hits \
    IonXpress_041_ORsample_209-2.best_single_hits \
    IonXpress_030_ORsample_211-2.best_single_hits \
    IonXpress_042_ORSample_212-2.best_single_hits \
    IonXpress_029_ORsample_309-2.best_single_hits \
    IonXpress_043_ORsample_214-2.best_single_hits \
    IonXpress_034_ORSample_52-2.best_single_hits \
    IonXpress_036_ORSample_71-2L.best_single_hits \
    IonXpress_031_ORsample_306-2.best_single_hits \
    IonXpress_025_ORsample_5-2L.best_single_hits
    

cd $UNIQ_BLAST_LONG

time ktImportTaxonomy \
    -o $KRONA_LONG_DIR/longitudinal_samples.html \
    -q 1 \
    -t 14 \
    -s 13 \
    DFU_WGS_BC072_pt57_tube79-2_1scissors.best_single_hits \
    DFU_WGS_BC073_pt57_tube79-2_2slightcurrettage.best_single_hits \
    DFU_WGS_BC075_pt57_tube79-2_3deepcurretage.best_single_hits \
    DFU_WGS_BC076_pt57_tube208-2curretage.best_single_hits \
    DFU_WGS_BC077_pt57_tube257-2scissors.best_single_hits \
    DFU_WGS_BC078_pt82_tube144-2leakageswab.best_single_hits \
    DFU_WGS_BC079_pt82_tube169-2leakageswab.best_single_hits \
    DFU_WGS_BC080_pt82_tube206-2leakageswab.best_single_hits \
    DFU_WGS_BC081_pt82_tube245-2scissors.best_single_hits \
    DFU_WGS_BC082_pt82_tube261-2scissors.best_single_hits \
    DFU_WGS_BC083_pt82_tube285-2tissueswab.best_single_hits

echo "Time ended: $(date)"

