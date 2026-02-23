#!/bin/bash

git clone https://github.com/<username>/KDU-phase-2.git
cd KDU-phase-2 || exit

ls

touch new_file.txt
echo "Linux Essentials Assignment" > new_file.txt

git checkout -b linux-assignment
git add .
git commit -m "Added new file via shell script"
git push origin linux-assignment