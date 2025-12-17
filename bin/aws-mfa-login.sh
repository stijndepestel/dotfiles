#!/usr/bin/env bash
set -euo pipefail

# --- Dependencies check ---
for cmd in aws jq fzf; do
  command -v $cmd >/dev/null 2>&1 || {
    echo "Missing required command: $cmd" >&2
    exit 1
  }
done

force=false
while getopts "f" flag; do
  case ${flag} in
  f) force=true ;;
  *)
    echo "Unknown flag" >&2
    exit 1
    ;;
  esac
done

get_base_profile() {
  IFS=',' read -r -a EXCLUDE <<< "${AWS_MFA_LOGIN_EXCLUDE:-}"
  mapfile -t PROFILES < <(aws configure list-profiles | awk '!/-mfa$/' | grep -v -x -F -f <(printf "%s\n" "${EXCLUDE[@]}"))
  if [ ${#PROFILES[@]} -eq 0 ]; then
    echo "No AWS profiles found" >&2
    exit 1
  elif [ ${#PROFILES[@]} -eq 1 ]; then
    echo "${PROFILES[0]}"
  else
    printf '%s\n' "${PROFILES[@]}" | fzf --prompt="Select base profile: "
  fi
}

reuse_existing_session() {
  local profile_mfa="$1"
  if [ "$force" = true ]; then
    return 1
  fi

  local expiration
  expiration=$(aws configure get expiration --profile "$profile_mfa" 2>/dev/null || true)
  if [ -z "$expiration" ]; then
    return 1
  fi

  local exp_ts now_ts secs_left
  exp_ts=$(jq -nr --arg d "$expiration" '
    ($d
     | gsub("\\.\\d+"; "")
     | sub("Z$"; "+0000")
     | gsub("(?<=[+-]\\d{2}):(?=\\d{2}$)"; "")
     | strptime("%Y-%m-%dT%H:%M:%S%z")
     | mktime)
  ')
  now_ts=$(date +%s)
  secs_left=$((exp_ts - now_ts))

  [ $secs_left -gt 3600 ]
}

create_new_session() {
  local profile_base="$1"
  local profile_mfa="$2"
  # Assumption: There is only one MFA device so the first MFA device will be used.
  local mfa_arn token_code creds
  mfa_arn=$(aws iam list-mfa-devices \
    --profile "$profile_base" \
    --query "MFADevices[0].SerialNumber" \
    --output text 2>/dev/null || true)

  if [[ -z "$mfa_arn" || "$mfa_arn" == "None" ]]; then
    echo "No MFA device found for profile '$profile_base'." >&2
    exit 1
  fi

  read -p "Enter MFA code for $profile_base: " token_code

  creds=$(aws sts get-session-token \
    --serial-number "$mfa_arn" \
    --token-code "$token_code" \
    --profile "$profile_base" \
    --output json)

  aws configure set aws_access_key_id "$(jq -r .Credentials.AccessKeyId <<<"$creds")" --profile "$profile_mfa"
  aws configure set aws_secret_access_key "$(jq -r .Credentials.SecretAccessKey <<<"$creds")" --profile "$profile_mfa"
  aws configure set aws_session_token "$(jq -r .Credentials.SessionToken <<<"$creds")" --profile "$profile_mfa"
  aws configure set region "eu-west-1" --profile "$profile_mfa"
  aws configure set expiration "$(jq -r .Credentials.Expiration <<<"$creds")" --profile "$profile_mfa"
}

main() {
  local profile_base profile_mfa
  profile_base=$(get_base_profile)
  profile_mfa="${profile_base}-mfa"

  if aws configure list-profiles | grep -q -Fx "$profile_mfa"; then
    if reuse_existing_session "$profile_mfa"; then
      echo "$profile_mfa"
      return
    fi
  fi

  create_new_session "$profile_base" "$profile_mfa"
  echo "$profile_mfa"
}

main
