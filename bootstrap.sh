#!/usr/bin/env bash

# Dotfiles Bootstrap Script
# --------------------------------------
# Sets up tmux, zsh, fzf, sessionizer, and ghostty configs
# --------------------------------------

set -e

DOTFILES_DIR="$HOME/dotfiles"
BIN_DIR="$HOME/.local/bin"

echo "🔧 Bootstrapping your environment..."

# Create local bin if it doesn't exist
mkdir -p "$BIN_DIR"

# Link scripts
echo "🔗 Linking scripts..."
ln -sf "$DOTFILES_DIR/bin/tmux-sessionizer" "$BIN_DIR/tmux-sessionizer"
chmod +x "$BIN_DIR/tmux-sessionizer"

# Link Ghostty config
echo "🔗 Linking Ghostty config..."
mkdir -p "$HOME/.config/ghostty"
ln -sf "$DOTFILES_DIR/config/ghostty/config" "$HOME/.config/ghostty/config"

# Link tmux config
echo "🔗 Linking tmux config..."
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

# Link zsh files
echo "🔗 Linking zsh configuration..."
ln -sf "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/zsh/functions.zsh" "$HOME/.zsh_functions"

# Link ssh config
echo "🔗 Linking SSH config..."
mkdir -p "$HOME/.ssh"
ln -sf "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"

# Install essential packages if possible
echo "📦 Installing packages (if apt available)..."
if command -v apt &>/dev/null; then
  sudo apt update
  sudo apt install -y tmux fzf zoxide fd-find neovim rsync
fi

# Hook zsh functions file if not already sourced
if ! grep -q ".zsh_functions" "$HOME/.zshrc"; then
  echo "source ~/.zsh_functions" >>"$HOME/.zshrc"
fi

echo "✅ Bootstrap complete! Restart your terminal or run 'exec zsh'."
