#!/bin/bash
set -e

VERSION=$1
API_ENDPOINT=${2:-"https://canary-api.anyhasher.io"}

echo "## 🎉 Canary/Rolling Deployment Success" >> $GITHUB_STEP_SUMMARY
echo "- ✅ S3 artifact uploaded and distributed successfully" >> $GITHUB_STEP_SUMMARY
echo "- ✅ Auto Scaling Group rolling deployment completed" >> $GITHUB_STEP_SUMMARY
echo "- ✅ Instances deployed with user_data automation" >> $GITHUB_STEP_SUMMARY
echo "- ✅ Ansible configuration applied successfully" >> $GITHUB_STEP_SUMMARY
echo "- ✅ Health checks passed new instances" >> $GITHUB_STEP_SUMMARY
echo "- ✅ Smoke tests passed" >> $GITHUB_STEP_SUMMARY
echo "" >> $GITHUB_STEP_SUMMARY
echo "### 🚀 Deployment Details" >> $GITHUB_STEP_SUMMARY
echo "- **Deployed Version**: \`$VERSION\`" >> $GITHUB_STEP_SUMMARY
echo "- **Environment**: Production" >> $GITHUB_STEP_SUMMARY
echo "- **API Endpoint**: $API_ENDPOINT" >> $GITHUB_STEP_SUMMARY
echo "- **Deployment Strategy**: Canary/Rolling deployment" >> $GITHUB_STEP_SUMMARY
echo "- **Artifact Source**: S3 bucket with automated retrieval" >> $GITHUB_STEP_SUMMARY
echo "- **Instance Automation**: user_data scripts + Ansible configuration" >> $GITHUB_STEP_SUMMARY
echo "" >> $GITHUB_STEP_SUMMARY
echo "🎯 **Canary/Rolling deployment with Ansible completed successfully!**" >> $GITHUB_STEP_SUMMARY