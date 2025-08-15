#!/bin/bash

# Memory Hook Setup Script
# Installs memory tracking for Claude Code in your project
# Simple one-command installation

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Default to current directory for installation
INSTALL_DIR="${1:-$(pwd)}"

echo -e "${BLUE}🧠 Claude Memory Hook Setup${NC}"
echo -e "${BLUE}═══════════════════════════════${NC}"
echo

# Check if running from the hook directory
if [ ! -f "$SCRIPT_DIR/memory-hook.sh" ]; then
    echo -e "${YELLOW}Error: memory-hook.sh not found in $SCRIPT_DIR${NC}"
    echo "Please run this script from the memory_hook directory"
    exit 1
fi

# Create .claude/hooks directory
echo -e "${GREEN}→${NC} Creating .claude/hooks directory..."
mkdir -p "$INSTALL_DIR/.claude/hooks"

# Copy the hook script
echo -e "${GREEN}→${NC} Installing memory hook..."
cp "$SCRIPT_DIR/memory-hook.sh" "$INSTALL_DIR/.claude/hooks/"
chmod +x "$INSTALL_DIR/.claude/hooks/memory-hook.sh"

# Check if CLAUDE.md exists
if [ -f "$INSTALL_DIR/CLAUDE.md" ]; then
    echo -e "${YELLOW}→${NC} CLAUDE.md already exists. Skipping..."
    echo "  To use the memory template, see CLAUDE.md.template"
else
    echo -e "${GREEN}→${NC} Installing CLAUDE.md with memory configuration..."
    cp "$SCRIPT_DIR/CLAUDE.md.template" "$INSTALL_DIR/CLAUDE.md"
fi

# Create memory directories
echo -e "${GREEN}→${NC} Creating memory directories..."
mkdir -p "$INSTALL_DIR/memory/daily"
mkdir -p "$INSTALL_DIR/memory/context"
mkdir -p "$INSTALL_DIR/memory/reflections"

# Create or update settings
SETTINGS_FILE="$INSTALL_DIR/.claude/settings.json"
if [ -f "$SETTINGS_FILE" ]; then
    echo -e "${GREEN}→${NC} Updating .claude/settings.json..."
    # Check if hooks section exists
    if jq -e '.hooks' "$SETTINGS_FILE" > /dev/null 2>&1; then
        # Add to existing hooks
        jq '.hooks.UserPromptSubmit = (.hooks.UserPromptSubmit // []) + [".claude/hooks/memory-hook.sh"] | .hooks.UserPromptSubmit |= unique' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp"
    else
        # Create hooks section
        jq '. + {hooks: {UserPromptSubmit: [".claude/hooks/memory-hook.sh"]}}' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp"
    fi
    mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
else
    echo -e "${GREEN}→${NC} Creating .claude/settings.json..."
    cat > "$SETTINGS_FILE" << 'EOL'
{
  "hooks": {
    "UserPromptSubmit": [".claude/hooks/memory-hook.sh"]
  }
}
EOL
fi

# Create initial daily memory file
TODAY=$(date +%Y-%m-%d)
DAILY_FILE="$INSTALL_DIR/memory/daily/$TODAY.md"
if [ ! -f "$DAILY_FILE" ]; then
    echo -e "${GREEN}→${NC} Creating today's memory file..."
    cat > "$DAILY_FILE" << EOL
# Daily Memory - $TODAY

## Session Start
- **Time**: $(date +%H:%M:%S)
- **Memory system initialized**

## Events

<!-- Claude will add entries here -->

EOL
fi

# Success message
echo
echo -e "${GREEN}✅ Memory hook installed successfully!${NC}"
echo
echo "What was installed:"
echo "  • Memory hook at .claude/hooks/memory-hook.sh"
echo "  • Memory directories at memory/"
if [ ! -f "$INSTALL_DIR/CLAUDE.md" ]; then
    echo "  • CLAUDE.md with memory configuration"
fi
echo "  • Hook registered in .claude/settings.json"
echo
echo -e "${BLUE}To test:${NC} Start Claude Code and type something"
echo "You should see the memory context injected into your prompts"
echo
echo -e "${YELLOW}Note:${NC} The hook only activates in projects with memory/ directories"