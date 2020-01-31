#!/bin/bash

## edit here
CONDA_ENV=snake_clone
NODE_TMP=/localscratch/scib_run
NODE_PYTHON=python
NODE_PYSCRIPT=/home/icb/chaichoompu/Group/workspace/Benchmarking_data_integration_branch_master/Benchmarking_data_integration/scripts/runIntegration.py

## fixed part
source activate ${CONDA_ENV} 

if [ X"$SLURM_STEP_ID" = "X" -a X"$SLURM_PROCID" = "X"0 ]
then
  echo "print =========================================="
  echo "print SLURM_JOB_ID = $SLURM_JOB_ID"
  echo "print SLURM_JOB_NODELIST = $SLURM_JOB_NODELIST"
  echo "print =========================================="
fi

INPUTFILE=$1
BATCH=$2
HVGS=$3
OUTDIR=$4
METHOD=$5
RERUN=$6

if [ $# -eq 0 ]
  then
    echo "To run this script:"
    echo "slave_integration.sh <input file> <the nanme of batch column> <number of HVGS> <output directory> <method> <re-run>"
    echo "if <re-run> = 1, the script be rerun, otherwise it won't run if an output file exists"
    exit
fi

FBASE=${INPUTFILE##*/}
FPREF=${FBASE%.*}

NODE_WORKDIR_OUT=${NODE_TMP}/output
NODE_INPUTFILE=${NODE_TMP}/${FBASE}
NODE_OUTPUTFILE=${NODE_WORKDIR_OUT}/${FPREF}_${METHOD}_hvg${HVGS}.h5ad
FINAL_OUTPUT=${OUTDIR}/output/${FPREF}_${METHOD}_hvg${HVGS}.h5ad

echo "Starting ${METHOD}"
echo "Checking if exist: ${FINAL_OUTPUT}"

if [ ! -f ${FINAL_OUTPUT} -o  ${RERUN} = "1" ]; then

    echo "Check output file: not exist"
    echo "Or rerun is enable"
    
    # create the temporary directory if not exist
    if [ ! -d "$NODE_TMP" ]; then
      mkdir ${NODE_TMP}
    fi
    
    # create the output directory in temp if not exist
    if [ ! -d "$NODE_WORKDIR_OUT" ]; then
      mkdir ${NODE_WORKDIR_OUT}
    fi
    
    # Once, copy the input file into temp directory
    if [ ! -f ${NODE_INPUTFILE} ]; then
        cp ${INPUTFILE} ${NODE_TMP}/.
    fi

    #echo ${NODE_PYTHON} -s ${NODE_PYSCRIPT} -i ${NODE_INPUTFILE} -o ${NODE_OUTPUTFILE} -b ${BATCH} -v ${HVGS} -m ${METHOD} 
    echo ${NODE_PYTHON} ${NODE_PYSCRIPT} -i ${NODE_INPUTFILE} -o ${NODE_OUTPUTFILE} -b ${BATCH} -v ${HVGS} -m ${METHOD} 

    STARTTIME=$(date +%s)
    
    #${NODE_PYTHON} -s ${NODE_PYSCRIPT} -i ${NODE_INPUTFILE} -o ${NODE_OUTPUTFILE} -b ${BATCH} -v ${HVGS} -m ${METHOD} 
    ${NODE_PYTHON} ${NODE_PYSCRIPT} -i ${NODE_INPUTFILE} -o ${NODE_OUTPUTFILE} -b ${BATCH} -v ${HVGS} -m ${METHOD} 
    
    ENDTIME=$(date +%s)
    
    echo "Wall time (sec) =$(($ENDTIME - $STARTTIME))"
    
    echo "Done ${METHOD}. Copying the result files from /localscratch to the indicated directory"
    if [ ! -d "${OUTDIR}/output" ]; then
      mkdir ${OUTDIR}/output
    fi
    cp -f ${NODE_WORKDIR_OUT}/${FPREF}* ${OUTDIR}/output/.
    
    chmod 777 -R ${OUTDIR}/output

else
    echo "Check output file: exist"
    echo "Or rerun is disable"
fi

echo "Done All"

#use this command when there is a conflict with different versions of libraries imported from /home
#${NODE_PYTHON} -s ${NODE_PYSCRIPT} -i ${NODE_INPUTFILE} -o ${NODE_OUTPUTFILE} -b ${BATCH} -v ${HVGS} -m ${METHOD} 

# All temporary files and directories won't be removed since we can reuse them again and again
# Before returning a node to Aliaksey, we do need to manually remove everything in /localscratch

