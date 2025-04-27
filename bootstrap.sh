#!/usr/bin/env bash

# Dotfiles Bootstrap Script (nix-first version)
# --------------------------------------

# Detect if this is a development machine
# --------------------------------------------------

IS_DEV_MACHINE=false

# Method 1: Check hostname
case "$(hostname)" in
Nix-Dev | claude-code | home | chat) # <- add any more hostnames you recognize as dev
  IS_DEV_MACHINE=true
  ;;
esac

# Method 2 (Optional): Allow manual override with env var
if [[ "$FORCE_DEV_MACHINE" == "true" ]]; then
  IS_DEV_MACHINE=true
fi

echo "🖥️  Machine type: $([[ $IS_DEV_MACHINE == true ]] && echo 'DEV' || echo 'PROD')"

set -e

DOTFILES_DIR="$HOME/dotfiles"
BIN_DIR="$HOME/.local/bin"

echo "🔧 Bootstrapping your environment..."

# Install Oh My Zsh if missing
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "🔧 Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "✅ Oh My Zsh installed."
else
  echo "✅ Oh My Zsh already present."
fi

# Install Powerlevel10k only on dev machines
if [[ "$IS_DEV_MACHINE" == true ]]; then
  echo "🎨 Installing Powerlevel10k theme..."
  mkdir -p ~/.oh-my-zsh/custom/themes
  if [[ ! -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
    echo "✅ Powerlevel10k installed."
  else
    echo "✅ Powerlevel10k already present."
  fi
else
  echo "⚙️  Skipping Powerlevel10k (non-dev machine)."
fi

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

# SSH config note (manual step now)
echo "ℹ️  Reminder: copy ssh/config.example manually if needed."

# Ensure nix profile is installed correctly
if ! command -v nix &>/dev/null; then
  echo "❌ Error: Nix package manager not found! Install it first."
  exit 1
fi

# Ensure nix profile bin directory is in PATH
if ! echo "$PATH" | grep -q "$HOME/.nix-profile/bin"; then
  echo 'export PATH="$HOME/.nix-profile/bin:$PATH"' >>"$HOME/.zshrc"
  echo "✅ Added nix profile to PATH."
fi

# Final message
echo "✅ Bootstrap complete! Restart your terminal or run 'exec zsh' to refresh."
