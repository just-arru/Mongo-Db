#!/bin/bash

# Variables
MONGO_DATABASE="test"       # Replace with your MongoDB database name
MONGO_BACKUP_DIR="/var/backups/mongo"     # Temporary backup directory
EBS_MOUNT_POINT="/mnt/ebs_volume"         # EBS volume mount point
TIMESTAMP=$(date +"%F_%H-%M-%S")          # Current date and time in YYYY-MM-DD_HH-MM-SS format
BACKUP_NAME="mongo_backup_$TIMESTAMP"     # Backup directory name with timestamp
BACKUP_PATH="$MONGO_BACKUP_DIR/$BACKUP_NAME" # Full backup path

# Create backup directory if it doesn't exist
mkdir -p "$MONGO_BACKUP_DIR"

# Perform MongoDB backup
mongodump --db "$MONGO_DATABASE" --out "$BACKUP_PATH"

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "MongoDB backup completed successfully."

    # Move the backup to the EBS volume
    mv "$BACKUP_PATH" "$EBS_MOUNT_POINT"

    # Check if move was successful
    if [ $? -eq 0 ]; then
        echo "Backup moved to EBS volume successfully."
    else
        echo "Failed to move backup to EBS volume."
    fi
else
    echo "MongoDB backup failed."
fi
