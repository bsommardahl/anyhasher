#!/bin/bash

BUCKET_NAME="app.anyhasher.io"

# Basic validation
if [ -z "$BUCKET_NAME" ]; then
  echo "Usage: $0 <bucket-name>"
  exit 1
fi

echo "Starting rollback for: $BUCKET_NAME"

# Function to get the Nth version of a file
get_nth_version() {
  local file="$1"
  local position="$2" # 2 for second version, 3 for third, etc.

  aws s3api list-object-versions \
    --bucket "$BUCKET_NAME" \
    --prefix "$file" \
    --query "Versions[?Key=='$file'].VersionId" \
    --output text | tr '\t' '\n' | sed -n "${position}p"
}

# Function to restore file to specific version
restore_file() {
  local file="$1"
  local version_id="$2"

  aws s3api copy-object \
    --bucket "$BUCKET_NAME" \
    --copy-source "$BUCKET_NAME/$file?versionId=$version_id" \
    --key "$file" >/dev/null

  echo "✅ $file restored"
}

# Restore index.html to 2 versions back (position 3)
INDEX_VERSION=$(get_nth_version "index.html" 3)
if [ -n "$INDEX_VERSION" ]; then
  restore_file "index.html" "$INDEX_VERSION"
else
  echo "❌ Could not get index.html version"
fi

# Get all files and restore to 1 version back
aws s3 ls s3://$BUCKET_NAME --recursive | awk '{print $4}' | while read file; do
  if [ "$file" != "index.html" ] && [ -n "$file" ]; then
    VERSION=$(get_nth_version "$file" 2)
    if [ -n "$VERSION" ]; then
      restore_file "$file" "$VERSION"
    else
      echo "⚠️  No previous version for: $file"
    fi
  fi
done

echo "🎉 Rollback completed!"
