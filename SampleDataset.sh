#!/bin/sh
DATASET="the-nature-conservancy-fisheries-monitoring"; #dogscats

dirpath="data/${DATASET}/train/*";

for dir in ${dirpath}; do
        dname="${dir##*/}"

        mkdir -p data/${DATASET}_sample/valid/${dname}
        mkdir -p data/${DATASET}_sample/train/${dname}

        shuf -n 200 -e data/${DATASET}/train/${dname}/* | xargs -i cp {} data/${DATASET}_sample/train/${dname}
        shuf -n 100 -e data/${DATASET}/valid/${dname}/* | xargs -i cp {} data/${DATASET}_sample/valid/${dname}

done;
