import scipy
import anndata


# list of input files

list_inputfile = [
    '/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets/merge_10x_CEMBA180312_3B_GSM3034638_bin_merged_top_var_feat_min500cells_regression_Seurat_cell_labels.h5ad',
    '/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets/merge_10x_all_Fang_GSE111586_bin_merged_top_750000_var_feat_min100cells_regressed_20191015_good_cell_label.h5ad',
    '/storage/groups/ml01/workspace/group.daniela/lung/Lung_atlas_final_fixed.h5ad',
    '/storage/groups/ml01/workspace/group.daniela/immune_cells/Immune_ALL_hum_mou.h5ad',
    '/storage/groups/ml01/workspace/group.daniela/immune_cells/Immune_ALL_human.h5ad',
    '/storage/groups/ml01/workspace/maren.buettner/data_integration/data/human_pancreas/human_pancreas_norm.h5ad',
    '/storage/groups/ml01/workspace/maren.buettner/data_integration/data/mouse_brain/mouse_brain_norm.h5ad'
]

list_batch = [
    'batchname',
    'batchname',
    'batch',
    'batch',
    'batch',
    'tech',
    'study'
]

list_outputdir = [
    '/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets',
    '/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets',
    '/storage/groups/ml01/workspace/group.daniela/lung',
    '/storage/groups/ml01/workspace/group.daniela/immune_cells',
    '/storage/groups/ml01/workspace/group.daniela/immune_cells',
    '/storage/groups/ml01/workspace/maren.buettner/data_integration/data/human_pancreas/integrated',
    '/storage/groups/ml01/workspace/maren.buettner/data_integration/data/mouse_brain/integrated'
]
                
# Run settings
for fn in list_inputfile:
    print("\n"+fn)
    adata = anndata.read(fn)
    if scipy.sparse.issparse(adata.X):
        print("Yes")
    else:
        print("No")

# Result

#/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets/merge_10x_CEMBA180312_3B_GSM3034638_bin_merged_top_var_feat_min500cells_regression_Seurat_cell_labels.h5ad
#Yes

#/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets/merge_10x_all_Fang_GSE111586_bin_merged_top_750000_var_feat_min100cells_regressed_20191015_good_cell_label.h5ad
#No

#/storage/groups/ml01/workspace/group.daniela/lung/Lung_atlas_final_fixed.h5ad
#Yes

#/storage/groups/ml01/workspace/group.daniela/immune_cells/Immune_ALL_hum_mou.h5ad
#Yes

#/storage/groups/ml01/workspace/group.daniela/immune_cells/Immune_ALL_human.h5ad
#Yes

#/storage/groups/ml01/workspace/maren.buettner/data_integration/data/human_pancreas/human_pancreas_norm.h5ad
#Yes

#/storage/groups/ml01/workspace/maren.buettner/data_integration/data/mouse_brain/mouse_brain_norm.h5ad
#Yes
adata = anndata.read('/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets/merge_10x_all_Fang_GSE111586_bin_merged_top_750000_var_feat_min100cells_regressed_20191015_good_cell_label.h5ad')
adata.X = scipy.sparse.csr_matrix(adata.X)
adata.write('/storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets/merge_10x_all_Fang_GSE111586_bin_merged_top_750000_var_feat_min100cells_regressed_20191015_good_cell_label_sparse.h5ad')

########
# Check cell label

for fn in list_inputfile:
    print("\n"+fn)
    adata = anndata.read(fn)
    print(adata)

# /storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets/merge_10x_CEMBA180312_3B_GSM3034638_bin_merged_top_var_feat_min500cells_regression_Seurat_cell_labels.h5ad
# AnnData object with n_obs × n_vars = 15899 × 35196 
#     obs: 'batch', 'batchname', 'n_counts', 'n_windows', 'sum_peaks', 'n_genes', 'cell_type_10x', 'cell_type_Fang', 'cell_type_GSM3034638', 'cell_type_all', 'cell_type_consensus'
#     var: 'chrom-0-0', 'chrom2-0-0', 'n_cells-0-0', 'var_cells-0-0', 'overlap_3datasets', 'n_cells-1-0', 'var_cells-1-0', 'overlap10x-1-0', 'first_filtering-1', 'second_filtering-1', 'n_cells-1', 'var_cells-1', 'n_cells', 'var_cells', 'commonness'
#     uns: 'batchname_colors', 'cell_type_10x_colors', 'cell_type_Fang_colors', 'cell_type_GSM3034638_colors', 'cell_type_all_colors', 'cell_type_consensus_colors', 'neighbors', 'pca'
#     obsm: 'X_pca', 'X_tsne', 'X_umap'
#     varm: 'PCs'
# 
# /storage/groups/ce01/workspace/Benchmarking_data_integration/data/brain_atac_3datasets/merge_10x_all_Fang_GSE111586_bin_merged_top_750000_var_feat_min100cells_regressed_20191015_good_cell_label.h5ad
# AnnData object with n_obs × n_vars = 88198 × 16808 
#     obs: 'all_cell_label', 'batch', 'batchname', 'batchname_Fang', 'broad_cell_label', 'cell_label', 'cell_type', 'louvain_general', 'louvain_general1', 'n_counts', 'n_genes', 'n_windows', 'sum_peaks', 'tissue'
#     var: 'n_cells-0-0', 'prop_shared_cells-0-0', 'variablility_score-0-0', 'n_cells-1-0', 'prop_shared_cells-1-0', 'variablility_score-1-0', 'keep-1', 'n_cells-1', 'prop_shared_cells-1', 'variablility_score-1', 'n_cells', 'prop_shared_cells', 'variablility_score', 'commonness'
#     uns: 'all_cell_label_colors', 'broad_cell_label_colors'
#     obsm: 'X_pca', 'X_tsne', 'X_umap'
#     varm: 'PCs'
# 
# /storage/groups/ml01/workspace/group.daniela/lung/Lung_atlas_final_fixed.h5ad
# AnnData object with n_obs × n_vars = 32472 × 15148 
#     obs: 'dataset', 'location', 'nGene', 'nUMI', 'patientGroup', 'percent.mito', 'protocol', 'sanger_type', 'size_factors', 'sampling_method', 'batch', 'cell_type', 'donor'
#     layers: 'counts'
# 
# /storage/groups/ml01/workspace/group.daniela/immune_cells/Immune_ALL_hum_mou.h5ad
# AnnData object with n_obs × n_vars = 97861 × 8135 
#     obs: 'batch', 'chemistry', 'data_type', 'dpt_pseudotime', 'final_annotation', 'mt_frac', 'n_counts', 'n_genes', 'size_factors', 'species', 'study', 'tissue'
#     var: 'gene_id-0-0', 'n_cells-0-0', 'gene_ids-1-0', 'n_cells-1-0', 'gene_ids-2-0', 'feature_types-2-0', 'n_cells-2-0', 'gene_id-3-0', 'n_cells-3-0', 'n_cells-4-0', 'gene_ensembl-0-1', 'n_cells-0-1', 'n_cells-1-1', 'n_cells-2-1'
#     layers: 'counts'
# 
# /storage/groups/ml01/workspace/group.daniela/immune_cells/Immune_ALL_human.h5ad
# AnnData object with n_obs × n_vars = 33506 × 12303 
#     obs: 'batch', 'chemistry', 'data_type', 'dpt_pseudotime', 'final_annotation', 'mt_frac', 'n_counts', 'n_genes', 'sample_ID', 'size_factors', 'species', 'study', 'tissue'
#     var: 'gene_id-0', 'n_cells-0', 'gene_ids-1', 'n_cells-1', 'gene_ids-2', 'feature_types-2', 'n_cells-2', 'gene_id-3', 'n_cells-3', 'n_cells-4'
#     layers: 'counts'
# 
# /storage/groups/ml01/workspace/maren.buettner/data_integration/data/human_pancreas/human_pancreas_norm.h5ad
# AnnData object with n_obs × n_vars = 16382 × 19093 
#     obs: 'tech', 'celltype', 'size_factors', 'louvain'
#     layers: 'counts'
# 
# /storage/groups/ml01/workspace/maren.buettner/data_integration/data/mouse_brain/mouse_brain_norm.h5ad
# AnnData object with n_obs × n_vars = 978734 × 14858 
#     obs: 'Age', 'Subclass', 'Taxonomy_group', 'Tissue', 'age', 'batch', 'cell_ontology_class', 'cell_ontology_id', 'cell_type', 'class', 'cluster', 'cluster_id', 'log_counts', 'n_counts', 'n_genes', 'reason', 'refined_class', 'region', 'region_subcluster', 'sample_type', 'size_factors', 'study', 'subcluster', 'louvain', 'cell_type_refined'
#     layers: 'counts'

