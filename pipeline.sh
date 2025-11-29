#!/bin/bash

##########################################
#     DOWNLOAD DATA AND TIDY THEM UP     #
##########################################

python3 scripts/01_download_genomes_with_datasets.py -i 00_input/dataset.tsv -spID -d compiled_softwares/datasets -f genome,protein -o 01_datasets

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

python ../phySCO/phySCO.py -i 02_busco/ -o 03a_ML_aa -g 100 -m

grep -Ei "salpi|mono" 00_input/ID_species_conversion.tsv | cut -f2 > 03a_ML_aa/outgroups.ls
grep -Ei "salpi|mono" 00_input/ID_species_conversion.tsv | cut -f1 > 03a_ML_aa/outgroups_accessions.ls
gotree reroot outgroup -i 03a_ML_aa/MLtree.treefile -o 03a_ML_aa/MLtree_rooted.treefile -l 03a_ML_aa/outgroups_accessions.ls
iqtree -p 03a_ML_aa/MLtree.best_scheme.nex -te 03a_ML_aa/MLtree_rooted.treefile --date 00_input/calibrations.txt --date-tip 0 --date-ci 100

python scripts/05_ReDictio.py -f 03_ML_withOUT/MLtree.treefile -d 00_input/ID_species_conversion.tsv -i new
mkdir -p 04_plots/01_inputs

grep ">" 03a_ML_aa/fasta_files_aligned_trimmed/*faa | sed -E 's/^.+_trimmed\///; s/_.+>/\t/' > 04_plots/01_inputs/gene_per_genomes.tsv
ln -s ../../00_input/species_per_class.tsv 04_plots/01_inputs/
