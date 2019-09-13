#!/bin/bash

source activate sc-clone

METHOD=Scanorama
MODE=full
WORKDIR=/home/icb/chaichoompu/Group/workspace/Benchmarking_data_integration_matrics/Benchmarking_data_integration
DATADIR=/home/icb/chaichoompu/Group/workspace/Benchmarking_data_integration
PYSCRIPT=${WORKDIR}_matrics/Benchmarking_data_integration/scripts/metrics.py
INPUTBEFORE=${DATADIR}/data/brain_atac_3datasets/merge_10x_CEMBA180312_3B_GSM3034638_bin_merged_top_var_feat_min100cells_regression_cell_labels.h5ad
INPUTAFTER=${DATADIR}/data/brain_atac_3datasets/atac_brain_result_top_var_feat_${METHOD}.h5ad
OUTPUTDIR=${DATADIR}/data/brain_atac_3datasets/metrics_${METHOD}_${MODE}
if [ ! -d "$${OUTPUTDIR}" ]; then
  mkdir ${OUTPUTDIR}
fi
${PYSCRIPT} --uncorrected ${INPUTBEFORE} --integrated ${INPUTAFTER} --output ${OUTPUTDIR} --batch_key batchname --label_key cell_type_consensus --type ${MODE}
