#!/bin/bash

# Files: read-only
find . -type f -exec chmod 444 {} \;

# Directories: rwx for owner only
find . -type d -exec chmod 700 {} \;

# Shell scripts: executable for all
find . -type f -name "*.sh" -exec chmod 755 {} \;