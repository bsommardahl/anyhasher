#!/bin/bash
TG_ARN=$1
MAX_ATTEMPTS=30 # 5 minutes (30 attempts * 10 seconds)
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  ATTEMPT=$((ATTEMPT + 1))

  if aws elbv2 describe-target-health --target-group-arn "$TG_ARN" | grep -q '"State": "healthy"'; then
    echo "✅ ALB targets are healthy."
    exit 0
  fi

  echo "Waiting for ALB targets to become healthy... (attempt $ATTEMPT/$MAX_ATTEMPTS)"
  sleep 10
done

echo "❌ Timeout: ALB targets did not become healthy within 5 minutes"
exit

