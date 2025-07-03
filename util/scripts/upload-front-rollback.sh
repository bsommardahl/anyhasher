#!/bin/bash

BUCKET_NAME="app.anyhasher.io"
BACKUP_DIR="./rollback-backup"

# Function to list available backups
list_backups() {
  echo "📋 Available backups:"
  if [ -d "$BACKUP_DIR" ]; then
    ls -la "$BACKUP_DIR" | grep "^d" | awk '{print $9}' | grep -E "^[0-9]{8}_[0-9]{6}$" | sort -r
  else
    echo "No backups found in $BACKUP_DIR"
  fi
}

# Check if backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
  echo "❌ Backup directory not found: $BACKUP_DIR"
  echo "Please run backup-frontend.sh first"
  exit 1
fi

# If no argument provided, show available backups
if [ -z "$1" ]; then
  echo "Usage: $0 <backup-timestamp>"
  echo "Example: $0 20241201_143022"
  echo ""
  list_backups
  exit 1
fi

BACKUP_TIMESTAMP="$1"
RESTORE_PATH="$BACKUP_DIR/$BACKUP_TIMESTAMP"

# Validate backup exists
if [ ! -d "$RESTORE_PATH" ]; then
  echo "❌ Backup not found: $RESTORE_PATH"
  echo ""
  list_backups
  exit 1
fi

# Show backup info if available
if [ -f "$RESTORE_PATH/.backup-info" ]; then
  echo "📄 Backup information:"
  cat "$RESTORE_PATH/.backup-info"
  echo ""
fi

# Confirmation prompt - MORE DRAMATIC
echo "🚨 DANGER: This will COMPLETELY WIPE the bucket: $BUCKET_NAME"
echo "📁 And replace with ONLY files from: $RESTORE_PATH"
echo "⚠️  ALL CURRENT FILES WILL BE PERMANENTLY DELETED!"
echo ""
read -p "Type 'DELETE' to confirm this destructive action: " -r
echo
if [[ ! $REPLY == "DELETE" ]]; then
  echo "❌ Rollback cancelled - must type 'DELETE' to confirm"
  exit 1
fi

echo "🗑️  Step 1: Removing ALL objects from bucket..."
# Get all objects (including versions if versioned)
OBJECTS=$(aws s3api list-objects-v2 --bucket "$BUCKET_NAME" --query 'Contents[].Key' --output text)

if [ -n "$OBJECTS" ]; then
  echo "🔥 Deleting all current objects..."
  for object in $OBJECTS; do
    echo "  - Deleting: $object"
    aws s3api delete-object --bucket "$BUCKET_NAME" --key "$object" >/dev/null 2>&1
  done
else
  echo "ℹ️  No objects found to delete"
fi

# Also delete all versions if versioning is enabled
echo "🗑️  Cleaning up all object versions..."
aws s3api list-object-versions --bucket "$BUCKET_NAME" --query 'Versions[].{Key:Key,VersionId:VersionId}' --output text | while read key version; do
  if [ -n "$key" ] && [ -n "$version" ] && [ "$version" != "null" ]; then
    echo "  - Deleting version: $key ($version)"
    aws s3api delete-object --bucket "$BUCKET_NAME" --key "$key" --version-id "$version" >/dev/null 2>&1
  fi
done

# Clean up delete markers
echo "🗑️  Cleaning up delete markers..."
aws s3api list-object-versions --bucket "$BUCKET_NAME" --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' --output text | while read key version; do
  if [ -n "$key" ] && [ -n "$version" ] && [ "$version" != "null" ]; then
    echo "  - Removing delete marker: $key ($version)"
    aws s3api delete-object --bucket "$BUCKET_NAME" --key "$key" --version-id "$version" >/dev/null 2>&1
  fi
done

echo "✅ Bucket completely cleaned!"

# Verify bucket is empty
REMAINING=$(aws s3 ls s3://$BUCKET_NAME --recursive | wc -l)
if [ "$REMAINING" -eq 0 ]; then
  echo "✅ Bucket is now empty"
else
  echo "⚠️  Warning: $REMAINING files still remain in bucket"
fi

echo ""
echo "📤 Step 2: Uploading files from rollback backup..."

# Upload files from backup (excluding metadata)
aws s3 sync "$RESTORE_PATH" s3://$BUCKET_NAME --exclude ".backup-info" --exclude ".*"

if [ $? -eq 0 ]; then
  echo "✅ Upload completed successfully!"

  # Set proper cache control for index.html
  if [ -f "$RESTORE_PATH/index.html" ]; then
    echo "🔄 Setting no-cache for index.html..."
    aws s3 cp "$RESTORE_PATH/index.html" s3://$BUCKET_NAME/index.html --cache-control "no-cache"
  fi

  echo "🎉 Frontend completely restored to: $BACKUP_TIMESTAMP"
  echo ""
  echo "📋 Final verification:"
  aws s3 ls s3://$BUCKET_NAME --recursive
else
  echo "❌ Upload failed!"
  echo "🚨 WARNING: Bucket may be in an inconsistent state!"
  exit 1
fi
