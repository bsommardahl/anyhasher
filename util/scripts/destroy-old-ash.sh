#!/bin/bash
OLD_ASG_NAME=$1

if [[ -z "$OLD_ASG_NAME" ]]; then
  echo "⚠️ No previous ASG name provided. Skipping destroy."
  exit 0
fi

echo "Draining and deleting old ASG: $OLD_ASG_NAME"

aws autoscaling update-auto-scaling-group \
  --auto-scaling-group-name "$OLD_ASG_NAME" \
  --desired-capacity 0

sleep 30

aws autoscaling delete-auto-scaling-group \
  --auto-scaling-group-name "$OLD_ASG_NAME" \
  --force-delete

echo "🧹 Old ASG $OLD_ASG_NAME has been deleted."