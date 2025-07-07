#!/bin/bash
VERSION=$1

# Create inventory directory if it doesn't exist
mkdir -p ./util/ansible/inventory

cat >./util/ansible/inventory/hosts <<EOF
[ec2]
EOF

aws ec2 describe-instances \
  --filters "Name=tag:Deployment,Values=$VERSION" "Name=instance-state-name,Values=running" \
  --query 'Reservations[*].Instances[*].PublicDnsName' \
  --output text | sed 's/^/ubuntu@/' >>./util/ansible/inventory/hosts
