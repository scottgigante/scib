#!/bin/bash

# Global settings
SCRIPTPATH=/home/icb/chaichoompu/Group/workspace/Benchmarking_data_integration_branch_ATAC/Benchmarking_data_integration/scripts
CPU=16
RAMperCPU=16000

#To call run_all
#$1= path of script or SCRIPTPATH
#$2= CPU
#$3= RAM per CPU or RAMperCPU
#$4= input file or INPUTFILE
#$5= batch column name or BATCH
#$6= number of HVGs or HVGS
#$7= output path or OUTDIR

function run_all {
    for METHOD in bbknn scanorama harmony conos seurat trvae mnn
    do
        FPREF=${4%.*}
        NODE_SBATCH_LOG=${7}/${FPREF}_${METHOD}_log.txt
        NODE_SBATCH_ERR=${7}/${FPREF}_${METHOD}_err.txt
        sbatch --partition=icb_rstrct --qos=icb_rstrct --ntasks=1 --cpus-per-task=${2} --mem-per-cpu=${3} --time=4-00:00:00 --job-name=scib --output=${NODE_SBATCH_LOG} --error=${NODE_SBATCH_ERR} ${1}/slave_integration.sh ${4} ${5} ${6} ${7} ${METHOD}

        # add a bit of delay, otherwise it will be too overloaded for Slurm
        sleep 0.3
    done
}
                
# Run settings
INPUTFILE=/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets/merge_10x_CEMBA180312_3B_GSM3034638_bin_merged_filterRowCol_filterCountCell.h5ad
BATCH=batchname
HVGS=0
OUTDIR=/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets

run_all ${SCRIPTPATH} ${CPU} ${RAMperCPU} ${INPUTFILE} ${BATCH} ${HVGS} ${OUTDIR}

# All temporary files and directories won't be removed since we can reuse them again and again
# Before returning a node to Aliaksey, we do need to manually remove everything in /localscratch
