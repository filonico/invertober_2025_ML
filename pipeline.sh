#!/bin/bash

python3 scripts/01_download_genomes_with_datasets.py -i 00_input/phylo_tree_species.tsv -spID -d compiled_softwares/datasets -f genome,protein -o 01_datasets

bash scripts/02_change_datasets_structure.sh

bash scripts/03_rename_datasets_files.sh

mkdir 02_busco/
bash scripts/04_run_busco.sh

grep "C:" 02_busco/*/short*txt | cut -d_ -f3,8 | sed -E 's/_genomic\.fna\.busco\.txt\:\t/\t/; s/,n.+$//' > intermediate_results/01_busco_statistics/busco_scores.tsv

python ../phySCO/phySCO.py -i 02_busco/ -o 03_ML -g 100 -m
