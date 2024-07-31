#!/bin/bash

# Variables
MONGO_DATABASE="myDatabase"
BACKUP_DIR="/var/backups/mongo"
TIMESTAMP=$(date +"%F_%H-%M-%S")
BACKUP_NAME="mongo_backup_$TIMESTAMP"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"
S3_BUCKET="mongo-db-bucket1"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Perform MongoDB backup
mongodump --db "$MONGO_DATABASE" --out "$BACKUP_PATH"

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "MongoDB backup completed successfully."

    # Compress the backup directory
    tar -czf "$BACKUP_PATH.tar.gz" -C "$BACKUP_DIR" "$BACKUP_NAME"

    # Upload the backup to S3
    aws s3 cp "$BACKUP_PATH.tar.gz" s3://"$S3_BUCKET"/"$BACKUP_NAME.tar.gz"

    # Check if upload was successful
    if [ $? -eq 0 ]; then
        echo "Backup uploaded to S3 successfully."
    else
        echo "Failed to upload backup to S3."
    fi

    # Remove the local backup files
    rm -rf "$BACKUP_PATH" "$BACKUP_PATH.tar.gz"
else
    echo "MongoDB backup failed."
fi
