#!/bin/bash

DATAS_DIR=/home/workuser/datas
OUTPUT_DIR=/home/workuser/datas/dumps

# Create output dir if not exist
if [ ! -d $OUTPUT_DIR ]; then
  mkdir $OUTPUT_DIR
fi

# Field we want datas
fields=(StudyInstanceUID SeriesInstanceUID SOPInstanceUID)

# dump dcm file
cd $DATAS_DIR
for file in $(ls *.dcm)
do
  output_file=${file%.*}
  # Clean old file
  rm -rf $OUTPUT_DIR/$output_file.dump
  echo -n "Dump $file in $output_file.dump...  "
  for field in ${fields[@]}
  do
    # Extract only value and field name
    dcmdump $file | grep " $field" | awk -F' ' '{print $7,$3}' >> $OUTPUT_DIR/$output_file.dump
  done
  echo "done"
done
