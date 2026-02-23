#!/bin/bash

URL="https://www.kickdrum.com/case-studies"
FILE="case-studies.html"

echo "Downloading using wget..."
wget -O "$FILE" "$URL"

echo "Downloading using curl with progress..."
curl -o "$FILE" -# "$URL"