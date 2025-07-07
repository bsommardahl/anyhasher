#!/bin/bash
set -e

REF=$1
FRONTEND_URL=$2
BACKEND_URL=$3
BUCKET_NAME=$4

echo "## 🎉 Frontend Deployment Summary" >> $GITHUB_STEP_SUMMARY
echo "- ✅ Frontend infrastructure provisioned successfully" >> $GITHUB_STEP_SUMMARY
echo "- ✅ Artifact deployed to S3 bucket" >> $GITHUB_STEP_SUMMARY
echo "- ✅ Backend URL replaced successfully" >> $GITHUB_STEP_SUMMARY
echo "- ✅ E2E smoke tests passed" >> $GITHUB_STEP_SUMMARY
echo "- ✅ Frontend is live and accessible" >> $GITHUB_STEP_SUMMARY
echo "" >> $GITHUB_STEP_SUMMARY
echo "### 🚀 Frontend Deployment Details" >> $GITHUB_STEP_SUMMARY
echo "- **Version**: \`$REF\`" >> $GITHUB_STEP_SUMMARY
echo "- **Environment**: Production" >> $GITHUB_STEP_SUMMARY
echo "- **Frontend URL**: [$FRONTEND_URL]($FRONTEND_URL)" >> $GITHUB_STEP_SUMMARY
echo "- **Backend URL**: https://$BACKEND_URL" >> $GITHUB_STEP_SUMMARY
echo "- **S3 Bucket**: $BUCKET_NAME" >> $GITHUB_STEP_SUMMARY
echo "- **AWS Region**: us-east-1" >> $GITHUB_STEP_SUMMARY
echo "" >> $GITHUB_STEP_SUMMARY
echo "🎯 **Frontend deployment completed successfully!**" >> $GITHUB_STEP_SUMMARY
echo "" >> $GITHUB_STEP_SUMMARY
echo "### 🔗 Quick Links" >> $GITHUB_STEP_SUMMARY
echo "- [🌐 Visit Frontend]($FRONTEND_URL)" >> $GITHUB_STEP_SUMMARY
echo "- [🔗 Backend API](https://$BACKEND_URL)" >> $GITHUB_STEP_SUMMARY