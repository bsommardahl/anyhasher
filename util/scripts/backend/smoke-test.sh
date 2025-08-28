#!/bin/bash
BASE_URL=$1
USE_GREEN_ENVIRONMENT=$2

echo "🔍 Testing health endpoint availability..."

if [ "$USE_GREEN_ENVIRONMENT" = "true" ]; then
  echo "Using green environment (X-Environment: green header)"
  response=$(curl -s -o /dev/null -w "%{http_code}" -H "X-Environment: green" "$BASE_URL/health" || echo "000")
else
  echo "Using default environment (no X-Environment header)"
  response=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/health" || echo "000")
fi

if [ "$response" = "400" ]; then
  echo "✅ Application is responding correctly!"
else
  echo "❌ Application is not responding (HTTP $response)"
  exit 1
fi
