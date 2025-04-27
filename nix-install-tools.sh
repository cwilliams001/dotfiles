#!/usr/bin/env bash

# Install Dev Tools via Nix Profile
# --------------------------------------

set -e

echo "🚀 Installing development tools using nix profile..."

# List of tools you want to install
nix profile install \
  nixpkgs#zsh \
  nixpkgs#tmux \
  nixpkgs#neovim \
  nixpkgs#fd \
  nixpkgs#fzf \
  nixpkgs#zoxide \
  nixpkgs#meslo-lgs-nf

echo "✅ Installation complete!"

echo "ℹ️  Reminder: make sure your PATH includes ~/.nix-profile/bin if it doesn't already."
