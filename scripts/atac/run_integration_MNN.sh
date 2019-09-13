#!/bin/bash

source activate sc-clone

METHOD=mnn
WORKDIR=/home/icb/chaichoompu/Group/workspace/Benchmarking_data_integration
PYSCRIPT=${WORKDIR}_branch_ATAC/Benchmarking_data_integration/scripts/runIntegration.py
INPUTFILE=${WORKDIR}/data/brain_atac_3datasets/merge_10x_CEMBA180312_3B_GSM3034638_bin_merged_filterRowCol_filterCountCell.h5ad
OUTPUTFILE=${WORKDIR}/data/brain_atac_3datasets/merge_10x_CEMBA180312_3B_GSM3034638_bin_merged_filterRowCol_filterCountCell_${METHOD}.h5ad
OUTPUTLOG=${WORKDIR}/data/brain_atac_3datasets/merge_10x_CEMBA180312_3B_GSM3034638_bin_merged_filterRowCol_filterCountCell_${METHOD}.txt
${PYSCRIPT} -i ${INPUTFILE} -o ${OUTPUTFILE} -b batchname -v 0 -m ${METHOD} > ${OUTPUTLOG}
