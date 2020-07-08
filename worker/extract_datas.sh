#!/bin/bash

DATAS_DIR=/home/workuser/datas
OUTPUT_DIR=/home/workuser/datas/dumps

# Create output dir if not exist
if [ ! -d $OUTPUT_DIR ]; then
  mkdir $OUTPUT_DIR
fi

# dump dcm file
cd $DATAS_DIR
for file in $(ls *.dcm)
do
  output_file=${file%.*}
  echo -n "Dump $file in $output_file.dump...  "
  dcmdump $file > $OUTPUT_DIR/$output_file.dump
  echo "done"
done
