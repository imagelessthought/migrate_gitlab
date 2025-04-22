#!/bin/bash

# Usage: ./split_repo_list.sh gitlab-repos.txt

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <repo-list-file>"
  exit 1
fi

INPUT_FILE="$1"
LINES_PER_FILE=15
OUTPUT_PREFIX="repo_list_part_"

# Split the file into chunks of 25 lines, numbered with suffixes
split -l $LINES_PER_FILE -d --additional-suffix=".txt" "$INPUT_FILE" "$OUTPUT_PREFIX"

echo "Split complete. Created files:"
ls ${OUTPUT_PREFIX}*.txt
