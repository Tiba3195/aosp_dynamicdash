#!/bin/bash

# Function to check if a command succeeded
check_command_success() {
    if [ $? -eq 0 ]; then
        echo "Command succeeded"
        return 0
    else
        echo "Command failed"
        return 1
    fi
}

# Build the ROM
./build.sh -Au -J20

# Check if the build succeeded
check_command_success

# If the build succeeded, push to FTP
if [ $? -eq 0 ]; then
    ./pushtoftp.sh
fi