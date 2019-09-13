
# coding: utf-8

# In[1]:


import scIB
import scanpy as sc
import anndata as ad
import copy
import os


# In[2]:


#sc.settings.set_figure_params(dpi=80, dpi_save=400)
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

# In[5]:


#sc.pl.pca(adata,color='batchname')


# In[6]:


#sc.pl.umap(adata,color='batchname')


# In[7]:


#sc.pl.tsne(adata,color='batchname')


# # Integration

# In[ ]:


res=scIB.integration.runMNN(adata, batch='batchname')


# In[ ]:


#res


# In[ ]:


foutput="../../data/brain_atac_3datasets/atac_brain_result_top_var_feat_MNN.h5ad"
res.write(foutput)
    


# # After integration

# In[ ]:


#finput="../../data/brain_atac_3datasets/atac_brain_result_top_var_feat_MNN.h5ad"
#integrated_res = ad.read(finput)


# In[ ]:


#sc.pp.pca(integrated_res)
#sc.pp.neighbors(integrated_res)
#sc.tl.umap(integrated_res)
#sc.tl.tsne(integrated_res)


# In[ ]:


#integrated_res


# In[ ]:


#fplot="_brain_atac_top_var_feat_after_integration_MNN.pdf"
#sc.pl.pca(integrated_res, color='batchname',save=fplot)


# In[ ]:


#fplot="_brain_atac_top_var_feat_after_integration_MNN.pdf"
#sc.pl.umap(integrated_res, color='batchname',save=fplot)


# In[ ]:


#fplot="_brain_atac_top_var_feat_after_integration_MNN.pdf"
#sc.pl.tsne(integrated_res, color='batchname',save=fplot)

