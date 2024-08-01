import gffutils

inputgff="/fs03/tn20/Monique/referencegenome/6_Functional_Annotation/Hap1/4_cleanup/Galeolaria_caespitosa_functional_final_sorted.gff3"
inputhits="/fs03/tn20/Monique/referencegenome/6_Functional_Annotation/Hap1/5_diamond/blast_func/diamond_hits_filtered.txt"
outputdb="/fs03/tn20/Monique/referencegenome/6_Functional_Annotation/Hap1/5_diamond/blast_func/gffutils/Galeolaria_caespitosa_diamondHits.gffdb"
outputgff="/fs03/tn20/Monique/referencegenome/6_Functional_Annotation/Hap1/5_diamond/blast_func/Galeolaria_caespitosa_functional_withDiamondProducts_final.gff3"

db = gffutils.create_db(inputgff, outputdb, force = True)

product_dict = {}
with open(inputhits, 'r') as fin:
    lines = fin.readlines()
    for line in lines:
        sline = line.split('\t')
        transcript_id = sline[0]
        product = sline[1]
        note = sline[2].strip()
        product_dict[transcript_id] = {'product': product, 'note': note}

with open(outputgff, 'w') as fout:
    fout.write("##gff-version 3\n")
    for feat in db.all_features():
        if feat.featuretype == 'gene':
            fout.write(f"{str(feat)}\n")
        elif feat.featuretype == 'mRNA':
            current_product = feat.attributes['product'][0]
            if 'hypothetical' in current_product:
                if feat.id in product_dict.keys():
                    new_product = product_dict[feat.id]['product']
                    new_note = product_dict[feat.id]['note']
                    feat.attributes['product'] = [new_product]
                    feat.attributes['note'] = [new_note]
                    fout.write(f"{str(feat)}\n")
                else:
                    fout.write(f"{str(feat)}\n")
            else:
                fout.write(f"{str(feat)}\n")
        elif feat.featuretype == 'CDS':
            parent_id = [mrna.id for mrna in db.parents(feat.id, featuretype='mRNA')][0]
            current_product = feat.attributes['product'][0]
            if 'hypothetical' in current_product:
                if parent_id in product_dict.keys():
                    new_product = product_dict[parent_id]['product']
                    new_note = product_dict[parent_id]['note']
                    feat.attributes['product'] = [new_product]
                    feat.attributes['note'] = [new_note]
                    fout.write(f"{str(feat)}\n")
                else:
                    fout.write(f"{str(feat)}\n")
            else:
                fout.write(f"{str(feat)}\n")
