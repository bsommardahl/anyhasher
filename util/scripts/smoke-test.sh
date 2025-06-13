#!/bin/bash
BASE_URL=$1
VERSION=$2

set -e

echo "Running smoke tests against $BASE_URL..."

curl -f "$BASE_URL/health"
echo "✔️ /health check passed"

curl -f "$BASE_URL/api/version" | grep "$VERSION"
echo "✔️ /api/version check passed (version = $VERSION)"

echo "✅ All smoke tests passed."