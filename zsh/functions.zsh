# ~/.zsh_functions

# -------------------------------------------------
# FZF configuration
# -------------------------------------------------
export FZF_DEFAULT_COMMAND='fdfind --type file --hidden --follow --exclude .git --exclude node_modules'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fdfind --type directory --hidden --follow --exclude .git --exclude node_modules'
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border --inline-info"

# -------------------------------------------------
# Tmux sessionizer environment
# -------------------------------------------------
export TMUX_SESSIONIZER_DIRS="$HOME/github_repos $HOME/dotfiles $HOME/Downloads $HOME/Desktop"
export REMOTE_HOSTS="nix-dev claude-code"
export MAX_DEPTH=3
export INCLUDE_HIDDEN=false

# -------------------------------------------------
# Functions
# -------------------------------------------------

# SSH into a server and automatically attach/start tmux
function ssht() {
  local host="$1"
  local session="${2:-main}"
  shift 1
  if [[ -n "$2" ]]; then
    shift 1
  fi
  ssh -t "$host" "tmux new-session -A -s $session $*"
}

# Smart Vim function
function v() {
  if [[ $# -eq 0 ]]; then
    local dir
    dir=$(fd --type directory --max-depth "$MAX_DEPTH" | fzf --height 40% --reverse --prompt="Navigate to directory> ")
    if [[ -n "$dir" ]]; then
      cd "$dir" || return
      nvim
    fi
  elif [[ -d "$1" ]]; then
    cd "$1" || return
    nvim
  else
    nvim "$@"
  fi
}

# Zoxide + tmux integration
function z-tmux() {
  local dir
  dir=$(zoxide query -l | fzf --height 40% --reverse --prompt="zoxide directories> ")
  if [[ -n "$dir" ]]; then
    session_name=$(basename "$dir" | tr '. ' '_')

    if ! tmux has-session -t "$session_name" 2>/dev/null; then
      tmux new-session -d -s "$session_name" -c "$dir"
    fi

    if [[ -z "$TMUX" ]]; then
      tmux attach -t "$session_name"
    else
      tmux switch-client -t "$session_name"
    fi
  fi
}

# Bind Alt+z to quick zoxide -> tmux
bindkey -s '^[z' 'z-tmux\n'

# Remote file syncing
function sync-to-remote() {
  local remote="$1"
  local remote_dir="${2:-~/projects/$(basename "$PWD")}"

  if [[ -z "$remote" ]]; then
    echo "Usage: sync-to-remote <remote-host> [remote-directory]"
    return 1
  fi

  ssh "$remote" "mkdir -p $remote_dir"
  rsync -avz --progress --exclude '.git/' --exclude 'node_modules/' --exclude 'target/' \
    --exclude 'dist/' --exclude 'build/' --exclude '.cache/' \
    ./ "$remote:$remote_dir/"

  echo "Synced $(basename "$PWD") to $remote:$remote_dir/"
}

# Remote file editing
function remote-edit() {
  local remote="$1"
  local file="$2"

  if [[ -z "$remote" || -z "$file" ]]; then
    echo "Usage: remote-edit <remote-host> <file-path>"
    return 1
  fi

  local size
  size=$(ssh "$remote" "stat -c %s $file 2>/dev/null || echo 0")

  if [[ "$size" -gt 1048576 ]]; then
    nvim "scp://$remote/$file"
  else
    local tmp_file
    tmp_file=$(mktemp)
    ssh "$remote" "cat $file" > "$tmp_file"

    nvim "$tmp_file"

    echo -n "Upload changes to $remote:$file? [y/N] "
    read -r upload

    if [[ "$upload" =~ ^[Yy]$ ]]; then
      cat "$tmp_file" | ssh "$remote" "cat > $file"
      echo "Changes uploaded."
    else
      echo "No changes were uploaded. Local copy at $tmp_file"
    fi
  fi
}

# Remote tmux workspace builder
function remote-workspace() {
  local host="$1"
  local dir="${2:-~/}"

  if [[ -z "$host" ]]; then
    echo "Usage: remote-workspace <remote-host> [directory]"
    return 1
  fi

  local session_name="remote_${host}"

  if ! tmux has-session -t "$session_name" 2>/dev/null; then
    tmux new-session -d -s "$session_name" -n "ssh" "ssh -t $host \"cd $dir && bash\""
    sleep 1
    tmux new-window -t "$session_name" -n "edit" "ssh -t $host \"cd $dir && nvim\""
    tmux new-window -t "$session_name" -n "monitor" "ssh -t $host \"cd $dir && htop\""
    tmux select-window -t "$session_name:1"
  fi

  if [[ -z "$TMUX" ]]; then
    tmux attach-session -t "$session_name"
  else
    tmux switch-client -t "$session_name"
  fi
}

# Local zoxide database sync to remote
function sync-zoxide() {
  local remote="$1"

  if [[ -z "$remote" ]]; then
    echo "Usage: sync-zoxide <remote-host>"
    return 1
  fi

  local zoxide_db="$HOME/.local/share/zoxide/db.zo"

  if [[ -f "$zoxide_db" ]]; then
    scp "$zoxide_db" "$remote:.local/share/zoxide/db.zo"
    echo "Synced zoxide database to $remote"
  else
    echo "Local zoxide database not found at $zoxide_db"
  fi
}


