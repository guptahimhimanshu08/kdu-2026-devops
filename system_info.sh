#!/bin/bash

echo "CPU Usage:"
top -bn1 | grep "Cpu(s)"

echo
echo "User CPU Percentage:"
top -bn1 | grep "Cpu(s)" | awk '{print $2 "%"}'

echo
echo "Idle CPU Percentage:"
top -bn1 | grep "Cpu(s)" | awk '{print $8 "%"}'

echo
echo "Running Processes:"
ps -e --no-headers | wc -l

echo
echo "Kernel Name:"
uname -r

echo
echo "Free Storage:"
df -h