#!/bin/bash -e

GIT_ROOT="$HOME/Documents/git"

if [[ ! -d "$GIT_ROOT" ]]; then
  echo "Error: Directory '$GIT_ROOT' not found." >&2
  exit 1
fi

repository=$(find "$GIT_ROOT" -mindepth 1 -maxdepth 1 -type d | fzf --prompt="Filter > " --height=40% --reverse)
if [[ -z "$repository" ]]; then
  exit 0
fi

cd "$repository"

if [[ $(git worktree list | wc -l) -gt 1 ]]; then
  worktree_path=$(git worktree list | grep -v '(bare)' | fzf --height 40% --reverse --prompt="Filter > " | awk '{print $1}')
  if [[ -n "$worktree_path" ]]; then
    echo "$worktree_path"
  fi
else
  echo "$repository"
fi
