# Author: Kira Vasquez-Kapit
# Date: Sept. 26, 2023
# Script Purpose: Requires a .csv file formatted by make_gene_map.py. Builds a
# fasta file from that .csv, and user can specify whether it should contain
# nucleotide or amino acid sequences.

# Imports
import sys

def main():
    # Ensure there are the correct number of input arguments
    if len(sys.argv) != 4:
        print("Please add three arguements: an input .csv file name/path, an output file name/path, and A or N to indicate sequence type.")
        sys.exit(0)

    # Save the file name
    filepath = sys.argv[1]
    # Save the output file name
    output_file = sys.argv[2]
    # Save the seq type requested
    seq_type = sys.argv[3]

    if seq_type == "A": # Amino acid
        write_fasta(filepath, output_file, 1)
    elif seq_type == "N": # Nucleotide
        write_fasta(filepath, output_file, 2)
    else:
        print("Please input a valid sequence type: A or N")

# Open the input and output files, and move each entry to a fasta format in the
# specified sequence type. 1 is amino acid, 2 is nucleotide.
def write_fasta(filepath, output_file, seq_num):
    with open(filepath, 'r') as f:
        f.readline()
        with open(output_file, 'w+') as output:
            for line in f.readlines():
                # Write the gene name in fasta format
                output.write(">" + line.split(",")[0] + "\n")
                # Write the sequence on the next line
                output.write(line.split(",")[seq_num] + "\n")

# Necessary to auto-run the main() function
if __name__ == "__main__":
    main()
