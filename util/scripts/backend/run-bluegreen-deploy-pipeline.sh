#!/bin/bash

set -e

VERSION="$1"
DESIRED_CAPACITY="$2"
USE_GREEN_ENVIRONMENT="$3"

cd util/terraform/backend

terraform init || echo "Terraform is already initialized."

terraform workspace select decoupled

echo "Use green environment: $USE_GREEN_ENVIRONMENT"

if [ "$USE_GREEN_ENVIRONMENT" = "true" ]; then
  VERSION_VAR="green_version=$VERSION"
  BLUE_CAPACITY=$(terraform output -raw blue_desired_capacity) || BLUE_CAPACITY="2"

  terraform apply -auto-approve \
    -var-file="../environments/prod/backend.tfvars" \
    -var="use_green_environment=true" \
    -var="$VERSION_VAR" \
    -var="blue_desired_capacity=$BLUE_CAPACITY"
else
  VERSION_VAR="blue_version=$VERSION"
  CAPACITY_VAR="blue_desired_capacity=$DESIRED_CAPACITY"

  terraform apply -auto-approve \
    -var-file="../environments/prod/backend.tfvars" \
    -var="$VERSION_VAR" \
    -var="$CAPACITY_VAR"
fi

echo "Deployment completed successfully"

if [ "$USE_GREEN_ENVIRONMENT" = "true" ]; then
  echo "previous_desired_capacity=$(terraform output -raw previous_blue_desired_capacity)" >>"$GITHUB_OUTPUT"
  echo "target_group_arn=$(terraform output -raw green_target_group_arn)" >>"$GITHUB_OUTPUT"
  echo "asg_name=$(terraform output -raw green_asg_name)" >>"$GITHUB_OUTPUT"
  echo "previous_version=$(terraform output -raw previous_blue_version)" >>"$GITHUB_OUTPUT"
else
  echo "previous_desired_capacity=$(terraform output -raw previous_blue_desired_capacity)" >>"$GITHUB_OUTPUT"
  echo "target_group_arn=$(terraform output -raw blue_target_group_arn)" >>"$GITHUB_OUTPUT"
  echo "asg_name=$(terraform output -raw blue_asg_name)" >>"$GITHUB_OUTPUT"
  echo "previous_version=$(terraform output -raw previous_blue_version)" >>"$GITHUB_OUTPUT"
fi
