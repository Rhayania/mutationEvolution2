#!/bin/bash
#SBATCH --job-name=snakemake                   # Job name
#SBATCH --output=logs/snakemake_out.%j.out     # Output file
#SBATCH --error=logs/snakemake_err.%j.err      # Error file
#SBATCH --nodes=1                              # Number of nodes
#SBATCH --ntasks-per-node=1                    # Number of tasks per node
#SBATCH --cpus-per-task=12                      # Number of CPU cores per task
#SBATCH --time=6:00:00                         # Time limit (format: HH:MM:SS)

# Load modules
module load sra-toolkit

# Activate conda environment
source activate snakemake-8.5.3

# Execute Snakemake with the desired options
snakemake --use-conda --cores $SLURM_CPUS_PER_TASK
