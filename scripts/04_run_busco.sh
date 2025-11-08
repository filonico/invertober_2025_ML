#!/bin/bash

for i in 01_datasets/*/*fna; do

	spID="$(basename $i | awk -F "_" '{print $1"_"$2}')" &&
	LINEAGE="metazoa_odb10" &&

	busco -i $i -l $LINEAGE -o 02_busco/$(basename $i).busco -m genome -c 8
done

rm -rf busco_downloads/ busco*log
