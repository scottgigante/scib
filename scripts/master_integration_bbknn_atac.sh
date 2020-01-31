#!/bin/bash

# Global settings
SCRIPTPATH=/home/icb/chaichoompu/Group/workspace/Benchmarking_data_integration_branch_ATAC/Benchmarking_data_integration/scripts
CPU=12
RAMperCPU=16000
RERUN=1

#To call run_all
#$1= path of script or SCRIPTPATH
#$2= CPU
#$3= RAM per CPU or RAMperCPU
#$4= input file or INPUTFILE
#$5= batch column name or BATCH
#$6= number of HVGs or HVGS
#$7= output path or OUTDIR, the directory needs to existed, the output files will be saved under $OUTDIR/output
#$8= rerun = 1, otherwise not
 
function run_all {
    for METHOD in bbknn
    do
        FBASE=${4##*/}
        FPREF=${FBASE%.*}
        NODE_SBATCH_LOG=${7}/${FPREF}_${METHOD}_hvg${6}_log.txt
        NODE_SBATCH_ERR=${7}/${FPREF}_${METHOD}_hvg${6}_err.txt
        sbatch --partition=icb_rstrct --qos=icb_rstrct --ntasks=1 --cpus-per-task=${2} --mem-per-cpu=${3} --time=4-00:00:00 --job-name=scib --output=${NODE_SBATCH_LOG} --error=${NODE_SBATCH_ERR} ${1}/slave_integration.sh ${4} ${5} ${6} ${7} ${METHOD} ${8}

        # add a bit of delay, otherwise it will be too overloaded for Slurm
        sleep 0.3
    done
}
                
# Run settings
# Please use the full path

declare -a arr=(
#    '/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_small/merge_10x_CEMBA180312_3B_GSM3034638_bin_merged_top_var_feat_min500cells_regression_Seurat_cell_labels.h5ad|batchname|/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets'
#    '/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_small/merge_10x_all_Fang_GSE111586_bin_merged_top_750000_var_feat_min100cells_regressed_20191015_good_cell_label_sparse.h5ad|batchname|/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets'
    '/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_small/small_dataset_10x_Fang_150000_normalised_cell_label_counts_sparse.h5ad|batchname|/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_small'
    '/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_small/small_dataset_10x_Fang_Cus_150000_normalised_cell_label_counts_sparse.h5ad|batchname|/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_small'
    )

for i in "${arr[@]}"
do
   INPUTFILE=`echo "$i"|cut -d'|' -f1`
   BATCH=`echo "$i"|cut -d'|' -f2`
   OUTDIR=`echo "$i"|cut -d'|' -f3`
   HVGS=0
   run_all ${SCRIPTPATH} ${CPU} ${RAMperCPU} ${INPUTFILE} ${BATCH} ${HVGS} ${OUTDIR} ${RERUN}
done

# All temporary files and directories won't be removed since we can reuse them again and again
# Before returning a node to Aliaksey, we do need to manually remove everything in /localscratch
