from snakemake import __version__ as snakemake_version
smk_major_version = int(snakemake_version[0])

if smk_major_version >= 8:
  from snakemake.common.configfile import _load_configfile
else:
  from snakemake.io import _load_configfile

configfile: "config.yaml"

# Define accession codes from the values in the config file
CODES=list(config["codes"])

rule data_download:
    run:
        for code in CODES:
            shell("fasterq-dump {code} -O ./rawdata/")
            
rule trinity_assembly:
    input:
        male_files1="SRR10271376_1.fastq,SRR10271378_1.fastq,SRR10271386_1.fastq,SRR10271408_1.fastq,SRR10271430_1.fastq",
        male_files2="SRR10271376_2.fastq,SRR10271378_2.fastq,SRR10271386_2.fastq,SRR10271408_2.fastq,SRR10271430_2.fastq",
        female_files1="SRR10271420_1.fastq,SRR10271422_1.fastq,SRR10271424_1.fastq,SRR10271426_1.fastq,SRR10271428_1.fastq",
        female_files2="SRR10271420_2.fastq,SRR10271422_2.fastq,SRR10271424_2.fastq,SRR10271426_2.fastq,SRR10271428_2.fastq"
    output:
        male="output/trinity/male.Trinity.fasta",
        female="output/trinity/female.Trinity.fasta"
    conda:
        "trinity.yaml"
    run:
        shell("Trinity --seqType fq --left {male_files1} --right {male_files2} --CPU 12 --max_memory 200G --output output/trinity/male")
        shell("Trinity --seqType fq --left {female_files1} --right {female_files2} --CPU 12 --max_memory 200G --output output/trinity/female")