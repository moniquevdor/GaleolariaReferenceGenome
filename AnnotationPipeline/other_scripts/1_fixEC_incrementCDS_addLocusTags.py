#This python script is adapted from Santangelo et al. 2023
# Script to reformat GFF file

import re
import gffutils

# Input file paths
gff_file = "/fs03/tn20/Monique/referencegenome/6_Functional_Annotation/Hap1/3_funannotate/annotations/annotate_results/Galeolaria_caespitosa.gff3"
ec_file = "/fs03/tn20/Monique/referencegenome/6_Functional_Annotation/Hap1/4_cleanup/EC_numbers/enzyme.dat"

# Output file path
output_file = "1_Galeolaria_caespitosa_functional_ECfix_wLocusTags.gff"

# Creat dictionary mapping products to EC numbers
EC_num_to_products = {}
with open(ec_file, 'r') as fin:
    lines = fin.readlines()
    for l in lines:
        if l.startswith('ID'):
            EC_number = l.split('   ')[1].strip()
        if l.startswith('DE'):
            prod = l.split('   ')[1].strip()
            if not EC_number in EC_num_to_products.keys():
                EC_num_to_products[EC_number] = prod
            else:
                EC_num_to_products[EC_number] += EC_num_to_products[EC_number] + prod
        else:
            pass

locus_tag_prefix = "ABL822"
with open(output_file, 'w') as fout:
    fout.write("##gff-version 3\n")
    gene_num = 1
    for feat in gffutils.DataIterator(gff_file):
        if feat.featuretype == 'gene':
            # Set CDS counter
            cds_count = 1
            
            # Add locus tag to genes
            feat.attributes["locus_tag"] = f'{locus_tag_prefix}_' + str(int(gene_num)).zfill(5)
            gene_num += 1
        elif feat.featuretype == 'mRNA':
            if 'product' in feat.attributes.keys() and 'EC_number' in feat.attributes.keys():
                # Rename EC_number
                feat.attributes['ec_number'] = [feat.attributes['EC_number'][0]]
                feat.attributes.pop('EC_number')

                # Reassign product if EC Number to 4 digits, else delete EC Number and keep hypothetical
                EC_number = feat.attributes['ec_number'][0]
                prod = feat.attributes['product'][0]
                if prod == 'hypothetical protein':
                    EC_split = EC_number.split('.')
                    if len(EC_split) < 4:
                        feat.attributes.pop('ec_number')
                    elif len(EC_split) == 4:
                        new_product = EC_num_to_products[EC_number]
                        # Handle cases where EC numbers have been reassigned
                        if 'Transferred' in new_product:
                            # Updated pattern to match multiple EC numbers
                            pattern = r'(?<=:\s)(\d\.\d+\.\d+\.\d+)'
                            matches = re.findall(pattern, new_product)    
                            if matches:
                                # Assuming we want to use the first matched EC number
                                new_ec = matches[0]
                                new_product = EC_num_to_products.get(new_ec, "Unknown EC")
                            else:
                                print(f"Warning: EC number not found in the product description: {new_product}")
                                new_product = "Unknown EC"
                        new_product = new_product.replace('.', '')
                        feat.attributes['product'] = [new_product]
                        # Add note to GFF about origin of Product
                        feat.attributes['note'] = ["Funannotate product changed from hypothetical protein based on EC_number"]
                else:
                    EC_split = EC_number.split('.')
                    if len(EC_split) < 4:
                        new_ec = '.'.join(EC_split + ['-'] * (4 - len(EC_split)))
                        feat.attributes['ec_number'] = [new_ec]
        elif feat.featuretype == 'CDS':
            # Assign increment CDS to ensure unique ID
            feat.attributes['ID'][0] = re.sub('cds', f'cds{cds_count}', feat.attributes['ID'][0])
            cds_count += 1
        else:
            pass
        fout.write(str(feat) + '\n')
