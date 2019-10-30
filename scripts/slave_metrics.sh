#!/bin/bash

source /home/icb/daniel.strobl/.bashrc
source activate sc-tutorial 

INPUTFILE=$1
INTEGRATIONFILE=$2
OUTDIR=$3
BATCH=$4
CELLTYPE=$5
ORGANISM=$6
TYPE=$7
HVGS=$8

if [ $# -eq 0 ]
  then
    echo "To run this script:"
    echo "slave_integration.sh <input file> <the nanme of batch column> <number of HVGS> <output directory> <method>"
    exit
fi


# Check if the integration file exists
if [ ! -f ${INTEGRATIONFILE} ]; then
    echo "The integration file doesn't exist: ${INTEGRATIONFILE}"
    exit
fi


NODE_TMP=/localscratch/scib_run
NODE_PYTHON=/home/icb/daniel.strobl/miniconda3/envs/sc-tutorial/bin/python
NODE_PYSCRIPT=/home/icb/daniel.strobl/Benchmarking_data_integration/scripts/metrics.py

FBASE=${INPUTFILE##*/}
FPREF=${FBASE%.*}

FBASE_INT=${INTEGRATIONFILE##*/}
FPREF_INT=${FBASE_INT%.*}


# create the temporary directory if not exist
if [ ! -d "$NODE_TMP" ]; then
  mkdir ${NODE_TMP}
fi

# create the output directory in temp if not exist
NODE_WORKDIR_OUT=${NODE_TMP}/output_metrics

if [ ! -d "$NODE_WORKDIR_OUT" ]; then
  mkdir ${NODE_WORKDIR_OUT}
fi

# Once, copy the input file into temp directory
NODE_INPUTFILE=${NODE_TMP}/${FBASE}

if [ ! -f ${NODE_INPUTFILE} ]; then
    cp ${INPUTFILE} ${NODE_TMP}/.
fi

# The result file of runintegration should be in /output.
# If not, once, copy the integration file into temp directory
NODE_INTEGRATIONFILE=${NODE_TMP}/output/${FBASE_INT}

if [ ! -f ${NODE_INTEGRATIONFILE} ]; then
    cp ${INTEGRATIONFILE} ${NODE_TMP}/output/.
fi

NODE_OUTPUTFILE=${NODE_WORKDIR_OUT}/${FPREF_INT}_hvg${HVGS}

echo "Starting"


${NODE_PYTHON} -s ${NODE_PYSCRIPT} -u ${NODE_INPUTFILE} -i ${NODE_INTEGRATIONFILE} -o ${NODE_OUTPUTFILE} -b ${BATCH} -l ${CELLTYPE} --organism ${ORGANISM} --type ${TYPE} --hvgs ${HVGS}  

echo "Done. Copying the result files from /localscratch to the indicated directory"
if [ ! -d "${OUTDIR}/output_metrics" ]; then
  mkdir ${OUTDIR}/output_metrics
fi
cp -n ${NODE_OUTPUTFILE}* ${OUTDIR}/output_metrics/.

# All temporary files and directories won't be removed since we can reuse them again and again
# Before returning a node to Aliaksey, we do need to manually remove everything in /localscratch

