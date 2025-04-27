
# 🧠 Terminal + Tmux + Remote Ops Cheat Sheet

## Core Daily Commands

| Task                           | Command |
|---------------------------------|---------|
| Open tmux session (project selector) | `<prefix> + F` |
| Switch tmux pane (vim keys)     | `<prefix> + h/j/k/l` |
| Switch tmux pane (Shift Arrows) | `Shift + ArrowKey` |
| Switch tmux window              | `Alt + Left/Right` |
| Search files (fzf)              | `Ctrl+T` |
| Smart cd + edit with Neovim     | `v` |
| Use zoxide manually             | `z <partial_dirname>` |

---

## Remote Workflow

| Task                           | Command |
|---------------------------------|---------|
| SSH + tmux attach               | `ssht <host>` |
| Build remote tmux workspace     | `remote-workspace <host>` |
| Remote file edit (small files)  | `remote-edit <host> <file>` |
| Remote project sync             | `sync-to-remote <host>` |
| Sync zoxide database            | `sync-zoxide <host>` |

---

## Quick Commands to Remember

| Command | Description |
|---------|-------------|
| `bootstrap.sh` | Setup new machine |
| `tmux new-session -s <name>` | Create tmux session manually |
| `tmux kill-session -t <name>` | Kill tmux session |
| `nvim .` | Open Neovim on current dir |
| `zoxide query` | List recent directories |

---

## Important Paths

| Purpose  | Path |
|----------|-----|
| Ghostty Config | `~/.config/ghostty/config` |
| Tmux Config    | `~/.tmux.conf` |
| Zsh Functions  | `~/.zsh_functions` |
| Tmux Sessionizer | `~/.local/bin/tmux-sessionizer` |

---

## SSH Tips (Ghostty)

Always ensure `SetEnv TERM=xterm-256color` is present in your `~/.ssh/config` for servers!  
(Already handled.)

---

# ✨ Key Habits

- Always start tmux first when SSH'ing!
- Favor fuzzy finding (`fzf`) over slow `cd` and `ls`
- Learn `hjkl` pane movements instead of arrows
- Use sessionizer (`<prefix> + F`) to keep your projects fast and tidy
- Remote servers are disposable dev tools — don't over-customize them

