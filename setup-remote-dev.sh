#!/usr/bin/env bash

# ---------------------------------------------------
# Development Environment Setup Script
# ---------------------------------------------------

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Setting up your development environment..."

# ---------------------------------------------------
# Step 1: Install Ansible
# ---------------------------------------------------

if ! command -v ansible-playbook &> /dev/null; then
    echo "📦 Installing Ansible..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update -y
        sudo apt-get install -y ansible
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y ansible
    elif command -v yum &> /dev/null; then
        sudo yum install -y ansible
    else
        echo "❌ Could not install Ansible. Please install it manually and re-run this script."
        exit 1
    fi
fi

# ---------------------------------------------------
# Step 2: Run the Ansible Playbook
# ---------------------------------------------------

echo "🛠️  Running Ansible playbook to install and configure tools..."
ansible-playbook -i "$SCRIPT_DIR/ansible/inventory" "$SCRIPT_DIR/ansible/setup-dev-tools.yml" --become

# ---------------------------------------------------
# Final Instructions
# ---------------------------------------------------

echo ""
echo "✅ Environment setup complete!"
echo ""
echo "💡 Next Steps:"
echo "   1. Log out and log back in, or run 'exec zsh' to start your new shell."
echo "   2. To update tools, edit the 'vars' section in 'ansible/setup-dev-tools.yml' and re-run this script."
echo ""
echo "Happy coding! 🚀"
