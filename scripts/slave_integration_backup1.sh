#!/bin/bash

if [ X"$SLURM_STEP_ID" = "X" -a X"$SLURM_PROCID" = "X"0 ]
then
  echo "print =========================================="
  echo "print SLURM_JOB_ID = $SLURM_JOB_ID"
  echo "print SLURM_JOB_NODELIST = $SLURM_JOB_NODELIST"
  echo "print =========================================="
fi

source /home/icb/daniel.strobl/.bashrc
source activate sc-tutorial 

INPUTFILE=$1
BATCH=$2
HVGS=$3
OUTDIR=$4
METHOD=$5

if [ $# -eq 0 ]
  then
    echo "To run this script:"
    echo "slave_integration.sh <input file> <the nanme of batch column> <number of HVGS> <output directory> <method>"
    exit
fi

NODE_TMP=/localscratch/scib_run
NODE_PYTHON=/home/icb/daniel.strobl/miniconda3/envs/sc-tutorial/bin/python
NODE_PYSCRIPT=/home/icb/chaichoompu/Group/workspace/Benchmarking_data_integration_branch_ATAC/Benchmarking_data_integration/scripts/runIntegration.py

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

echo "Starting ${METHOD}"

NODE_OUTPUTFILE=${NODE_WORKDIR_OUT}/${FPREF}_${METHOD}_hvg${HVGS}.h5ad

echo ${NODE_PYTHON} -s ${NODE_PYSCRIPT} -i ${NODE_INPUTFILE} -o ${NODE_OUTPUTFILE} -b ${BATCH} -v ${HVGS} -m ${METHOD} 

${NODE_PYTHON} -s ${NODE_PYSCRIPT} -i ${NODE_INPUTFILE} -o ${NODE_OUTPUTFILE} -b ${BATCH} -v ${HVGS} -m ${METHOD} 

#use this command when there is a conflict with different versions of libraries imported from /home
#${NODE_PYTHON} -s ${NODE_PYSCRIPT} -i ${NODE_INPUTFILE} -o ${NODE_OUTPUTFILE} -b ${BATCH} -v ${HVGS} -m ${METHOD} 

echo "Done ${METHOD}. Copying the result files from /localscratch to the indicated directory"
if [ ! -d "${OUTDIR}/output" ]; then
  mkdir ${OUTDIR}/output
fi
cp -f ${NODE_WORKDIR_OUT}/${FPREF}* ${OUTDIR}/output/.

chmod 777 -R ${OUTDIR}/output

echo "Done All"
# All temporary files and directories won't be removed since we can reuse them again and again
# Before returning a node to Aliaksey, we do need to manually remove everything in /localscratch

