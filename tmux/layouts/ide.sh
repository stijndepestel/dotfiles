#!/usr/bin/env bash

# Check if there are multiple vertical positions (split horizontally)
unique_tops=$(tmux list-panes -F "#{pane_top}" | sort -u | wc -l)
if [ "$unique_tops" -lt 2 ]; then
  tmux split-window -v -p 20 -c "#{pane_current_path}"
else 
  # Make the top pane take up 80% of the window height.
  total=$(tmux display-message -p "#{window_height}")
  top=$(((total * 75) / 100))
  top_pane=$(tmux list-panes -F "#{pane_id} #{pane_top}" | sort -nk2 | head -n1 | awk '{print $1}')
  tmux resize-pane -t "$top_pane" -y "$top"
fi

