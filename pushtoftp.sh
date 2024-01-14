#!/bin/sh
# FTP server details
SERVER="192.168.1.18"
USERNAME="Main"
PASSWORD=""  # Ensure the password is filled in for actual use
OTA_FILE="/home/justin/edge2android13/rockdev/Image-kedge2/kedge2-ota-eng.justin.zip"
IMAGE_FILE="/home/justin/edge2android13/rockdev/Image-kedge2/update.img"
OTA_REMOTE_DIR="/ota"  # Remote directory on FTP for OTA file
IMAGE_REMOTE_DIR="/image"  # Remote directory on FTP for Image file

# Function to upload a file with progress using lftp without SSL/TLS
upload_file() {
    local local_file="$1"
    local remote_dir="$2"

    # Check if the file exists
    if [ -f "$local_file" ]; then
        echo "Uploading $local_file to $remote_dir"
        
        # Use lftp without SSL/TLS to upload with progress in passive mode
        lftp -u "$USERNAME,$PASSWORD" -e "set ftp:passive-mode true; set ftp:ssl-allow false; cd $remote_dir; put $local_file; bye" $SERVER
        
        echo "Upload of $local_file to $remote_dir completed."
    else
        echo "File not found: $local_file"
    fi
}

# Upload OTA file
upload_file "$OTA_FILE" "$OTA_REMOTE_DIR"

# Upload Image file
upload_file "$IMAGE_FILE" "$IMAGE_REMOTE_DIR"
