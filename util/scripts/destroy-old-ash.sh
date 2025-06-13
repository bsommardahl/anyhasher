#!/bin/bash
set -e

ENVIRONMENT=$1
CURRENT_VERSION=$2

if [[ -z "$ENVIRONMENT" || -z "$CURRENT_VERSION" ]]; then
  echo "Usage: $0 <environment> <current_version>"
  exit 1
fi

echo "Cleaning up ASGs for environment: $ENVIRONMENT (keeping version: $CURRENT_VERSION)"

# Get all ASGs for the environment
ALL_ASGS=$(aws autoscaling describe-auto-scaling-groups \
  --query "AutoScalingGroups[?starts_with(AutoScalingGroupName, \`${ENVIRONMENT}-anyhasher-\`)].AutoScalingGroupName" \
  --output text)

for ASG in $ALL_ASGS; do
  if [[ "$ASG" != "${ENVIRONMENT}-anyhasher-${CURRENT_VERSION}" ]]; then
    echo "Deleting old ASG: $ASG"
    aws autoscaling update-auto-scaling-group --auto-scaling-group-name "$ASG" --min-size 0 --max-size 0 --desired-capacity 0
    sleep 10  # allow EC2 instances to terminate
    aws autoscaling delete-auto-scaling-group --auto-scaling-group-name "$ASG" --force-delete
  else
    echo "Skipping current ASG: $ASG"
  fi
done