#!/bin/bash

# Global settings
SCRIPTPATH=/home/icb/chaichoompu/Group/workspace/Benchmarking_data_integration_branch_ATAC/Benchmarking_data_integration/scripts
CPU=12
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
    sbatch --partition=icb_cpu --qos=icb_stndrd --ntasks=1 --cpus-per-task=${2} --mem-per-cpu=${3} --time=1-00:00:00 --job-name=met --output=${NODE_SBATCH_LOG} --error=${NODE_SBATCH_ERR} ${1}/slave_metrics.sh ${4} ${5} ${6} ${7} ${8} ${9} ${10} ${11}
    echo sbatch --partition=icb_cpu --qos=icb_stndrd --ntasks=1 --cpus-per-task=${2} --mem-per-cpu=${3} --time=1-00:00:00 --job-name=met --output=${NODE_SBATCH_LOG} --error=${NODE_SBATCH_ERR} ${1}/slave_metrics.sh ${4} ${5} ${6} ${7} ${8} ${9} ${10} ${11}
    echo " "
    # add a bit of delay, otherwise it will be too overloaded for Slurm
    sleep 0.3

}
                
# Run settings
# Please use the full path
#bbknn_knn scanorama_full scanorama_embed harmony_embed trvae_full trvae_embed mnn_full

for PARAM in scanorama_full mnn_full seurat_full scanorama_embed harmony_embed trvae_embed scvi_embed bbknn_knn
do
    for HVGS in 0
    do
        METHOD=${PARAM%_*}
        TYPE=${PARAM##*_}
        
        INPUTFILE=/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets/merge_10x_all_Fang_GSE111586_bin_merged_top_750000_var_feat_min100cells_regressed_20191015_good_cell_label_sparse.h5ad
        INTEGRATIONFILE=/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets/output/merge_10x_all_Fang_GSE111586_bin_merged_top_750000_var_feat_min100cells_regressed_20191015_good_cell_label_sparse_${METHOD}_hvg${HVGS}.h5ad
        OUTDIR=/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets
        BATCH=batchname
        CELLTYPE=broad_cell_label
        ORGANISM=human
        run_all ${SCRIPTPATH} ${CPU} ${RAMperCPU} ${INPUTFILE} ${INTEGRATIONFILE} ${OUTDIR} ${BATCH} ${CELLTYPE} ${ORGANISM} ${TYPE} ${HVGS}
    done
done

# All temporary files and directories won't be removed since we can reuse them again and again
# Before returning a node to Aliaksey, we do need to manually remove everything in /localscratch
