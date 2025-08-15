#!/bin/bash

# Claude Code Notification Hook Installer
# Simple one-command installation script

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "======================================"
echo "Claude Code Notification Hook Installer"
echo "======================================"
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}Error: This notification system is macOS only (uses 'say' command)${NC}"
    exit 1
fi

# Define installation paths
HOOK_DIR="$HOME/.local/share/claude-hooks"
BIN_DIR="$HOME/.local/bin"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "📦 Installing notification hook system..."
echo ""

# Create directories if they don't exist
echo "Creating directories..."
mkdir -p "$HOOK_DIR"
mkdir -p "$BIN_DIR"

# Copy the notification hook script
echo "Installing notification hook..."
cp "$SCRIPT_DIR/claude-notification-hook.sh" "$HOOK_DIR/"
chmod +x "$HOOK_DIR/claude-notification-hook.sh"

# Copy the setup script
echo "Installing setup script..."
cp "$SCRIPT_DIR/notification-setup.sh" "$BIN_DIR/notification-setup"
chmod +x "$BIN_DIR/notification-setup"

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo ""
    echo -e "${YELLOW}⚠️  Note: $BIN_DIR is not in your PATH${NC}"
    echo "Add this to your shell config (.zshrc or .bashrc):"
    echo ""
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
fi

# Add claude-named helper to shell config
SHELL_CONFIG=""
if [[ -f "$HOME/.zshrc" ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [[ -f "$HOME/.bashrc" ]]; then
    SHELL_CONFIG="$HOME/.bashrc"
fi

if [[ -n "$SHELL_CONFIG" ]]; then
    # Check if claude-named already exists
    if ! grep -q "claude-named()" "$SHELL_CONFIG"; then
        echo "Adding claude-named helper to $SHELL_CONFIG..."
        cat >> "$SHELL_CONFIG" << 'SHELL_HELPER'

# Claude named instance helper function (added by notification hook installer)
# Usage: claude-named "Instance Name" [other claude options]
# Example: claude-named "Email Helper" -p "Help me with this"
claude-named() {
  if [ -z "$1" ]; then
    echo "Usage: claude-named \"Instance Name\" [claude options]"
    echo "Example: claude-named \"Email Helper\" -p \"Check my emails\""
    return 1
  fi
  local instance_name="$1"
  shift  # Remove the first argument (instance name)
  CLAUDE_INSTANCE_NAME="$instance_name" claude "$@"
}
SHELL_HELPER
        echo -e "${GREEN}✅ Added claude-named helper to $SHELL_CONFIG${NC}"
    else
        echo "claude-named helper already exists in $SHELL_CONFIG"
    fi
fi

echo ""
echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""
echo "📍 Installed files:"
echo "  • Hook script: $HOOK_DIR/claude-notification-hook.sh"
echo "  • Setup tool: $BIN_DIR/notification-setup"
if [[ -n "$SHELL_CONFIG" ]]; then
    echo "  • Shell helper: claude-named function in $SHELL_CONFIG"
fi
echo ""
echo "🚀 Quick Start:"
echo ""
echo "  1. Set up notifications for current project:"
echo "     notification-setup"
echo ""
echo "  2. Use claude with custom instance names:"
echo "     claude-named \"My Project\""
echo "     claude-named \"Email Helper\" -p \"Check my emails\""
echo ""
if [[ -n "$SHELL_CONFIG" ]]; then
    echo "  Note: Reload your shell or run: source $SHELL_CONFIG"
fi
echo ""
echo "📖 For more options:"
echo "   notification-setup --help"
echo ""
echo "🗑️  To uninstall, run:"
echo "   rm $HOOK_DIR/claude-notification-hook.sh"
echo "   rm $BIN_DIR/notification-setup"
if [[ -n "$SHELL_CONFIG" ]]; then
    echo "   # Remove claude-named function from $SHELL_CONFIG"
fi
echo ""