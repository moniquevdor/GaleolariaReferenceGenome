# Define the input and output file names
input_file = "Galeolaria_caespitosa_functional_withDiamondProducts_final_sorted.gff3"
output_file = "hypothetical_protein_genes.txt"

# Open the GFF3 file
with open(input_file, "r") as file:
    gene_ids = set()
    current_gene_id = None

    # Loop through each line in the file
    for line in file:
        if line.startswith("#") or not line.strip():
            continue  # Skip comments and blank lines
        
        # Split the GFF3 line into columns
        columns = line.strip().split("\t")
        feature_type = columns[2]
        attributes = columns[8]
        
        # Check for a gene feature
        if feature_type == "gene":
            # Extract the gene ID from the attributes column
            for attribute in attributes.split(";"):
                if attribute.startswith("ID="):
                    current_gene_id = attribute.split("=")[1]
                    break
        
        # Check if the product is "hypothetical protein"
        if "product=hypothetical protein" in attributes:
            if current_gene_id:
                gene_ids.add(current_gene_id)
    
# Write the gene IDs to a text file
with open(output_file, "w") as out_file:
    for gene_id in sorted(gene_ids):
        out_file.write(gene_id + "\n")

print(f"Gene IDs have been written to {output_file}")

# Define file names
hypothetical_file = "hypothetical_protein_genes.txt"
gene_hits_file = "gene_hits.txt"
output_file = "genes_to_remove.txt"

# Read the hypothetical proteins file into a set
with open(hypothetical_file, "r") as file:
    hypothetical_proteins = set(line.strip() for line in file)

# Read the gene hits file into a set
with open(gene_hits_file, "r") as file:
    gene_hits = set(line.strip() for line in file)

# Get the difference: hypothetical proteins not in gene hits
genes_to_remove = hypothetical_proteins - gene_hits

# Write the result to the output file
with open(output_file, "w") as file:
    for gene in sorted(genes_to_remove):
        file.write(gene + "\n")

print(f"Genes to remove have been written to {output_file}")
