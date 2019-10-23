#!/bin/bash

# To deactivate any conda environment if exist
conda deactivate

conda activate sc-tutorial 

INPUTFILE=$1
BATCH=$2
HVGS=$3
OUTDIR=$4

if [ $# -eq 0 ]
  then
    echo "To run this script:"
    echo "slave_integration.sh <input file> <the nanme of batch column> <number of HVGS> <output directory> <method>"
fi

NODE_TMP=/localscratch/scib_run
NODE_PYTHON=/home/icb/daniel.strobl/miniconda3/envs/sc-tutorial/bin/python
#NODE_PYSCRIPT=/home/icb/daniel.strobl/Benchmarking_data_integration/scripts/runIntegration.py
NODE_PYSCRIPT=/home/icb/chaichoompu/Benchmarking_data_integration/scripts/runIntegration.py

FBASE=${INPUTFILE##*/}
FPREF=${FBASE%.*}

# create the temporary directory if not exist
if [ ! -d "$NODE_TMP" ]; then
  mkdir ${NODE_TMP}
fi

# create the output directory in temp if not exist
NODE_WORKDIR_OUT=${NODE_TMP}/output

if [ ! -d "$NODE_WORKDIR_OUT" ]; then
  mkdir ${NODE_WORKDIR_OUT}
fi

# Once, copy the input file into temp directory
NODE_INPUTFILE=${NODE_TMP}/${FBASE}

if [ ! -f ${NODE_INPUTFILE} ]; then
    cp ${INPUTFILE} ${NODE_TMP}/.
fi

for METHOD in bbknn scanorama harmony conos seurat trvae mnn
do

NODE_OUTPUTFILE=${NODE_WORKDIR_OUT}/${FPREF}_${METHOD}.h5ad

${NODE_PYTHON} -s ${NODE_PYSCRIPT} -i ${NODE_INPUTFILE} -o ${NODE_OUTPUTFILE} -b ${BATCH} -v ${HVGS} -m ${METHOD} 

# add a bit of delay, otherwise it will be too overloaded for Slurm
sleep 0.3

done

if [ ! -d "${OUTDIR}/output" ]; then
  cp -rf ${NODE_WORKDIR_OUT} ${OUTDIR}/.
else
  cp -n ${NODE_WORKDIR_OUT}/* ${OUTDIR}/output/.
fi


# All temporary files and directories won't be removed since we can reuse them again and again
# Before returning a node to Aliaksey, we do need to manually remove everything in /localscratch

