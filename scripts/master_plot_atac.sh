#!/bin/bash

# Global settings
SCRIPTPATH=/home/icb/chaichoompu/Group/workspace/Benchmarking_data_integration_branch_ATAC/Benchmarking_data_integration/scripts
CPU=4
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

    FBASE=${4##*/}
    FPREF=${FBASE%.*}
    NODE_SBATCH_LOG=${5}/${FPREF}_type${9}_plot_log.txt
    NODE_SBATCH_ERR=${5}/${FPREF}_type${9}_plot_err.txt
    echo sbatch --partition=icb_cpu --qos=icb_stndrd --ntasks=1 --cpus-per-task=${2} --mem-per-cpu=${3} --time=1-00:00:00 --job-name=plot --output=${NODE_SBATCH_LOG} --error=${NODE_SBATCH_ERR} ${1}/slave_plot.sh ${4} ${5} ${6} ${7} ${8} ${9}
    sbatch --partition=icb_cpu --qos=icb_stndrd --ntasks=1 --cpus-per-task=${2} --mem-per-cpu=${3} --time=1-00:00:00 --job-name=plot --output=${NODE_SBATCH_LOG} --error=${NODE_SBATCH_ERR} ${1}/slave_plot.sh ${4} ${5} ${6} ${7} ${8} ${9}

    echo " "
    # add a bit of delay, otherwise it will be too overloaded for Slurm
    sleep 0.3

}
                
# Run settings
# Please use the full path
#bbknn_knn scanorama_full scanorama_embed harmony_embed trvae_full trvae_embed mnn_full

# create the output directory in temp if not exist
NODE_WORKDIR_OUT=${OUTDIR}/output_plot
if [ ! -d "$NODE_WORKDIR_OUT" ]; then
  mkdir ${NODE_WORKDIR_OUT}
fi
        
INPUTFILE=/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets/merge_10x_CEMBA180312_3B_GSM3034638_bin_merged_top_var_feat_min500cells_regression_Seurat_cell_labels.h5ad
OUTDIR=/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets
BATCH=batchname
CELLTYPE=cell_type_consensus
TYPE=full
HVGS=0
run_all ${SCRIPTPATH} ${CPU} ${RAMperCPU} ${INPUTFILE} ${NODE_WORKDIR_OUT} ${BATCH} ${CELLTYPE} ${TYPE} ${HVGS}

for PARAM in scanorama_full mnn_full seurat_full scanorama_embed harmony_embed trvae_embed bbknn_knn
do
    for HVGS in 0
    do
        METHOD=${PARAM%_*}
        TYPE=${PARAM##*_}
        
        INTEGRATIONFILE=/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets/output/merge_10x_CEMBA180312_3B_GSM3034638_bin_merged_top_var_feat_min500cells_regression_Seurat_cell_labels_${METHOD}_hvg${HVGS}.h5ad
        OUTDIR=/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets
        BATCH=batchname
        CELLTYPE=cell_type_consensus
        
        run_all ${SCRIPTPATH} ${CPU} ${RAMperCPU} ${INPUTFILE} ${NODE_WORKDIR_OUT} ${BATCH} ${CELLTYPE} ${TYPE} ${HVGS}
    done
done

# All temporary files and directories won't be removed since we can reuse them again and again
# Before returning a node to Aliaksey, we do need to manually remove everything in /localscratch
