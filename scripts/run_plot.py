#!/usr/bin/env python
# coding: utf-8

import sys
sys.path.append('/storage/groups/ce01/workspace/Benchmarking_data_integration_branch_master/Benchmarking_data_integration')

import scIB
import scanpy as sc
import anndata as ad
import copy
import os

import argparse

parser = argparse.ArgumentParser(description='Compute all metrics')

parser.add_argument('-i', '--inputfile', required=True)
parser.add_argument('-o', '--output', required=True, help='output directory')

parser.add_argument('-b', '--batch_key', required=True, help='Key of batch')
parser.add_argument('-l', '--label_key', required=True, help='Key of annotated labels e.g. "cell_type"')

parser.add_argument('-m', '--mode', required=True, help='either full, embed, or knn')

parser.add_argument('--hvgs', default=None, help='Number of highly variable genes', type=int)

args = parser.parse_args()

inputfile = args.inputfile
output = args.output
batch_key = args.batch_key
label_key = args.label_key
n_hvgs = args.hvgs
mode = args.mode

sc.settings.set_figure_params(dpi=80, dpi_save=400)

adata = ad.read(inputfile)

if mode == 'full':
    sc.pp.neighbors(adata)
    sc.tl.pca(adata)
    sc.tl.tsne(adata)
    sc.tl.umap(adata)
    
    os.chdir(output)
    fplot= "_"+inputfile+"_hvg_"+n_hvgs+".pdf"
    sc.pl.pca(adata_merge_all, wspace=0.5, color=[batch_key,label_key], save=fplot)
    sc.pl.tsne(adata_merge_all, wspace=0.5, color=[batch_key,label_key], save=fplot)
    sc.pl.umap(adata_merge_all, wspace=0.5, color=[batch_key,label_key], save=fplot)
elif mode == 'embed':
    sc.pp.neighbors(adata)
    sc.tl.tsne(adata)
    sc.tl.umap(adata)
    
    os.chdir(output)
    fplot= "_"+inputfile+"_hvg_"+n_hvgs+".pdf"
    sc.pl.pca(adata_merge_all, wspace=0.5, color=[batch_key,label_key], save=fplot)
    sc.pl.tsne(adata_merge_all, wspace=0.5, color=[batch_key,label_key], save=fplot)
    sc.pl.umap(adata_merge_all, wspace=0.5, color=[batch_key,label_key], save=fplot)
elif mode == 'knn':
    sc.tl.umap(adata)

    os.chdir(output)
    fplot= "_"+inputfile+"_hvg_"+n_hvgs+".pdf"
    sc.pl.umap(adata_merge_all, wspace=0.5, color=[batch_key,label_key], save=fplot)

