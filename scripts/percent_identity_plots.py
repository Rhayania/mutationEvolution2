# Author: Kira Vasquez-Kapit
# Date: Oct 5, 2023
# Script Purpose: Make two scatter plots of male vs female percent identity
# for the U and V chromosome queries.

# Imports
import matplotlib.pyplot as plt

# Variables
u_male_file = "output/parse_blast/blast_u_poly_male_inflexa_top_hits.csv"
u_female_file = "output/parse_blast/blast_u_poly_female_inflexa_top_hits.csv"
v_male_file = "output/parse_blast/blast_v_poly_male_inflexa_top_hits.csv"
v_female_file = "output/parse_blast/blast_v_poly_female_inflexa_top_hits.csv"

def main():
    make_scatter(u_male_file, u_female_file, 1, "U")
    make_scatter(v_male_file, v_female_file, 2, "V")

    # To show the plots
    plt.show()


def make_scatter(male_file, female_file, num, chrom):

    # Variables
    male = []
    female = []

    # Get male data
    male_data = open(male_file, "r")
    male_data.readline()
    for line in male_data.readlines():
        line = line.split(",")
        male.append(line[3])
    # Change non-numeric values to 0
    for val in range(len(male)):
        if male[val] == '-':
            male[val] = '0'
    male = list(map(float, male))
    male_data.close()

    # Get female data
    female_data = open(female_file, "r")
    female_data.readline()
    for line in female_data.readlines():
        line = line.split(",")
        female.append(line[3])
    # Change non-numeric values to 0
    for val in range(len(female)):
        if female[val] == '-':
            female[val] = '0'
    female = list(map(float, female))
    female_data.close()


    # Plot the dada and add labels
    new_plot = plt.figure(num)
    plt.xlim(0, 1)
    plt.ylim(0, 1)
    plt.plot([0, 1], [0, 1]) # Add x = y diagonal line
    plt.xlabel('Male Percent Identity')
    plt.ylabel('Female Percent Identity')
    plt.title('Male vs. female hit percent identities for ' + chrom + ' chromosome queries')

    plt.scatter(male, female)



# Necessary to auto-run the main() function
if __name__ == "__main__":
    main()