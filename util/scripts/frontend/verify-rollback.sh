#!/bin/bash
set -e

FRONTEND_URL=$1

if [ -z "$FRONTEND_URL" ]; then
  echo "Error: Frontend URL is required"
  exit 1
fi

echo "🧪 Verifying rollback..."
sleep 30 # Wait for S3 changes to propagate

# Simple HTTP check
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $FRONTEND_URL)

if [ "$HTTP_STATUS" = "200" ]; then
  echo "✅ Rollback verification passed - Frontend is accessible"
else
  echo "❌ Rollback verification failed - HTTP Status: $HTTP_STATUS"
  exit 1
fi

