#!/bin/bash

# Global settings
SCRIPTPATH=/home/icb/chaichoompu/Group/workspace/Benchmarking_data_integration_branch_ATAC/Benchmarking_data_integration/scripts
CPU=2
RAMperCPU=8000

#To call run_all
#$1= path of script or SCRIPTPATH
#$2= CPU
#$3= RAM per CPU or RAMperCPU
#$4= input file or INPUTFILE
#$5= INTEGRATIONFILE
#$6= output path or OUTDIR, the directory needs to existed, the output files will be saved under $OUTDIR/output
#$7= batch column name or BATCH
#$8= CELLTYPE
#$9= ORGANISM
#$10= TYPE
#$11= number of HVGs or HVGS
function run_all {

    FBASE=${5##*/}
    FPREF=${FBASE%.*}
    NODE_SBATCH_LOG=${6}/${FPREF}_type${10}_metrics_log.txt
    NODE_SBATCH_ERR=${6}/${FPREF}_type${10}_metrics_err.txt
    sbatch --partition=serial_fed28 --qos=usr_lmts --ntasks=1 --cpus-per-task=${2} --mem-per-cpu=${3} --time=1-00:00:00 --job-name=metric --output=${NODE_SBATCH_LOG} --error=${NODE_SBATCH_ERR} ${1}/slave_metrics.sh ${4} ${5} ${6} ${7} ${8} ${9} ${10} ${11}

    # add a bit of delay, otherwise it will be too overloaded for Slurm
    sleep 0.3

}
                
# Run settings
# Please use the full path
PARAM=bbknn_knn

for PARAM in bbknn_knn scanorama_full scanorama_embed harmony_embed trvae_full trvae_embed
do
    METHOD=${PARAM%_*}
    TYPE=${PARAM##*_}
    
    INPUTFILE=/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets/merge_10x_CEMBA180312_3B_GSM3034638_bin_merged_filterRowCol_filterCountCell.h5ad
    INTEGRATIONFILE=/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets/output/merge_10x_CEMBA180312_3B_GSM3034638_bin_merged_filterRowCol_filterCountCell_${METHOD}.h5ad
    OUTDIR=/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets
    BATCH=batchname
    CELLTYPE=cell_type_consensus
    ORGANISM=human
    HVGS=0
    run_all ${SCRIPTPATH} ${CPU} ${RAMperCPU} ${INPUTFILE} ${INTEGRATIONFILE} ${OUTDIR} ${BATCH} ${CELLTYPE} ${ORGANISM} ${TYPE} ${HVGS}

done

# All temporary files and directories won't be removed since we can reuse them again and again
# Before returning a node to Aliaksey, we do need to manually remove everything in /localscratch
