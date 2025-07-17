#!/usr/bin/env bash

set -e

VERSION="$1"
CANARY_PERCENTAGE="$2"
CANARY_DESIRED_CAPACITY="$3"
PRODUCTION_DESIRED_CAPACITY="$4"

cd util/terraform/backend
chmod +x ../../scripts/backend/canary-safe-deploy.sh
../../scripts/backend/canary-safe-deploy.sh "$VERSION" "$CANARY_PERCENTAGE" "$CANARY_DESIRED_CAPACITY" "$PRODUCTION_DESIRED_CAPACITY"

echo "target_group_arn=$(terraform output -raw canary_target_group_arn)" >> "$GITHUB_OUTPUT"
echo "asg_name=$(terraform output -raw canary_asg_name)" >> "$GITHUB_OUTPUT"
echo "previous_canary_version=$(terraform output -raw previous_canary_version)" >> "$GITHUB_OUTPUT"
echo "previous_canary_desired_capacity=$(terraform output -raw previous_canary_desired_capacity)" >> "$GITHUB_OUTPUT"
echo "previous_canary_percentage=$(terraform output -raw previous_canary_percentage)" >> "$GITHUB_OUTPUT"
echo "previous_production_desired_capacity=$(terraform output -raw previous_production_desired_capacity)" >> "$GITHUB_OUTPUT"