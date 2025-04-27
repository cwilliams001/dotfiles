#!/usr/bin/env bash

# ---------------------------------------------------
# Dotfiles Bootstrap Script
# (Nix-first, Dev-aware, Fully Automatic)
# ---------------------------------------------------

set -e

DOTFILES_DIR="$HOME/dotfiles"
BIN_DIR="$HOME/.local/bin"

echo "🔧 Bootstrapping your environment..."

# ---------------------------------------------------
# Detect DEV or PROD Machine
# ---------------------------------------------------

IS_DEV_MACHINE=false

case "$(hostname)" in
nix-dev | claude-code | home | chat)
  IS_DEV_MACHINE=true
  ;;
esac

# Allow manual override
if [[ "$FORCE_DEV_MACHINE" == "true" ]]; then
  IS_DEV_MACHINE=true
fi

echo "🖥️  Machine type: $([[ $IS_DEV_MACHINE == true ]] && echo 'DEV' || echo 'PROD')"

# ---------------------------------------------------
# Install Oh My Zsh if missing
# ---------------------------------------------------

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "🎩 Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "✅ Oh My Zsh installed."
else
  echo "✅ Oh My Zsh already present."
fi

# ---------------------------------------------------
# Create ~/.zshenv for correct nix PATH everywhere
# ---------------------------------------------------

if ! grep -q ".nix-profile" "$HOME/.zshenv" 2>/dev/null; then
  echo "📦 Setting up ~/.zshenv for nix profile PATH..."
  echo 'export PATH="$HOME/.nix-profile/bin:$PATH"' >>"$HOME/.zshenv"
  echo "✅ ~/.zshenv updated."
fi

# ---------------------------------------------------
# Install Powerlevel10k if DEV machine
# ---------------------------------------------------

if [[ "$IS_DEV_MACHINE" == true ]]; then
  echo "🎨 Installing Powerlevel10k theme..."
  mkdir -p "$HOME/.oh-my-zsh/custom/themes"
  if [[ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

    echo "✅ Powerlevel10k installed."
  else
    echo "✅ Powerlevel10k already present."
  fi
else
  echo "⚙️  Skipping Powerlevel10k (non-dev machine)."
fi

# ---------------------------------------------------
# Link Scripts and Configs
# ---------------------------------------------------

echo "🔗 Linking scripts and configs..."

mkdir -p "$BIN_DIR"
ln -sf "$DOTFILES_DIR/bin/tmux-sessionizer" "$BIN_DIR/tmux-sessionizer"
chmod +x "$BIN_DIR/tmux-sessionizer"

mkdir -p "$HOME/.config/ghostty"
ln -sf "$DOTFILES_DIR/config/ghostty/config" "$HOME/.config/ghostty/config"

ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/zsh/functions.zsh" "$HOME/.zsh_functions"

# ---------------------------------------------------
# Setup Tmux to Use Zsh as Default Shell
# ---------------------------------------------------

if ! grep -q "default-shell" "$HOME/.tmux.conf"; then
  echo "🖥️  Setting tmux default-shell to nix zsh..."
  echo "set-option -g default-shell $HOME/.nix-profile/bin/zsh" >>"$HOME/.tmux.conf"
  echo "✅ tmux default shell set."
else
  echo "✅ tmux default shell already configured."
fi

# ---------------------------------------------------
# Final Touches
# ---------------------------------------------------

echo "✅ Bootstrap complete!"

echo ""
echo "ℹ️  Next steps:"
echo " - Logout and login again OR run 'exec zsh' to start using your new shell."
echo " - Run 'nix profile install ...' if you haven't installed your tools yet."
echo " - Enjoy your new environment 🚀"
