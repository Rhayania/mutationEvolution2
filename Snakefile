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
    log:
        "logs/data_download/download.log"
    run:
        for code in CODES:
            shell("fasterq-dump {code} -O ./rawdata/")
            
rule trinity_assembly:
    output:
        male="output/trinity/male.Trinity.fasta",
        female="output/trinity/female.Trinity.fasta"
    log:
        "logs/trinity/trinity.log"
    conda:
        "trinity.yaml"
    run:
        shell("Trinity --seqType fq --left SRR10271376_1.fastq,SRR10271378_1.fastq,SRR10271386_1.fastq,SRR10271408_1.fastq,SRR10271430_1.fastq --right SRR10271376_2.fastq,SRR10271378_2.fastq,SRR10271386_2.fastq,SRR10271408_2.fastq,SRR10271430_2.fastq --CPU 12 --max_memory 200G --output output/trinity/male")
        shell("Trinity --seqType fq --left SRR10271420_1.fastq,SRR10271422_1.fastq,SRR10271424_1.fastq,SRR10271426_1.fastq,SRR10271428_1.fastq --right SRR10271420_2.fastq,SRR10271422_2.fastq,SRR10271424_2.fastq,SRR10271426_2.fastq,SRR10271428_2.fastq --CPU 12 --max_memory 200G --output output/trinity/female")
        
rule make_genes_map:
    ouput:
        u_map="rawdata/u_genes_map.csv",
        v_map="rawdata/v_genes_map.csv"
    shell:
        "python scripts/run_genes_map.py"
        
rule make_polymorpha__uv_fastas:
    output:
        u_out="rawdata/u_genes_aa.fasta",
        v_out="rawdata/v_genes_aa.fasta"
    run:
        shell("python scripts/make_fasta.py {u_map} {u_out} A")
        shell("python scripts/make_fasta.py {v_map} {v_out} A")






