#!/bin/bash
VERSION=$1

# Create inventory directory if it doesn't exist
if [ ! -d "./inventory" ]; then
  mkdir -p ./inventory
fi

aws ec2 describe-instances \
  --filters "Name=tag:Deployment,Values=$VERSION" "Name=instance-state-name,Values=running" \
  --query 'Reservations[*].Instances[*].PublicDnsName' \
  --output text > ./inventory/hosts
