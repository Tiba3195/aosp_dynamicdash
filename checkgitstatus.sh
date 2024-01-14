#!/bin/bash

# List of repositories you want to check
REPOS=(
    "/home/justin/edge2android13/packages/apps/FTPServer"
    "/home/justin/edge2android13/packages/apps/WiFiADB"
    "/home/justin/edge2android13/packages/apps/Repainter"
    "/home/justin/edge2android13/packages/apps/USBGPS"
    "/home/justin/edge2android13/packages/apps/Magisk"
    "/home/justin/edge2android13/packages/apps/QickSwitch"
    "/home/justin/edge2android13/packages/apps/Lawnchair"
    "/home/justin/edge2android13/customdata/keyborads"
    "/home/justin/edge2android13/vendor/rockchip/common/apps/KSettings"
    "/home/justin/edge2android13/customdata"
)

REPO_DIR="/home/justin/edge2android13"
LAST_SYNC_FILE="$REPO_DIR/last_sync_state.txt"
CURRENT_SYNC_FILE="$REPO_DIR/current_sync_state.txt"

# Navigate to the root directory of your repo setup
cd $REPO_DIR

# Clear the current sync file
> "$CURRENT_SYNC_FILE"

# Save the current state of specified repositories
for repo_path in "${REPOS[@]}"; do
    repo_name=$(basename "$repo_path")
    echo "Checking repository for updates: $repo_name"
    echo "Checking repository for updates: $repo_path"
    python3 /home/justin/edge2android13/.repo/repo/repo forall "$repo_path" -c 'echo $REPO_PROJECT $(git rev-parse HEAD)' >> "$CURRENT_SYNC_FILE"
done

# Sync all repositories using repo
echo "Running repo sync to check for updates..."

# Sync each specified project
for repo_name in "${REPOS[@]}"; do
    echo "Syncing project: $repo_name"
    python3 /home/justin/edge2android13/.repo/repo/repo sync -j50 -c --force-sync "$repo_name"
done

# Save the new state of specified repositories
for repo_path in "${REPOS[@]}"; do
    repo_name=$(basename "$repo_path")
    echo "Save the new state of $repo_path"
    python3 /home/justin/edge2android13/.repo/repo/repo forall "$repo_path" -c 'echo $REPO_PROJECT $(git rev-parse HEAD)' >> "$LAST_SYNC_FILE.tmp"
done

# Sort the current and last files alphabetically
sort -o "$CURRENT_SYNC_FILE" "$CURRENT_SYNC_FILE"
sort -o "$LAST_SYNC_FILE.tmp" "$LAST_SYNC_FILE.tmp"

# Check if there are any updates in specified repositories
if diff "$CURRENT_SYNC_FILE" "$LAST_SYNC_FILE.tmp" > /dev/null; then
    echo "No updates detected in any specified repositories."
else
    echo "Updates detected in the following repositories:"
    diff "$CURRENT_SYNC_FILE" "$LAST_SYNC_FILE.tmp" | grep ">" | cut -d ' ' -f 2-
    
    # If updates are detected, you can run the build and upload script here
    echo "Running build and upload script."
   # ./SyncBuildPackage.sh
fi

# Clean up
rm "$LAST_SYNC_FILE.tmp"
