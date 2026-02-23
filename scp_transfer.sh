#!/bin/bash

LOCAL_DIR="./files"
REMOTE_USER="ec2-user"
REMOTE_IP="YOUR_EC2_PUBLIC_IP"
REMOTE_DIR="/Users/$REMOTE_USER/Downloads"

# Create files
mkdir -p "$LOCAL_DIR"
touch "$LOCAL_DIR"/file{1..5}.txt

# Compress
tar -czvf files.tar.gz "$LOCAL_DIR"

# Upload
scp files.tar.gz "$REMOTE_USER@$REMOTE_IP:$REMOTE_DIR"

# Download back
scp "$REMOTE_USER@$REMOTE_IP:$REMOTE_DIR/files.tar.gz" /Users/$USER/Downloads