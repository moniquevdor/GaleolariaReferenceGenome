#This python script is adapted from Santangelo et al. 2023
import os
import gffutils
from collections import defaultdict

# Input and output file paths (modify these paths or use command line arguments)
input_gff = "3_Galeolaria_caespitosa_functional_fixOverlaps.gff3"
output_gff = "4_Galeolaria_caespitosa_functional_longest.gff3"
temp_db = 'tmp.db'

# Create a temporary database from the GFF3 file
db = gffutils.create_db(input_gff, temp_db, force=True)

def is_functionally_important(mrna_id):
    """
    Determine if an mRNA isoform is functionally important.
    This is a placeholder function. Replace this with actual logic to check functional domains,
    expression levels, or other criteria to identify important isoforms.
    """
    # Example: Checking if the mRNA has a certain functional domain (this is a stub)
    # You would need to integrate with a tool or database to fetch this information
    # For now, let's assume a certain ID pattern or an external list
    # We're not using this, but if your busco scores go down after picking the longest isoform, you can play around with this
    important_ids = {"mRNA_important_1", "mRNA_important_2"}
    return mrna_id in important_ids

# Track transcripts to remove
transcripts_to_toss = []

# Iterate over each gene
for gene in db.features_of_type('gene'):
    child_mrna = list(db.children(gene.id, featuretype='mRNA'))
    if len(child_mrna) > 1:
        # Calculate lengths of CDS regions for each mRNA isoform
        isoform_lengths = {mrna.id: sum(cds.end - cds.start for cds in db.children(mrna.id, featuretype='CDS')) for mrna in child_mrna}
        
        # Handle isoforms with the same length
        if len(set(isoform_lengths.values())) == 1:
            # Toss all but the first one (or select based on additional criteria)
            same_length_to_toss = list(isoform_lengths.keys())[1:]
            transcripts_to_toss += same_length_to_toss
        else:
            # Identify the longest isoform length
            longest_isoform_length = max(isoform_lengths.values())
            longest_isoforms = [k for k, v in isoform_lengths.items() if v == longest_isoform_length]
            
            # Check for functional importance
            important_isoforms = [isoform for isoform in longest_isoforms if is_functionally_important(isoform)]
            
            # If there are important isoforms, keep them, otherwise keep the first longest
            if important_isoforms:
                transcripts_to_toss += [isoform for isoform in longest_isoforms if isoform not in important_isoforms]
            else:
                # Toss all but the first longest isoform
                transcripts_to_toss += longest_isoforms[1:]

# Write the results to the output file
with open(output_gff, 'w') as fout:
    fout.write("##gff-version 3\n")
    for feat in db.all_features():
        if feat.featuretype == 'mRNA':
            if feat.id not in transcripts_to_toss:
                fout.write(f"{str(feat)}\n")
        elif feat.featuretype == 'CDS':
            mrna_parent = next(db.parents(feat.id, featuretype='mRNA')).id
            if mrna_parent not in transcripts_to_toss:
                fout.write(f"{str(feat)}\n")
        else:
            fout.write(f"{str(feat)}\n")

# Clean up the temporary database
os.remove(temp_db)
