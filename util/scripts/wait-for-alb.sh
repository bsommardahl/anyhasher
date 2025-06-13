#!/bin/bash
TG_ARN=$1

until aws elbv2 describe-target-health --target-group-arn "$TG_ARN" | grep -q '"State": "healthy"'; do
  echo "Waiting for ALB targets to become healthy..."
  sleep 10
done

echo "✅ ALB targets are healthy."