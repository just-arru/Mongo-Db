# Find the latest backup file
LATEST_BACKUP=$(aws s3 ls s3://"$S3_BUCKET"/ --region us-east-1 | sort | tail -n 1 | awk '{print $4}')

if [ -z "$LATEST_BACKUP" ]; then
    echo "No backup files found in S3 bucket."
    exit 1
fi

echo "Latest backup file: $LATEST_BACKUP"

# Download the latest backup file from S3
aws s3 cp s3://"$S3_BUCKET"/"$LATEST_BACKUP" "$RESTORE_DIR/"

# Check if download was successful
if [ $? -eq 0 ]; then
    echo "Backup file downloaded successfully."

    # Extract the backup file
    tar -xzvf "$RESTORE_DIR/$LATEST_BACKUP" -C "$RESTORE_DIR/"

    # Get the name of the extracted directory
    BACKUP_NAME=$(basename "$LATEST_BACKUP" .tar.gz)

    # Check if extraction was successful
    if [ $? -eq 0 ]; then
        echo "Backup file extracted successfully."

        # Restore the backup to MongoDB
        mongorestore --db "$DATABASE_NAME" "$RESTORE_DIR/$BACKUP_NAME/$DATABASE_NAME"

        if [ $? -eq 0 ]; then
            echo "Database restored successfully."
        else
            echo "Failed to restore the database."
        fi

    else
        echo "Failed to extract the backup file."
    fi

else
        echo "Failed to download the backup file."
fi

# Clean up
rm -rf "$RESTORE_DIR/$LATEST_BACKUP" "$RESTORE_DIR/$BACKUP_NAME"

