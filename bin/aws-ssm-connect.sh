#!/usr/bin/env bash

#
# aws-ssm-connect.sh
#
# Interactively select a running, SSM-managed EC2 instance using fzf
# and connect to it with AWS SSM Session Manager.
#
# Prerequisites: aws-cli, fzf, jq, session-manager-plugin
#

command -v aws >/dev/null 2>&1 || {
  echo >&2 "Error: AWS CLI is not installed. Aborting."
  exit 1
}
command -v fzf >/dev/null 2>&1 || {
  echo >&2 "Error: fzf is not installed. Aborting."
  exit 1
}
command -v jq >/dev/null 2>&1 || {
  echo >&2 "Error: jq is not installed. Aborting."
  exit 1
}

ssm_managed_ids=$(aws ssm describe-instance-information \
  --filters "Key=PingStatus,Values=Online" \
  --query "InstanceInformationList[*].InstanceId" \
  --output text | tr '\t' ' ')

if [[ -z "$ssm_managed_ids" ]]; then
  echo "No SSM instance found"
  exit 0
fi

instances_list=$(aws ec2 describe-instances \
  --instance-ids $ssm_managed_ids \
  --filters "Name=instance-state-name,Values=running" \
  --query 'Reservations[].Instances[].{ID:InstanceId, Name: (Tags[?Key==`Name`].Value | [0])}' \
  --output json | jq -r '.[] | "\(.ID)\t\(.Name // "N/A")"')

if [[ -z "$instances_list" ]]; then
  echo "No running SSM instance found"
  exit 0
fi

selected_instance=$(echo -e "$instances_list" | fzf \
  --header "Select an EC2 instance to connect via SSM" \
  --height="50%" --layout=reverse \
  --preview 'aws ec2 describe-instances --instance-id {1} --output json | jq -r ".Reservations[0].Instances[0] |
    \"ID:         \(.InstanceId)
    Name:       \(.Tags[]? | select(.Key==\"Name\").Value // \"N/A\")
    Type:       \(.InstanceType)
    State:      \(.State.Name)
    Private IP: \(.PrivateIpAddress)
    Public IP:  \(.PublicIpAddress // \"N/A\")
    Launch:     \(.LaunchTime)\""' \
  --preview-window=right,60%,border-left)

if [[ -n "$selected_instance" ]]; then
  instance_id=$(echo "$selected_instance" | awk '{print $1}')
  aws ssm start-session --target "$instance_id"
fi
