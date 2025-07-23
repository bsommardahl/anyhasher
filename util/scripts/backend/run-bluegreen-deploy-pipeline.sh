#!/bin/bash

set -e

VERSION="$1"
DESIRED_CAPACITY="$2"
ACTIVE_ENVIRONMENT="$3"

cd util/terraform/backend

terraform init || echo "Terraform is already initialized."

terraform workspace select decoupled

# Get current active environment from terraform output
CURRENT_ACTIVE_ENV=$(terraform output -raw active_environment 2>/dev/null || echo "blue")
echo "Current active environment: $CURRENT_ACTIVE_ENV"
echo "Target environment: $ACTIVE_ENVIRONMENT"

if [ "$ACTIVE_ENVIRONMENT" = "green" ]; then
  VERSION_VAR="green_version=$VERSION"
  CAPACITY_VAR="green_desired_capacity=$DESIRED_CAPACITY"
else
  VERSION_VAR="blue_version=$VERSION"
  CAPACITY_VAR="blue_desired_capacity=$DESIRED_CAPACITY"
fi

echo "Deploying to $ACTIVE_ENVIRONMENT environment with version $VERSION and capacity $DESIRED_CAPACITY"

terraform apply -auto-approve \
  -var-file="../environments/prod/backend.tfvars" \
  -var="active_environment=$CURRENT_ACTIVE_ENV" \
  -var="$VERSION_VAR" \
  -var="$CAPACITY_VAR"

echo "Deployment completed successfully"

if [ "$ACTIVE_ENVIRONMENT" = "green" ]; then
  echo "previous_desired_capacity=$(terraform output -raw previous_green_desired_capacity)" >>"$GITHUB_OUTPUT"
  echo "target_group_arn=$(terraform output -raw green_target_group_arn)" >>"$GITHUB_OUTPUT"
  echo "asg_name=$(terraform output -raw green_asg_name)" >>"$GITHUB_OUTPUT"
  echo "previous_version=$(terraform output -raw previous_green_version)" >>"$GITHUB_OUTPUT"
else
  echo "previous_desired_capacity=$(terraform output -raw previous_blue_desired_capacity)" >>"$GITHUB_OUTPUT"
  echo "target_group_arn=$(terraform output -raw blue_target_group_arn)" >>"$GITHUB_OUTPUT"
  echo "asg_name=$(terraform output -raw blue_asg_name)" >>"$GITHUB_OUTPUT"
  echo "previous_version=$(terraform output -raw previous_blue_version)" >>"$GITHUB_OUTPUT"
fi
