#!/bin/sh

# Use Cases : Given a Dataset with two or multiple folders containing data instances of respective classes.
# Required Folder Structure :
# Train
#  -> Class1
#  -> Class2
#  -> Class3
#  -> ...

# Usage : Copy the script to the Dataset Directory and then execute ./SampleDataset.sh Data_path sample_count

DATASET=$1; # Train Folder Name 
sample_count=$2;

dirpath="${DATASET}/train/*";

for dir in ${dirpath}; do
        dname="${dir##*/}"

        mkdir -p data/${DATASET}_sample/valid/${dname}
        mkdir -p data/${DATASET}_sample/train/${dname}

        shuf -n ${sample_count} -e data/${DATASET}/train/${dname}/* | xargs -i cp {} data/${DATASET}_sample/train/${dname}
        shuf -n ${sample_count} -e data/${DATASET}/valid/${dname}/* | xargs -i cp {} data/${DATASET}_sample/valid/${dname}

done;
