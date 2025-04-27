
# 🚀 Dotfiles — Terminal + Development Workflow

## Overview

This repository contains my modular setup for:

- Terminal work using **Ghostty**
- Multiplexed sessions using **tmux**
- Fast file finding with **fd** and **fzf**
- Smarter navigation using **zoxide**
- Code editing with **Neovim**
- Automated remote workflows using **tmux-sessionizer** and custom functions

The goal is to create a **fast**, **repeatable**, and **sane** environment for both local and remote development.

---

## 📦 Included Tools

| Tool      | Purpose                   |
|-----------|----------------------------|
| Ghostty   | Terminal emulator           |
| Tmux      | Persistent terminal sessions |
| fzf       | Fuzzy finder                |
| fd        | Simple, fast file finding   |
| zoxide    | Smarter cd (jump directories) |
| Neovim    | Modern text editor          |

---

## ⚡ Installation

After cloning:

```bash
cd ~/dotfiles
./bootstrap.sh
```

This will:

- Symlink configs into place
- Install necessary tools (if using apt)
- Set up zsh functions and tmux keybindings
- Configure SSH for Ghostty compatibility

---

### SSH Config Note

This repo provides an `ssh/config.example` file.  
Please copy it manually:

```bash
cp ssh/config.example ssh/config
```
---

## 🧠 Core Workflows

### Local Development

| Task                    | Command / Keybind        |
|--------------------------|---------------------------|
| Start new tmux session    | `<prefix> + F` (sessionizer) |
| Move between panes (vim keys) | `<prefix> + h/j/k/l` |
| Find files (fzf)          | `Ctrl+T`                  |
| Smart jump to dir + edit  | `v`                       |

### Remote Development

| Task                    | Command / Keybind        |
|--------------------------|---------------------------|
| SSH with auto-tmux attach | `ssht <host>`             |
| Remote workspace         | `remote-workspace <host>` |
| Remote edit file         | `remote-edit <host> <file>` |
| Sync project to remote   | `sync-to-remote <host>`   |

---

## 🛠 Future Improvements

- (Optional) Migrate tool installation to **Nix** for freshest versions
- Add a lightweight `shell.nix` for remote servers
- Expand Ansible playbook for server bootstrap

---

## 📂 Directory Structure


```bash
dotfiles/
├── ansible/
│   └── setup-dev-tools.yml
├── bin/
│   └── tmux-sessionizer
├── config/
│   └── ghostty/
│       └── config
├── tmux/
│   └── tmux.conf
├── zsh/
│   ├── functions.zsh
│   └── zshrc
├── ssh/
│   └── config
├── bootstrap.sh
└── README.md
```
