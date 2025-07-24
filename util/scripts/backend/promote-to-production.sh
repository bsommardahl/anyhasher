#!/bin/bash

set -e

VERSION="$1"
ACTIVE_ENVIRONMENT="$2"
DESIRED_CAPACITY="$3"

if [ -z "$VERSION" ] || [ -z "$ACTIVE_ENVIRONMENT" ]; then
  echo "Error: Missing required parameters"
  echo "Usage: $0 <version> <active_environment>"
  exit 1
fi

if [ "$ACTIVE_ENVIRONMENT" != "blue" ] && [ "$ACTIVE_ENVIRONMENT" != "green" ]; then
  echo "Error: active_environment must be 'blue' or 'green', got: $ACTIVE_ENVIRONMENT"
  exit 1
fi

cd util/terraform/backend

terraform init || echo "Terraform is already initialized."

terraform workspace select decoupled

if [ "$ACTIVE_ENVIRONMENT" = "green" ]; then
  VERSION_VAR="green_version=$VERSION"
  CAPACITY_VAR="green_desired_capacity=$DESIRED_CAPACITY"
else
  VERSION_VAR="blue_version=$VERSION"
  CAPACITY_VAR="blue_desired_capacity=$DESIRED_CAPACITY"
fi

echo "Promoting to production traffic:"
echo "  Active Environment: $ACTIVE_ENVIRONMENT"
echo "  Version: $VERSION"
echo "  Blue Version: $BLUE_VERSION"
echo "  Green Version: $GREEN_VERSION"

terraform apply -auto-approve \
  -var-file="../environments/prod/backend.tfvars" \
  -var="active_environment=$ACTIVE_ENVIRONMENT" \
  -var="$VERSION_VAR" \
  -var="$CAPACITY_VAR"

echo "Traffic successfully switched to $ACTIVE_ENVIRONMENT environment"

