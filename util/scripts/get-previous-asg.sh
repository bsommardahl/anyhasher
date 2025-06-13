#!/bin/bash
set -e

ENVIRONMENT=$1
CURRENT_VERSION=$2

if [[ -z "$ENVIRONMENT" || -z "$CURRENT_VERSION" ]]; then
  echo "Usage: $0 <environment> <current_version>"
  exit 1
fi

echo "Looking for previous ASG in environment: $ENVIRONMENT (excluding version: $CURRENT_VERSION)"

aws autoscaling describe-auto-scaling-groups \
  --query "AutoScalingGroups[?starts_with(AutoScalingGroupName, \`${ENVIRONMENT}-anyhasher-\`)]" \
  --output json |
jq -r ".[] | select(.AutoScalingGroupName != \"${ENVIRONMENT}-anyhasher-${CURRENT_VERSION}\") | {name: .AutoScalingGroupName, created: .CreatedTime}" |
jq -s 'sort_by(.created) | reverse | .[0].name'