#!/bin/bash
TG_ARN=$1
VERSION=$2
MAX_ATTEMPTS=30
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  ATTEMPT=$((ATTEMPT + 1))

  # Get healthy instances from ALB and check if they have the correct version tag
  HEALTHY_INSTANCES=$(aws elbv2 describe-target-health --target-group-arn "$TG_ARN" \
    --query 'TargetHealthDescriptions[?TargetHealth.State==`healthy`].Target.Id' --output text)

  for instance_id in $HEALTHY_INSTANCES; do
    INSTANCE_VERSION=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$instance_id" "Name=key,Values=Version" \
      --query 'Tags[0].Value' --output text)

    if [ "$INSTANCE_VERSION" = "$VERSION" ]; then
      echo "✅ Found healthy instance with Version=$VERSION"
      exit 0
    fi
  done

  echo "Waiting for healthy targets with Version=$VERSION... (attempt $ATTEMPT/$MAX_ATTEMPTS)"
  sleep 10
done

echo "❌ Timeout: No healthy targets with Version=$VERSION found"
exit 1
