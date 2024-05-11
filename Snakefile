from snakemake import __version__ as snakemake_version
smk_major_version = int(snakemake_version[0])

if smk_major_version >= 8:
  from snakemake.common.configfile import _load_configfile
else:
  from snakemake.io import _load_configfile

configfile: "config.yaml"

# Define accession codes from the values in the config file
CODES=list(config["codes"])

rule all:
    run:
        for code in CODES:
            shell("fasterq-dump {code} -O ./rawdata/")
