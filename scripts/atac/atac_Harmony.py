
# coding: utf-8

# # Harmony with regression

# In[1]:


import scIB
import scanpy as sc
import anndata as ad
import copy
import pickle
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

# In[25]:


#sc.pl.pca(adata,color=['batchname','cell_type_consensus'],wspace=0.5)


# In[26]:


#sc.pl.umap(adata,color=['batchname','cell_type_consensus'],wspace=0.5)


# In[27]:


#sc.pl.tsne(adata,color=['batchname','cell_type_consensus'],wspace=0.5)


# # Integration

# In[8]:


res=scIB.integration.runHarmony(adata, batch='batchname')


# In[9]:


#res


# In[10]:


foutput="../../data/brain_atac_3datasets/atac_brain_result_top_var_feat_Harmony.h5ad"
res.write(foutput)   


# # After integration

# In[11]:


#finput="../../data/brain_atac_3datasets/atac_brain_result_top_var_feat_Harmony.h5ad"
#integrated_res = ad.read(finput)


# In[12]:


#toplot = copy.copy(adata)
#toplot.obsm['X_pca'] = integrated_res


# In[13]:


#sc.pp.neighbors(integrated_res, method='gauss')
#sc.tl.umap(integrated_res)
#sc.tl.tsne(integrated_res)


# In[14]:


#integrated_res


# In[28]:


#fplot="_brain_atac_top_var_feat_after_integration_Harmony.pdf"
#sc.pl.pca(integrated_res, color=['batchname','cell_type_consensus'],wspace=0.5,save=fplot)


# In[29]:


#fplot="_brain_atac_top_var_feat_after_integration_Harmony.pdf"
#sc.pl.umap(integrated_res, color=['batchname','cell_type_consensus'],wspace=0.5,save=fplot)


# In[30]:


#fplot="_brain_atac_top_var_feat_after_integration_Harmony.pdf"
#sc.pl.tsne(integrated_res, color=['batchname','cell_type_consensus'],wspace=0.5,save=fplot)

