# Mutation Evolution 2.0
The broad goal of this project is to begin investigating whether plants exhibit male-biased mutation rate increases, since this phenomenon has been observed across many animal species. In diploid systems, such as our own XY system, males possess both an X and a Y chromosome, which may muddle signs of mutation rate patterns between the sexes. During my original rotation project with Dan Sloan, I investigated mutation rate differences in the U and V chromosomes of two liverwort species, Marchantia polymorpha and Marchantia inflexa. These species are an interesting study system for this question because they spend the majority of their life cycle in a haploid state. This means that both male and female individuals possess only one sex chromosome: either U or V.

From a different perspective, each of these sex chromosomes (U or V respectively) "lives" in only one sex 100% of the time. Comparatively, in our XY system, the X chromosome spends 2/3 of its "time" in females and 1/3 in males. By beginning in a system where there is a chromosome exclusive to one sex, we hope that any differences in mutation rates are more apparent.

This repository houses a revised pipeline of the M. polymorpha and M. inflexa data, now streamlined with Snakemake. The Snakemake pipeline will prevent the need to start each step manually as an individual job: once started, the user should be able to log off and return when everything has finished (~1-2 days, per my experience). The details of the workflow are outlined below, which were guided by Dan in the original project.

## Navigating the Repo

TODO

## 1. Data Downloads

M. Polymorpha: Fasta files from https://marchantia.info/download/MpTak_v6.1r2/ (both DNA sequences and protein sequences). Manually download and store these three files in your repo in the ```rawdata/``` folder.
* MpTak_v6.1r2.cds.fasta.gz
* MpTak_v6.1r2.protein.fasta.gz
* "Data 1" file download from https://www.sciencedirect.com/science/article/pii/S0960982221014123#app2 (This lists gene names on the U and V chromosomes)

M. inflexa: Fastq files. This is RNAseq data since there is no current genome published. Data is acquired from NCBI using SRA toolkit. Accession codes are listed in ```config.yaml```: 5 paired-end reads each from one male and one female individual. Downloads are stored in the ```rawdata/``` folder.

## 2. Transcriptome assembly with Trinity

Our M. inflexa data is currently a collection of RNA-seq reads. In order to pick out homologs between the two species, we first need to do de novo transcriptome assembly for M. inflexa. We will use a tool call Trinity. More information and documentation can be found here: https://github.com/trinityrnaseq/trinityrnaseq/wiki. We need to run transcriptome assembly twice: once with the male individual's RNA-seq reads, and once with the female's. This step generally takes about 5 hours to run (per assembly). 

Each assembly takes in 5 paired-end reads (10 files total) and outputs a single .fasta file.

This step is generally the one that is most difficult to run successfully. I had immense difficulty during my rotation installing a working version of Trinity from conda, and the solution ended up being to download and install the newest version manually. It also required a package called salmon. A separate conda environment was necessary for Trinity to avoid dependency issues.

## 3. Identify Homologs between M. polymorpha and M. inflexa

TODO

## 4. Align sequences

TODO

## 5. Calculate sequence divergence

TODO

## 6. Preliminary analysis

TODO

## Future Improvements

There are a few simple improvements that could be made to this pipeline if I were put-together enough to have time for it, listed below:

- Run data file downloads from NCBI in parallel (would save ~2hrs of time)
- Run both transcriptome assemblies in parallel (would save ~5hrs of time)
- List the output file names for the data_download step so it doesn't get run everytime the snakemake workflow is started
- Replace hard-coded input lists for the trinity_assembly rule with variables set in the config file
