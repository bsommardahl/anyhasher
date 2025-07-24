#!/bin/bash
set -e

REF=$1
FRONTEND_URL=$2

echo "## 🔄 Frontend Rollback Summary" >>$GITHUB_STEP_SUMMARY
echo "- ❌ Deployment of version \`$REF\` failed" >>$GITHUB_STEP_SUMMARY
echo "- ✅ Automatic rollback to previous version completed" >>$GITHUB_STEP_SUMMARY
echo "- ✅ Frontend restored to stable state" >>$GITHUB_STEP_SUMMARY
echo "" >>$GITHUB_STEP_SUMMARY
echo "### 🔄 Rollback Details" >>$GITHUB_STEP_SUMMARY
echo "- **Failed Version**: \`$REF\`" >>$GITHUB_STEP_SUMMARY
echo "- **Rollback Method**: S3 Sync from backup" >>$GITHUB_STEP_SUMMARY
echo "- **Frontend URL**: [$FRONTEND_URL]($FRONTEND_URL)" >>$GITHUB_STEP_SUMMARY
echo "" >>$GITHUB_STEP_SUMMARY
echo "🔍 **Please check the logs and fix the issues before redeploying.**" >>$GITHUB_STEP_SUMMARY

