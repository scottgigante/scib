#!/bin/bash

# Global settings
SCRIPTPATH=/home/icb/chaichoompu/Group/workspace/Benchmarking_data_integration_branch_ATAC/Benchmarking_data_integration/scripts
CPU=24
RAMperCPU=16000
RERUN=0

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
    for METHOD in mnn
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
#    '/storage/groups/ml01/workspace/group.daniela/lung/Lung_atlas_final_fixed.h5ad|batch|/storage/groups/ml01/workspace/group.daniela/lung'
#    '/storage/groups/ml01/workspace/group.daniela/immune_cells/Immune_ALL_hum_mou.h5ad|batch|/storage/groups/ml01/workspace/group.daniela/immune_cells'
#    '/storage/groups/ml01/workspace/group.daniela/immune_cells/Immune_ALL_human.h5ad|batch|/storage/groups/ml01/workspace/group.daniela/immune_cells'
#    '/storage/groups/ml01/workspace/maren.buettner/data_integration/data/human_pancreas/human_pancreas_norm.h5ad|tech|/storage/groups/ml01/workspace/maren.buettner/data_integration/data/human_pancreas/integrated'
    '/storage/groups/ml01/workspace/maren.buettner/data_integration/data/mouse_brain/mouse_brain_norm.h5ad|study|/storage/groups/ml01/workspace/maren.buettner/data_integration/data/mouse_brain/integrated'
    )

for i in "${arr[@]}"
do
   INPUTFILE=`echo "$i"|cut -d'|' -f1`
   BATCH=`echo "$i"|cut -d'|' -f2`
   OUTDIR=`echo "$i"|cut -d'|' -f3`
   for HVGS in 0 2000
   do
        run_all ${SCRIPTPATH} ${CPU} ${RAMperCPU} ${INPUTFILE} ${BATCH} ${HVGS} ${OUTDIR} ${RERUN}
   done
done

# All temporary files and directories won't be removed since we can reuse them again and again
# Before returning a node to Aliaksey, we do need to manually remove everything in /localscratch
