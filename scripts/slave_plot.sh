#!/bin/bash

source /home/icb/daniel.strobl/.bashrc
source activate sc-tutorial 

INPUTFILE=$1
BATCH=$3
HVGS=$6
OUTDIR=$2
MODE=$5
CELLTYPE=$4

if [ $# -eq 0 ]
  then
    echo "To run this script:"
    echo "slave_integration.sh <input file> <the nanme of batch column> <number of HVGS> <output directory> <method>"
    exit
fi

NODE_TMP=/localscratch/scib_run
NODE_PYTHON=/home/icb/daniel.strobl/miniconda3/envs/sc-tutorial/bin/python
NODE_PYSCRIPT=/home/icb/chaichoompu/Group/workspace/Benchmarking_data_integration_branch_ATAC/Benchmarking_data_integration/scripts/run_plot.py

${NODE_PYTHON} ${NODE_PYSCRIPT} -i ${INPUTFILE} -o ${OUTDIR} -b ${BATCH} -l ${CELLTYPE} -m ${MODE} --hvgs ${HVGS}