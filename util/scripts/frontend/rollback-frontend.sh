#!/bin/bash
set -e

BUCKET_NAME=$1

if [ -z "$BUCKET_NAME" ]; then
  echo "Error: Bucket name is required"
  exit 1
fi

echo "🔄 Rolling back frontend to previous version..."

# Check if rollback backup exists and has files
if [ -d "rollback-backup" ] && [ "$(ls -A rollback-backup)" ]; then
  echo "📁 Found rollback backup, proceeding with rollback..."

  # Restore from rollback backup
  aws s3 sync rollback-backup/ s3://$BUCKET_NAME --delete --exclude ".backup-info"
  aws s3 cp rollback-backup/index.html s3://$BUCKET_NAME/index.html --cache-control "no-cache"

  echo "✅ Rollback completed successfully!"
else
  echo "❌ No rollback backup found or backup is empty"
  echo "🚨 Manual intervention required"
  exit 1
fi

