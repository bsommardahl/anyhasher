#!/bin/bash
set -e

VERSION=$1
S3_BUCKET="anyhasher-artifacts-prod-canary"

# Debug: List files to see what we have
echo "📁 Files in current directory:"
ls -la

aws s3 cp backend-artifact-$VERSION.tar.gz s3://$S3_BUCKET/backend/$VERSION/
aws s3 cp util/ansible/ s3://$S3_BUCKET/ansible/ --recursive
echo "s3_bucket=$S3_BUCKET" >> $GITHUB_OUTPUT
echo "✅ Artifact uploaded to s3://$S3_BUCKET/backend/$VERSION/"
echo "✅ Ansible playbooks uploaded to s3://$S3_BUCKET/ansible/"
