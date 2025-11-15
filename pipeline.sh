#!/bin/bash

##########################################
#     DOWNLOAD DATA AND TIDY THEM UP     #
##########################################

python3 scripts/01_download_genomes_with_datasets.py -i 00_input/phylo_tree_species.tsv -spID -d compiled_softwares/datasets -f genome,protein -o 01_datasets

bash scripts/02_change_datasets_structure.sh

bash scripts/03_rename_datasets_files.sh


#####################
#     RUN BUSCO     #
####################

mkdir 02_busco/
bash scripts/04_run_busco.sh

grep "C:" 02_busco/*/short*txt | cut -d_ -f3,8 | sed -E 's/_genomic\.fna\.busco\.txt\:\t/\t/; s/,n.+$//' > intermediate_results/01_busco_statistics/busco_scores.tsv


#################################
#      ESTIMATE THE ML TREE     #
#################################

python ../phySCO/phySCO.py -i 02_busco/ -o 03_ML -g 100 -m

python scripts/ReDictio.py -f 03_ML_withOUT/MLtree.treefile -d 00_input/ID_species_conversion.tsv -i new
