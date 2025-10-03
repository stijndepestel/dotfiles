# Display time
SPACESHIP_TIME_SHOW=true
SPACESHIP_EXEC_TIME_ELAPSED=0
SPACESHIP_EXEC_TIME_PRECISION=2

SPACESHIP_PROMPT_ORDER=(
  battery        # Battery level and status
  dir            # Current directory section
  host           # Hostname section
  git            # Git section (git_branch + git_status)
  node           # Node.js section
  python         # Python section
  docker         # Docker section
  docker_compose # Docker section
  async          # Async jobs indicator
  line_sep       # Line break
  sudo           # Sudo indicator
  char           # Prompt character
)

SPACESHIP_RPROMPT_ORDER=(
  jobs           # Background jobs indicator
  aws            # Amazon Web Services section
  exit_code      # Exit code section
  exec_time      # Execution time
  user
  time  # time stamp
)

# SPACESHIP_AWS_SYMBOL='\uf0ef' # Doesn't really work look into later
SPACESHIP_BATTERY_THRESHOLD=75
SPACESHIP_DIR_TRUNC_REPO=false

SPACESHIP_EXIT_CODE_SHOW=true
SPACESHIP_GIT_STATUS_COLOR=green
SPACESHIP_PROMPT_SYMBOL='XX'
SPACESHIP_CHAR_SYMBOL='❯ ' # "\uf460"  # '❯' # nothing witht these symbol characters work... Needs some research
SPACESHIP_CHAR_SYMBOL_ROOT='#'

SPACESHIP_TIME_COLOR='#767676'
SPACESHIP_TIME_SYMBOL='XX'
