#!/bin/bash

set -e

CURRENT_VERSION=$1
ASG_PREFIX="node-api-"

echo "Looking for previous ASG (excluding $ASG_PREFIX$CURRENT_VERSION)..."

PREVIOUS_ASG=$(aws autoscaling describe-auto-scaling-groups \
  --query "AutoScalingGroups[?starts_with(AutoScalingGroupName, \`${ASG_PREFIX}\`) && AutoScalingGroupName != \`${ASG_PREFIX}${CURRENT_VERSION}\`].AutoScalingGroupName" \
  --output text | sort | tail -n 1)

if [[ -z "$PREVIOUS_ASG" ]]; then
  echo "No previous ASG found."
  exit 0
fi

echo "Found previous ASG: $PREVIOUS_ASG"
echo "PREVIOUS_ASG_NAME=$PREVIOUS_ASG" >> "$GITHUB_ENV"