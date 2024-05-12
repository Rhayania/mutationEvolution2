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
        male_trinity="output/trinity/male.Trinity.fasta",
        female_trinity="output/trinity/female.Trinity.fasta"
    log:
        "logs/trinity/trinity.log"
    conda:
        "envs/trinity.yaml"
    run:
        shell("Trinity --seqType fq --left SRR10271376_1.fastq,SRR10271378_1.fastq,SRR10271386_1.fastq,SRR10271408_1.fastq,SRR10271430_1.fastq --right SRR10271376_2.fastq,SRR10271378_2.fastq,SRR10271386_2.fastq,SRR10271408_2.fastq,SRR10271430_2.fastq --CPU 12 --max_memory 200G --output output/trinity/male")
        shell("Trinity --seqType fq --left SRR10271420_1.fastq,SRR10271422_1.fastq,SRR10271424_1.fastq,SRR10271426_1.fastq,SRR10271428_1.fastq --right SRR10271420_2.fastq,SRR10271422_2.fastq,SRR10271424_2.fastq,SRR10271426_2.fastq,SRR10271428_2.fastq --CPU 12 --max_memory 200G --output output/trinity/female")
        
rule make_genes_map:
    ouput:
        u_map="output/make_genes_map/u_genes_map.csv",
        v_map="output/make_genes_map/v_genes_map.csv"
    run:
        shell("gzip -d rawdata/MpTak_v6.1r2.cds.fasta.gz")
        shell("gzip -d rawdata/MpTak_v6.1r2.protein.fasta.gz")
        shell("python scripts/run_genes_map.py")
        
rule make_polymorpha_uv_fastas:
    input:
        u_map="output/make_genes_map/u_genes_map.csv",
        v_map="output/make_genes_map/v_genes_map.csv"
    output:
        u_out="output/make_polymorpha_uv_fastas/u_genes_aa.fasta",
        v_out="output/make_polymorpha_uv_fastas/v_genes_aa.fasta"
    run:
        shell("python scripts/make_fasta.py {u_map} {u_out} A")
        shell("python scripts/make_fasta.py {v_map} {v_out} A")
        
rule run_blast:
    input:
        u_out="output/make_polymorpha_uv_fastas/u_genes_aa.fasta",
        v_out="output/make_polymorpha_uv_fastas/v_genes_aa.fasta",
        male_trinity="output/trinity/male.Trinity.fasta",
        female_trinity="output/trinity/female.Trinity.fasta"
    output:
        u_vs_male="output/blast/blast_u_poly_male_inflexa.out",
        v_vs_male="output/blast/blast_v_poly_male_inflexa.out",
        u_vs_female="output/blast/blast_u_poly_female_inflexa.out",
        v_vs_female="output/blast/blast_v_poly_female_inflexa.out"
    log:
        "logs/blast/blast.log"
    run:
        shell("tblastn -query {u_out} -db {male_trinity} -out {u_vs_male} -evalue 1e-6 -outfmt 5")
        shell("tblastn -query {v_out} -db {male_trinity} -out {v_vs_male} -evalue 1e-6 -outfmt 5")
        shell("tblastn -query {u_out} -db {female_trinity} -out {u_vs_female} -evalue 1e-6 -outfmt 5")
        shell("tblastn -query {v_out} -db {female_trinity} -out {v_vs_female} -evalue 1e-6 -outfmt 5")

rule parse_blast:
    input:
        u_vs_male="output/blast/blast_u_poly_male_inflexa.out",
        v_vs_male="output/blast/blast_v_poly_male_inflexa.out",
        u_vs_female="output/blast/blast_u_poly_female_inflexa.out",
        v_vs_female="output/blast/blast_v_poly_female_inflexa.out"
    output:
        blast_hits_u_male="output/parse_blast/blast_u_poly_male_inflexa_top_hits.csv",
        blast_hits_u_female="output/parse_blast/blast_u_poly_female_inflexa_top_hits.csv",
        blast_hits_v_male="output/parse_blast/blast_v_poly_male_inflexa_top_hits.csv",
        blast_hits_v_female="output/parse_blast/blast_v_poly_female_inflexa_top_hits.csv"
    conda:
        "envs/biopython.yaml"
    run:
        shell("python scripts/parse_blast.py {u_vs_male} {blast_hits_u_male}")
        shell("python scripts/parse_blast.py {u_vs_male} {blast_hits_u_male}")
        shell("python scripts/parse_blast.py {u_vs_male} {blast_hits_u_male}")
        shell("python scripts/parse_blast.py {u_vs_male} {blast_hits_u_male}")
        
rule plot_percent_identity:
    input:
        blast_hits_u_male="output/parse_blast/blast_u_poly_male_inflexa_top_hits.csv",
        blast_hits_u_female="output/parse_blast/blast_u_poly_female_inflexa_top_hits.csv",
        blast_hits_v_male="output/parse_blast/blast_v_poly_male_inflexa_top_hits.csv",
        blast_hits_v_female="output/parse_blast/blast_v_poly_female_inflexa_top_hits.csv"
    output:
        "output/plot_percent_identity/u_chrom_queries.png",
        "output/plot_percent_identity/v_chrom_queries.png"
    shell:
        "python scripts/percent_identity_plots.py"




