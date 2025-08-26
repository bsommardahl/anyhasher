#!/bin/bash

# Default values
REF="canary-deployment"
CANARY="true"
DESIRED_PRODUCTION_CAPACITY="2"
USE_CURRENT_COMMIT="true"
CUSTOM_VERSION=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --canary)
      CANARY="$2"
      shift 2
      ;;
    --desired_production_capacity)
      DESIRED_PRODUCTION_CAPACITY="$2"
      shift 2
      ;;
    --use_current_commit)
      USE_CURRENT_COMMIT="$2"
      shift 2
      ;;
    --custom_version)
      CUSTOM_VERSION="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [OPTIONS]"
      echo "Options:"
      echo "  --canary BOOLEAN                   Set canary flag (default: true)"
      echo "  --desired_production_capacity NUM  Set production capacity (default: 2)"
      echo "  --use_current_commit BOOLEAN       Use current commit (default: true)"
      echo "  --custom_version VERSION           Custom version (only if use_current_commit=false)"
      echo "  -h, --help                         Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

# Build the command
if [[ -n "$CUSTOM_VERSION" && "$USE_CURRENT_COMMIT" == "false" ]]; then
  # Execute with custom version
  gh workflow run promote-canary.yml \
    --ref "$REF" \
    --field canary="$CANARY" \
    --field desired_production_capacity="$DESIRED_PRODUCTION_CAPACITY" \
    --field use_current_commit="$USE_CURRENT_COMMIT" \
    --field custom_version="$CUSTOM_VERSION"
else
  # Execute without custom version
  gh workflow run promote-canary.yml \
    --ref "$REF" \
    --field canary="$CANARY" \
    --field desired_production_capacity="$DESIRED_PRODUCTION_CAPACITY" \
    --field use_current_commit="$USE_CURRENT_COMMIT"
fi