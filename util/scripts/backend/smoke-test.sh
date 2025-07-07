#!/bin/bash
BASE_URL=$1

echo "🔍 Testing health endpoint availability..."

response=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/health" || echo "000")
if [ "$response" = "200" ]; then
  echo "✅ Application is responding correctly!"
else
  echo "❌ Application is not responding (HTTP $response)"
  exit 1
fi

