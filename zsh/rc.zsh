export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
export DOTFILES_ID=$(cat $XDG_CONFIG_HOME/.id)
export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"
export DOTFILES_LOCATION="$HOME/.dotfiles"
export PATH=$DOTFILES_LOCATION/bin:$HOME/bin:$HOME/.local/bin:/usr/local/go/bin:$PATH
export BAT_THEME="Visual Studio Dark+"

# Do this early, because other parts may depend on it being done.
if [ -x /opt/homebrew/bin/brew ]
then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

zstyle ':antidote:bundle' use-friendly-names 'yes'
source ${DOTFILES_LOCATION}/antidote/antidote.zsh

antidote load ${DOTFILES_LOCATION}/zsh/confs/defaults.conf

source ${DOTFILES_LOCATION}/cos/zsh/rc.zsh

export ZSH=$(antidote path ohmyzsh/ohmyzsh)

if command -v fnm &> /dev/null
then
  eval "$(fnm env --use-on-cd --version-file-strategy=recursive --corepack-enabled --resolve-engines --shell zsh)"
fi

if [ -d "${HOME}/.pyenv" ]; 
then
  export PYENV_ROOT="${HOME}/.pyenv"
  export PATH="${PATH}:${PYENV_ROOT}/bin"
  eval "$(pyenv init - zsh)"
fi

if command -v direnv &> /dev/null
then
  eval "$(direnv hook zsh)"
fi

if command -v thefuck &> /dev/null
then
  eval $(thefuck --alias)
fi

if command -v fzf &> /dev/null
then
  eval "$(fzf --zsh)" # brew install fzf
  source "$DOTFILES_LOCATION/git/fzf-git.sh"
  # --- setup fzf theme ---
  fg="#CBE0F0"
  bg="#011628"
  bg_highlight="#143652"
  purple="#B388FF"
  blue="#06BCE4"
  cyan="#2CF9ED"

  # export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --color=bg+:#2d3f76 \
  --color=bg:#1e2030 \
  --color=border:#589ed7 \
  --color=fg:#c8d3f5 \
  --color=gutter:#1e2030 \
  --color=header:#ff966c \
  --color=hl+:#65bcff \
  --color=hl:#65bcff \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#65bcff \
  --color=query:#c8d3f5:regular \
  --color=scrollbar:#589ed7 \
  --color=separator:#ff966c \
  --color=spinner:#ff007c \
"

  if command -v fd &> /dev/null
  then
    # -- Use fd instead of fzf -- => brew install fd
    export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

    # Use fd (https://github.com/sharkdp/fd) for listing path candidates.
    # - The first argument to the function ($1) is the base path to start traversal
    # - See the source code (completion.{bash,zsh}) for the details.
    _fzf_compgen_path() {
      fd --hidden --exclude .git . "$1"
    }

    # Use fd to generate the list for directory completion
    _fzf_compgen_dir() {
      fd --type=d --hidden --exclude .git . "$1"
    }
  fi
fi

# Aliases
if command -v nvim &> /dev/null
then
  export EDITOR="nvim"
  alias vim=nvim
else
  export EDITOR="vim"
fi

if command -v bat &> /dev/null
then
  alias cat=bat
fi

if command -v less &> /dev/null
then
  export PAGER='less'
  less_opts=(
    # Quit if entire file fits on first screen.
    -FX
    # Ignore case in searches that do not contain uppercase.
    --ignore-case
    # Allow ANSI colour escapes, but no other escapes.
    --RAW-CONTROL-CHARS
    # Quiet the terminal bell. (when trying to scroll past the end of the buffer)
    --quiet
    # Do not complain when we are on a dumb terminal.
    --dumb
  )
  export LESS="${less_opts[*]}"
fi

if command -v eza &> /dev/null
then
  alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --no-quotes"
  alias ll="eza --long --git --group --all --all --header --color=always --icons=always"
fi

# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

