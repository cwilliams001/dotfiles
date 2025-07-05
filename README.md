
# 🚀 Development Environment Setup

This repository contains everything needed to set up a consistent development environment. It uses Ansible to automate the installation and configuration of all tools.

## Quick Start

1.  **Clone this repository:**
    ```bash
    git clone <your-repo-url>
    cd dotfiles
    ```

2.  **Run the setup script:**
    ```bash
    ./setup-remote-dev.sh
    ```
    This script will ensure Ansible is installed and then run the main playbook to set up your environment.

3.  **Restart your shell:**
    ```bash
    exec zsh
    ```

## What Gets Installed

### Core Tools
*   **tmux**: Terminal multiplexer
*   **Neovim**: Modern text editor
*   **fd**: A fast and user-friendly alternative to `find`
*   **fzf**: A command-line fuzzy finder
*   **zoxide**: A smarter `cd` command
*   **Ghostty**: A GPU-accelerated terminal emulator (GUI, best-effort installation)

### Shell Environment
*   **zsh**: As the default shell
*   **Oh My Zsh**: A framework for managing your zsh configuration
*   **Powerlevel10k**: A fast and flexible theme for zsh
*   **zsh-autosuggestions** & **zsh-syntax-highlighting**: Essential plugins for a better shell experience

## How It Works

The setup is orchestrated by Ansible, with the main playbook located at `ansible/setup-dev-tools.yml`. This playbook is the single source of truth for the entire setup.

### Updating Tools

To update a tool, simply change its version number in the `vars` section at the top of `ansible/setup-dev-tools.yml` and re-run the setup script:

```bash
./setup-remote-dev.sh
```

The playbook is idempotent, so it will only change what's necessary.

### Symlinks

The playbook automatically creates symlinks for your configuration files:
- `~/.tmux.conf` → `tmux/tmux.conf`
- `~/.zshrc` → `zsh/zshrc`
- `~/.config/nvim/` → `nvim/`
- `~/.config/ghostty/` → `config/ghostty/`

### Custom Scripts

-   `tmux-sessionizer`: A script for quick project switching in tmux. It's automatically linked to `~/.local/bin/tmux-sessionizer` and added to your `PATH`.

## Directory Structure

```
dotfiles/
├── ansible/
│   └── setup-dev-tools.yml  # The core playbook
├── bin/
│   └── tmux-sessionizer
├── config/
│   └── ghostty/
├── nvim/
├── tmux/
├── zsh/
├── setup-remote-dev.sh      # Main setup script
└── README.md
```
