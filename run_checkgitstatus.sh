#!/bin/bash

# Time interval in seconds (e.g., 5 minutes)
interval=60

while true; do
    # Check if the Soong build process is running
    if pgrep -f "soong[^_]" > /dev/null; then
        echo "Soong build is running, skipping checkgitstatus.sh at $(date)"
    elif pgrep -f "ninja" > /dev/null; then
        echo "Ninja build is running, skipping checkgitstatus.sh at $(date)"
    else
        echo "Running checkgitstatus.sh at $(date)"
        ./checkgitstatus.sh
    fi

    echo "Sleeping for $interval seconds..."
    sleep $interval
done