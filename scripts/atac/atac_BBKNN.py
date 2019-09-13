
# coding: utf-8

# # BBKNN with regression
# 

# In[1]:


import scIB
import scanpy as sc
import anndata as ad
import copy
import os


# In[2]:


sc.settings.set_figure_params(dpi=80, dpi_save=400)
cwd = os.getcwd()
cwd


# # Read the data

# In[3]:


#finput="../../data/brain_atac_fang_10x/merge_10x_CEMBA180312_3B_bin_merged_filterRowCol_filterCountCell_regression.h5ad"
finput="../../data/brain_atac_3datasets/merge_10x_CEMBA180312_3B_GSM3034638_bin_merged_top_var_feat_min100cells_regression_cell_labels.h5ad"

adata = ad.read(finput)


# In[4]:


#adata


# # Before integration

# In[21]:


#fplot="_brain_atac_top_var_feat_before_integration.pdf"
#sc.pl.pca(adata,color=['batchname','cell_type_consensus'],wspace=0.5,save=fplot)


# In[22]:


#sc.pl.umap(adata,color=['batchname','cell_type_consensus'],wspace=0.5,save=fplot)


# In[23]:


#sc.pl.tsne(adata,color=['batchname','cell_type_consensus'],wspace=0.5,save=fplot)


# # Integration

# In[8]:


res=scIB.integration.runBBKNN(adata, batch='batchname')


# Only the neighborhood graph changes for bbknn

# In[9]:


#res


# In[10]:


foutput="../../data/brain_atac_3datasets/atac_brain_result_top_var_feat_BBKNN.h5ad"
res.write(foutput)


# # After integration

# In[11]:


#finput="../../data/brain_atac_3datasets/atac_brain_result_top_var_feat_BBKNN.h5ad"
#integrated_res = ad.read(finput)


# In[12]:


#sc.tl.umap(integrated_res)
#sc.tl.tsne(integrated_res)


# In[13]:


# the pc plot of BBKNN will not be changed
#fplot="_brain_atac_top_var_feat_after_integration_BBKNN.pdf"
#sc.pl.pca(integrated_res, color='batchname',save=fplot)


# In[20]:


#fplot="_brain_atac_top_var_feat_after_integration_BBKNN.pdf"
#sc.pl.umap(integrated_res, color=['batchname','cell_type_consensus'],wspace=0.5,save=fplot)


# In[15]:


# tsne plot will not be chagned for BBKNN
#fplot="_brain_atac_after_integration_BBKNN.pdf"
#sc.pl.tsne(integrated_res, color='batchname',save=fplot)

