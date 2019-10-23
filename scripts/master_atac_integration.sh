#!/bin/bash

INPUTFILE=/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets/merge_10x_CEMBA180312_3B_GSM3034638_bin_merged_filterRowCol_filterCountCell.h5ad
BATCH=batchname
HVGS=0
OUTDIR=/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets

bash slave_integration.sh ${INPUTFILE} ${BATCH} ${HVGS} ${OUTDIR}

# All temporary files and directories won't be removed since we can reuse them again and again
# Before returning a node to Aliaksey, we do need to manually remove everything in /localscratch
