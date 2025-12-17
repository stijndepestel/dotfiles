#!/bin/bash -e

ROOT_DIRECTORY=${GIT_ROOT_DIRECTORY:-"$HOME/Documents/git"}

if [[ ! -d "$ROOT_DIRECTORY" ]]; then
  echo "Error: Directory '$ROOT_DIRECTORY' not found." >&2
  exit 1
fi

repository=$(find "$ROOT_DIRECTORY" -mindepth 1 -maxdepth 1 -type d | fzf --query="$*" --prompt="> "  --height=40% --reverse -d "/" --nth -1)
if [[ -z "$repository" ]]; then
  exit 0
fi

cd "$repository"

if [[ $(git worktree list | wc -l) -gt 1 ]]; then
  worktree_path=$(git worktree list | grep -v '(bare)' | fzf --height 40% --reverse --prompt="> " | awk '{print $1}')
  if [[ -n "$worktree_path" ]]; then
    echo "$worktree_path"
  fi
else
  echo "$repository"
fi
