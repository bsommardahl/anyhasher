#!/bin/bash
VERSION=$1
aws ec2 describe-instances \
  --filters "Name=tag:Deployment,Values=$VERSION" "Name=instance-state-name,Values=running" \
  --query 'Reservations[*].Instances[*].PublicDnsName' \
  --output text > ./inventory/hosts