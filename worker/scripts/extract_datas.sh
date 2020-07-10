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
  document=()
  for field in ${fields[@]}
  do
    # Extract only value
    document[${#document[@]}]=$(dcmdump $file | grep " $field" | awk -F' ' '{print $3}' |  tail -c +2 | head -c -2)
  done
  # Store datas on collection
  python3 /home/workuser/dcmdumptodb.py $file ${document[@]}
done
