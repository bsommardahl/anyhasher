#!/bin/bash

BUCKET_NAME="app.anyhasher.io"
BACKUP_DIR="./rollback-backup"

echo "🔄 Starting frontend backup from: $BUCKET_NAME"

# Remove existing backup if it exists
if [ -d "$BACKUP_DIR" ]; then
  echo "🗑️  Removing existing backup..."
  rm -rf "$BACKUP_DIR"
fi

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Download all files from S3 bucket
echo "📥 Downloading files to: $BACKUP_DIR"
aws s3 sync s3://$BUCKET_NAME "$BACKUP_DIR" --delete

if [ $? -eq 0 ]; then
  echo "✅ Backup completed successfully!"
  echo "📁 Files saved in: $BACKUP_DIR"

  # Create a manifest file with metadata
  echo "BUCKET_NAME=$BUCKET_NAME" >"$BACKUP_DIR/.backup-info"
  echo "BACKUP_DATE=$(date)" >>"$BACKUP_DIR/.backup-info"

  # List contents for verification
  echo "📋 Backup contents:"
  ls -la "$BACKUP_DIR"
else
  echo "❌ Backup failed!"
  exit 1
fi
