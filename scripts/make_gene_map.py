# Author: Kira Vasquez-Kapit
# Date: Sept. 14, 2023
# Script Purpose: Take in a list of genes for the U and V chromosomes. Find the
# amino acid and nucleotide sequences for each gene and save the data to .csv
# files for each chromosome.

# Imports
import os

# Variables
path_to_vgenes = "../../vgenes.txt"                         # Path to a .txt file containing gene names found on the V chromosome
path_to_ugenes = "../../ugenes.txt"                         # Path to a .txt file containing gene names found on the U chromosome
path_to_aa_fasta = "../../MpTak_v6.1r2.protein.fasta"       # Path to the fasta file containing the amino acid sequences for each gene
path_to_nuc_fasta = "../../MpTak_v6.1r2.cds.fasta"          # Path to the fasta file containing the nucleotide sequences for each gene
u_filename = "../../u_genes_map.csv"                        # Path to the output file for the U genes map
v_filename = "../../v_genes_map.csv"                        # Path to the output file for the V genes map

def main():
    # Map V chromosome genes
    write_map(path_to_vgenes, v_filename)

    # Map U chromosome genes
    write_map(path_to_ugenes, u_filename)

    # Clean up temp file
    os.system("rm temp")

# Loop through gene names and save the protein and nucleotide sequences for each into a .csv
def write_map(path_to_genes, data_output_file):

    # Create the output file
    data_output_file = open(u_filename, 'w+')
    data_output_file.write("Gene name,Amino Acid Seq,Nucleotide Seq\n")

    genes_file = open(path_to_genes, "r")
    for line in genes_file:
        # Get the gene name
        gene = line.strip()
        # Get the amino acid sequence for this gene
        os.system("grep -A1 " + gene + " " + path_to_aa_fasta + " | grep -v " + gene + " > temp")
        aa_seq = open("temp", "r").readlines()[0].strip()
        # Get the nucleotide sequence for this gene
        os.system("grep -A1 " + gene + " " + path_to_nuc_fasta + " | grep -v " + gene + " > temp")
        nuc_seq = open("temp", "r").readlines()[0].strip()
        # Append this gene's data to the output file
        data_output_file.write(gene + "," + aa_seq + "," + nuc_seq + "\n")

    data_output_file.close()
    genes_file.close()

# Necessary to auto-run the main() function
if __name__ == "__main__":
    main()
