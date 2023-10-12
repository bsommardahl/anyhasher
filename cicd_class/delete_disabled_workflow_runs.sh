# This script will delete all the workflow runs for any "disabled" workflows in the repo. 
# Useful before a class to clean things up. 

# NOTE: Remember to "chmod +x" this file.

OWNER=bsommardahl
REPOSITORY=anyhasher

# Get workflow IDs with status "disabled_manually"
workflow_ids=($(gh api repos/$OWNER/$REPOSITORY/actions/workflows --paginate | jq '.workflows[] | select(.["state"] | contains("disabled_manually")) | .id'))

for workflow_id in "${workflow_ids[@]}"
do
  echo "Listing runs for the workflow ID $workflow_id"
  run_ids=( $(gh api repos/$OWNER/$REPOSITORY/actions/workflows/$workflow_id/runs --paginate | jq '.workflow_runs[].id') )
  for run_id in "${run_ids[@]}"
  do
    echo "Deleting Run ID $run_id"
    gh api repos/$OWNER/$REPOSITORY/actions/runs/$run_id -X DELETE >/dev/null
  done
done