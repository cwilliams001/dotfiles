#!/usr/bin/env bash

# ---------------------------------------------------
# Dotfiles Linker Script
# ---------------------------------------------------

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"

echo "🔗 Linking scripts and configs..."

mkdir -p "$BIN_DIR"
ln -sf "$DOTFILES_DIR/bin/tmux-sessionizer" "$BIN_DIR/tmux-sessionizer"
chmod +x "$BIN_DIR/tmux-sessionizer"

mkdir -p "$HOME/.config/ghostty"
ln -sf "$DOTFILES_DIR/config/ghostty/config" "$HOME/.config/ghostty/config"

ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/zsh/functions.zsh" "$HOME/.zsh_functions"

echo "✅ Symlinks updated."
