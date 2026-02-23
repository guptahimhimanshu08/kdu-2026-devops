#!/bin/bash

if [ $# -ne 3 ]; then
  echo "Usage: $0 <search> <replace> <directory>"
  exit 1
fi

SEARCH="$1"
REPLACE="$2"
DIR="$3"

find "$DIR" -type f -exec sed -i "s/$SEARCH/$REPLACE/g" {} \;

echo "Replacement completed"