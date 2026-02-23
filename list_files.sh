#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <parent_directory>"
    exit 1
fi

PARENT_DIR=$1
LOG_FILE="files_list.log"

> "$LOG_FILE"

if [ ! -d "$PARENT_DIR" ]; then
    echo "Error: Directory $PARENT_DIR does not exist."
    exit 1
fi

for dir in "$PARENT_DIR"/*; do
    if [ -d "$dir" ]; then
        echo "Directory: $dir" | tee -a "$LOG_FILE"

        for file in "$dir"/*; do
            if [ -f "$file" ]; then
                echo "  File: $(basename "$file")" | tee -a "$LOG_FILE"
            fi
        done
        echo "" >> "$LOG_FILE"
    fi
done

echo "File listing completed. Log saved at $LOG_FILE"
