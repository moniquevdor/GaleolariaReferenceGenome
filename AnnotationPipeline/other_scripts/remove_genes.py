# Define file names
gff3_file = "Galeolaria_caespitosa_functional_withDiamondProducts_final_sorted.gff3"
genes_to_remove_file = "genes_to_remove.txt"
output_gff3_file = "Final_Functionnal_Annotation_H1.gff3"

# Read the genes to remove into a set
with open(genes_to_remove_file, "r") as file:
    genes_to_remove = set(line.strip() for line in file)

# Open the GFF3 file and filter lines
with open(gff3_file, "r") as infile, open(output_gff3_file, "w") as outfile:
    remove_gene = False  # Flag to track whether to skip a gene block

    for line in infile:
        if line.startswith("#") or not line.strip():
            # Write header and blank lines to the output
            outfile.write(line)
            continue
        
        # Split the line into columns
        columns = line.strip().split("\t")
        attributes = columns[8]
        
        # Check for a gene feature and its ID
        if columns[2] == "gene":
            remove_gene = False  # Reset flag for each new gene
            for attribute in attributes.split(";"):
                if attribute.startswith("ID="):
                    gene_id = attribute.split("=")[1]
                    if gene_id in genes_to_remove:
                        remove_gene = True  # Mark this gene for removal
                        break
        
        # Write the line if the current gene is not marked for removal
        if not remove_gene:
            outfile.write(line)

print(f"Filtered GFF3 file has been written to {output_gff3_file}")
