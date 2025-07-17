#!/bin/bash
# canary-safe-deploy.sh

terraform init || echo "Terraform is already initialized."

terraform workspace select canary

function deploy_canary_safe() {
    local version=$1
    local final_percentage=${2:-10}
    local canary_desired_capacity=${3:-1}
    local production_desired_capacity=${4:-2}
    
    echo "🚀 Deploying canary $version safely..."
    
    local existing_canary_arn=$(get_canary_arn_from_terraform)
    
    if [ -n "$existing_canary_arn" ]; then
        echo "✅ Existing canary deployment found: $existing_canary_arn"
        echo "Proceeding with direct deployment to $final_percentage%..."

        terraform apply \
            -var="ver=$version" \
            -var-file="../environments/prod/backend.tfvars" \
            -var="canary_enabled=true" \
            -var="canary_traffic_percentage=$final_percentage" \
            -var="canary_desired_capacity=$canary_desired_capacity" \
            -var="production_desired_capacity=$production_desired_capacity" \
            -auto-approve
        
        echo "✅ Canary deployment completed successfully!"
    else
        echo "🆕 No existing canary found. Deploying safely..."
        
        echo "Step 1: Creating canary with 0% traffic..."
        terraform apply \
            -var="ver=$version" \
            -var-file="../environments/prod/backend.tfvars" \
            -var="canary_enabled=true" \
            -var="canary_traffic_percentage=0" \
            -var="canary_desired_capacity=$canary_desired_capacity" \
            -var="production_desired_capacity=$production_desired_capacity" \
            -auto-approve
        
        echo "Step 2: Waiting for canary to be healthy..."
        local canary_tg_arn=$(terraform output -raw canary_target_group_arn)
        wait_for_healthy_targets "$canary_tg_arn" 600
        
        echo "Step 3: Activating traffic to $final_percentage%..."
        terraform apply \
            -var="ver=$version" \
            -var-file="../environments/prod/backend.tfvars" \
            -var="canary_enabled=true" \
            -var="canary_traffic_percentage=$final_percentage" \
            -var="canary_desired_capacity=$canary_desired_capacity" \
            -var="production_desired_capacity=$production_desired_capacity" \
            -auto-approve
        
        echo "✅ Canary deployment completed successfully!"
    fi
}

function get_canary_arn_from_terraform() {
    local canary_arn=$(terraform output -raw canary_target_group_arn 2>/dev/null)
    
    if [ -n "$canary_arn" ] && [ "$canary_arn" != "null" ] && [ "$canary_arn" != "" ]; then
        echo "$canary_arn"
        return 0
    fi
    
    return 1
}

function wait_for_healthy_targets() {
    local target_group_arn=$1
    local max_wait=${2:-600}
    
    echo "⏳ Waiting for healthy targets in $target_group_arn..."
    
    local wait_time=0
    while [ $wait_time -lt $max_wait ]; do
        local healthy_count=$(aws elbv2 describe-target-health \
            --target-group-arn "$target_group_arn" \
            --query 'TargetHealthDescriptions[?TargetHealth.State==`healthy`]' \
            --output json | jq length)
        
        local total_count=$(aws elbv2 describe-target-health \
            --target-group-arn "$target_group_arn" \
            --query 'TargetHealthDescriptions' \
            --output json | jq length)
        
        echo "Health check: $healthy_count/$total_count targets healthy"
        
        if [ "$healthy_count" -gt 0 ]; then
            echo "✅ At least 1 target is healthy! Proceeding..."
            return 0
        fi
        
        sleep 15
        wait_time=$((wait_time + 15))
    done
    
    echo "❌ Timeout waiting for healthy targets"
    return 1
}

deploy_canary_safe "$1" "$2" "$3" "$4"