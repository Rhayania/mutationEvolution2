# Mutation Evolution 2.0
The broad goal of this project is to begin investigating whether plants exhibit male-biased mutation rate increases, since this phenomenon has been observed across many animal species. In diploid systems, such as our own XY system, males possess both an X and a Y chromosome, which may muddle signs of mutation rate patterns between the sexes. During my original rotation project with Dan Sloan, I investigated mutation rate differences in the U and V chromosomes of two liverwort species, Marchantia polymorpha and Marchantia inflexa. These species are an interesting study system for this question because they spend the majority of their life cycle in a haploid state. This means that both male and female individuals possess only one sex chromosome: either U or V.

From a different perspective, each of these sex chromosomes (U or V respectively) "lives" in only one sex 100% of the time. Comparatively, in our XY system, the X chromosome spends 2/3 of its "time" in females and 1/3 in males. By beginning in a system where there is a chromosome exclusive to one sex, we hope that any differences in mutation rates are more apparent.

This repository houses a revised pipeline of the M. polymorpha and M. inflexa data, now streamlined with Snakemake. The Snakemake pipeline will prevent the need to start each step manually as an individual job: once started, the user should be able to log off and return when everything has finished (~1-2 days, per my experience). The details of the workflow are outlined below, which were guided by Dan in the original project.

## Navigating the Repo

TODO

## 1. Data Downloads

M. Polymorpha: Fasta files from https://marchantia.info/download/MpTak_v6.1r2/ (both DNA sequences and protein sequences)
* MpTak_v6.1r2.cds.fasta.gz
* MpTak_v6.1r2.protein.fasta.gz
* "Data 1" file download from https://www.sciencedirect.com/science/article/pii/S0960982221014123#app2 (This lists gene names on the U and V chromosomes)

M. inflexa: Fastq files. This is RNAseq data since there is no current genome published. Data is acquired from NCBI using SRA toolkit:

```fastq-dump --split-3 SRR10271376``` 

TODO: Try updating this to ```fasterq-dump```. Note the ```--split-3``` option is default.

TODO: Create .txt file of SRA accession codes for easy access.

## 2. Transcriptome assembly with Trinity

TODO

## 3. Identify Homologs between M. polymorpha and M. inflexa

TODO

## 4. Align sequences

TODO

## 5. Calculate sequence divergence

TODO

## 6. Preliminary analysis

TODO
