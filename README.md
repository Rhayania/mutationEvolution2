# Mutation Evolution 2.0
The broad goal of this project is to begin investigating whether plants exhibit male-biased mutation rate increases, since this phenomenon has been observed across many animal species. In diploid systems, such as our own XY system, males possess both an X and a Y chromosome, which may muddle signs of mutation rate patterns between the sexes. During my original rotation project with Dan Sloan, I investigated mutation rate differences in the U and V chromosomes of two liverwort species, Marchantia polymorpha and Marchantia inflexa. These species are an interesting study system for this question because they spend the majority of their life cycle in a haploid state. This means that both male and female individuals possess only one sex chromosome: either U or V.

From a different perspective, each of these sex chromosomes (U or V respectively) "lives" in only one sex 100% of the time. Comparatively, in our XY system, the X chromosome spends 2/3 of its "time" in females and 1/3 in males. By beginning in a system where there is a chromosome exclusive to one sex, we hope that any differences in mutation rates are more apparent.

This repository houses a revised pipeline of the M. polymorpha and M. inflexa data, now streamlined with Snakemake. The Snakemake pipeline will prevent the need to start each step manually as an individual job: once started, the user should be able to log off and return when everything has finished (~1-2 days, per my experience). This was built to run in Alpine (a specific high performance computing cluster), so some alterations might need to be made to run the workflow elsewhere. The details of the workflow are outlined below, which were guided by Dan in the original project.

## Navigating the Repo

```envs/```: A folder that contains .yaml files for any additional conda environments needed by our workflow steps.

```logs/```: A folder that contains all error and standard output logs from various steps of the pipeline. Git is set to ignore any files added so they stay local.

```output/```: A folder that contains sub-directories for each pipeline step. Git is set to ignore any files added so they stay local.

```rawdata/```: A folder for storing the initial data for the pipeline. Git is set to ignore any files added so they stay local.

```scripts/```: A folder containing the python scripts used for data wrangling and preliminary data analysis.

```config.yaml```: A file that holds any configuration data needed for the pipeline.

```Snakefile```: A file that contains all of the details of the data pipeline.

```submit_snakemake.sh```: A shell script that runs our Snakefile as a job via SLURM. This is important because our first two steps take several hours to run and take enough compute power that it's rude to run without submitting to the queue. Run this with ```sbatch submit_snakemake.sh```.

## 1. Data Downloads

M. Polymorpha: Fasta files from https://marchantia.info/download/MpTak_v6.1r2/ (both DNA sequences and protein sequences). Manually download and store these two files in your repo in the ```rawdata/``` folder.
* MpTak_v6.1r2.cds.fasta.gz
* MpTak_v6.1r2.protein.fasta.gz
* "Data 1" from https://www.sciencedirect.com/science/article/pii/S0960982221014123#app2 (This lists gene names on the U and V chromosomes)
  * Gene lists for the U and V chromosomes are already in the repo to prevent the need to redo this step each time, stored as ```ugenes.txt``` and ```vgenes.txt``` in the ```rawdata/``` folder.

M. inflexa: Fastq files. This is RNAseq data since there is no current genome published. Data is acquired from NCBI using SRA toolkit. Accession codes are listed in ```config.yaml```: 5 paired-end reads each from one male and one female individual. Downloads are stored in the ```rawdata/``` folder.

## 2. Transcriptome assembly with Trinity

Our M. inflexa data is currently a collection of RNA-seq reads. In order to pick out homologs between the two species, we first need to do de novo transcriptome assembly for M. inflexa. We will use a tool call Trinity. More information and documentation can be found here: https://github.com/trinityrnaseq/trinityrnaseq/wiki. We need to run transcriptome assembly twice: once with the male individual's RNA-seq reads, and once with the female's. This step generally takes about 5 hours to run (per assembly). 

Each assembly takes in 5 paired-end reads (10 files total) and outputs a single .fasta file (along with several other files that we won't be using).

This step is generally the one that is most difficult to run successfully. I had immense difficulty during my rotation installing a working version of Trinity from conda, and the solution ended up being to download and install the newest version manually. It also required a package called salmon. A separate conda environment was necessary for Trinity to avoid dependency issues.

## 3. Align sequences and identify homologs between M. polymorpha and M. inflexa

There are a series of minor steps run before our blast search that reduce the M. polymorpha .fasta files to only the genes on the u and v chromosomes. Once finished, we can run a command-line blast search between the .fasta files of the two speccies to pull out homologs. For more information on blast, see here: https://blast.ncbi.nlm.nih.gov/Blast.cgi.

We use the assembled M. inflexa .fasta files as the "database" for blast, with each gene in the M. polymorpha .fasta files serving as the queries. We run four total blast searches, comparing the u and v genes of M. polymorpha to the male and female M. inflexa data. We expect more hits between U genes and the female transcriptome, and the V genes and the male transcriptome. Output is stored in .xml format for later processing steps in the ```output/blast/``` directory.

I had some issues getting the blast package downloaded via conda, and (like with Trinity) needed to download and install a specific version from a file.

## 4. Preliminary analysis

Blast output files are run through a script that pull out the best hits for each query, and save the data into a .csv file. From here, you can begin your own analysis of the data based on what questions you want to ask. An initial analysis step of mine was left in that simply plots percent identity values for U vs V gene queries. 

Below are example figures from the first time I completed the pipeline:
![plot](./rawdata/percent_identity_plots_example.png)

But a simple, "ideal" system would have plot output like this:
![plot](./rawdata/ideal_percent_identity_plots.png)

Was the transcriptome assembly terribly inaccurate? Or are there many homologs between the two sex chromosomes? Perhaps one day we will know...

## Future Improvements

There are a few simple improvements that could be made to this pipeline if I were put-together enough to have time for it, listed below:

- Run data file downloads from NCBI in parallel (would save ~2hrs of time)
- Run both transcriptome assemblies in parallel (would save ~5hrs of time)
- List the output file names for the data_download step so it doesn't get run everytime the snakemake workflow is started
- Resolve more minor errors in the Snakefile such as log output not being produced in various rules
- Move this list into the "issues" section of this repository like a competent software engineer
