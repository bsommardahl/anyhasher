#!/bin/bash
set -e

VERSION=$1
API_ENDPOINT=${2:-"https://api.anyhasher.io"}

echo "## 🎉 Deployment Summary" >> $GITHUB_STEP_SUMMARY
echo "- ✅ Infrastructure provisioned successfully" >> $GITHUB_STEP_SUMMARY
echo "- ✅ Backend configured with Ansible" >> $GITHUB_STEP_SUMMARY
echo "- ✅ Health checks passed" >> $GITHUB_STEP_SUMMARY
echo "- ✅ Rolling deployment completed" >> $GITHUB_STEP_SUMMARY
echo "- ✅ Smoke tests passed" >> $GITHUB_STEP_SUMMARY
echo "" >> $GITHUB_STEP_SUMMARY
echo "### 🚀 Deployment Details" >> $GITHUB_STEP_SUMMARY
echo "- **New Version**: \`$VERSION\`" >> $GITHUB_STEP_SUMMARY
echo "- **Environment**: Production" >> $GITHUB_STEP_SUMMARY
echo "- **API Endpoint**: $API_ENDPOINT" >> $GITHUB_STEP_SUMMARY
echo "- **Deployment Type**: Rolling Deployment" >> $GITHUB_STEP_SUMMARY
echo "" >> $GITHUB_STEP_SUMMARY
echo "🎯 **Deployment completed successfully!**" >> $GITHUB_STEP_SUMMARY