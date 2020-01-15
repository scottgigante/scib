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

# create the output directory in temp if not exist
NODE_WORKDIR_OUT=${OUTDIR}/output_metrics

if [ ! -d "$NODE_WORKDIR_OUT" ]; then
  mkdir ${NODE_WORKDIR_OUT}
fi

NODE_PYTHON=/home/icb/daniel.strobl/miniconda3/envs/sc-tutorial/bin/python
NODE_PYSCRIPT=/storage/groups/ce01/workspace/Benchmarking_data_integration_branch_master/Benchmarking_data_integration/scripts/metrics.py


echo "Starting"

echo ${NODE_PYTHON} -s ${NODE_PYSCRIPT} -u ${INPUTFILE} -i ${INTEGRATIONFILE} -o ${NODE_WORKDIR_OUT} -b ${BATCH} -l ${CELLTYPE} --organism ${ORGANISM} --type ${TYPE} --hvgs ${HVGS}  
${NODE_PYTHON} -s ${NODE_PYSCRIPT} -u ${INPUTFILE} -i ${INTEGRATIONFILE} -o ${NODE_WORKDIR_OUT} -b ${BATCH} -l ${CELLTYPE} --organism ${ORGANISM} --type ${TYPE} --hvgs ${HVGS}  

chmod 777 -R ${NODE_WORKDIR_OUT}

echo "Done."

# All temporary files and directories won't be removed since we can reuse them again and again
# When finish, we do need to manually remove everything in /localscratch in all compute nodes

