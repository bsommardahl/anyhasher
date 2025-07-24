#!/bin/bash
set -e

FAILED_VERSION=$1
ROLLBACK_VERSION=$2
ASG_NAME=$3
DESIRED_CAPACITY=$4
ENV_TO_ROLLBACK=$5
TARGET_GROUP_ARN=$6

echo "## 🔄 Rollback Summary" >>$GITHUB_STEP_SUMMARY
echo "- ❌ Deployment failed and rollback was triggered" >>$GITHUB_STEP_SUMMARY
echo "- 🔙 Rolled back from: \`$FAILED_VERSION\`" >>$GITHUB_STEP_SUMMARY
echo "- ✅ Rolled back to: \`$ROLLBACK_VERSION\`" >>$GITHUB_STEP_SUMMARY
echo "- 🏗️ Infrastructure restored successfully" >>$GITHUB_STEP_SUMMARY
echo "" >>$GITHUB_STEP_SUMMARY
echo "### 📊 Rollback Details" >>$GITHUB_STEP_SUMMARY
echo "- **ASG Name**: $ASG_NAME" >>$GITHUB_STEP_SUMMARY
echo "- **Desired Capacity**: $DESIRED_CAPACITY" >>$GITHUB_STEP_SUMMARY
echo "- **Environment rolled back**: $ENV_TO_ROLLBACK" >>$GITHUB_STEP_SUMMARY
echo "- **Target Group**: $TARGET_GROUP_ARN" >>$GITHUB_STEP_SUMMARY

