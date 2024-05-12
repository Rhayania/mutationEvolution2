# Author: Kira Vasquez-Kapit
# Date: Sept. 28, 2023
# Script Purpose: Parse through XML output of a blast search using Biopython
# to pull out the "best" hits of each query. Output results to a .csv file.

# Imports
import sys
from Bio.Blast import NCBIXML


def main():
    # Ensure there are the correct number of input arguments
    if len(sys.argv) != 3:
        print("Please add two arguements: an input .csv file name/path and an output file name/path.")
        sys.exit(0)

    # Save the file name
    filepath = sys.argv[1]
    # Save the output file name
    output_file = sys.argv[2]

    # Create the output file
    output = open(output_file, 'w+')
    output.write("Query Name,Hit Name,Hit Length,Percent ID,E value\n")

    blast_xml = open(filepath, "r")
    blast_records = NCBIXML.parse(blast_xml)

    # Loop through all query results
    for record in blast_records:
        query_name = record.query # Goes in output file: query name
        try:
            descriptions = list(record.descriptions)
            info = descriptions[0].title
            e_val = descriptions[0].e # Goes in output file :e value

            # Parse the info variable to get result name and result length
            info = info.split()
            hit_name = info[1] # Goes in output file: hit name
            hit_len = info[2].split("=")[1] # Goes in output file: full length of hit

            als = list(record.alignments)
            hsps = list(als[0].hsps)
            identities = hsps[0].identities
            alignment_len = hsps[0].align_length # divide to get percent identity
            percent_id = round(float(identities) / float(alignment_len), 5) # Goes in output file: percent identity

            # Print the output line
            output.write(query_name + "," + hit_name + "," + str(hit_len) + "," + str(percent_id) + "," + str(e_val) + "\n")
        except: # When there are no matches
            output.write(query_name + "," + "-" + "," + "-" + "," + "-" + "," + "-" + "\n")

    blast_xml.close()

# Necessary to auto-run the main() function
if __name__ == "__main__":
    main()
