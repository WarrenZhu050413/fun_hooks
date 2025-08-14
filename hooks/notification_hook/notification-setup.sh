#!/bin/bash

# Claude Code Hooks Setup Script
# Automatically configures Claude Code with audio notification hooks

set -e  # Exit on any error

# Default values
DEFAULT_VOICE="Good News"
DEFAULT_WPM=170
DEFAULT_DIR="$(pwd)"
DEFAULT_HOOK_DIR="$HOME/.local/share/claude-hooks"

# Initialize variables
VOICE="$DEFAULT_VOICE"
WPM="$DEFAULT_WPM"
TARGET_DIR="$DEFAULT_DIR"
HOOK_DIR="$DEFAULT_HOOK_DIR"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --voice)
            VOICE="$2"
            shift 2
            ;;
        --wpm)
            WPM="$2"
            shift 2
            ;;
        -d|--directory)
            TARGET_DIR="$2"
            shift 2
            ;;
        --hook-dir)
            HOOK_DIR="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [--voice VOICE] [--wpm WPM] [-d DIRECTORY] [--hook-dir HOOK_DIR]"
            echo ""
            echo "Options:"
            echo "  --voice VOICE        TTS voice to use (default: '$DEFAULT_VOICE')"
            echo "  --wpm WPM            Words per minute for TTS (default: $DEFAULT_WPM)"
            echo "  -d, --directory DIR  Directory to setup hooks in (default: current directory)"
            echo "  --hook-dir DIR       Directory containing hook templates (default: ~/.local/share/claude-hooks)"
            echo ""
            echo "Available voices (macOS):"
            echo "  'Good News'  - Cheerful, upbeat voice"
            echo "  'Bad News'   - Serious, dramatic voice"
            echo "  'Cellos'     - Deep, musical voice"
            echo "  'Thomas'     - Clear French-accented English"
            echo "  'Albert'     - Standard US male voice"
            echo "  'Samantha'   - Standard US female voice"
            echo "  'Daniel'     - British male voice"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Create target directory if it doesn't exist
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Creating target directory: $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
fi

# Convert to absolute path for display
ABS_TARGET_DIR=$(cd "$TARGET_DIR" && pwd)

echo "Setting up Claude Code hooks with:"
echo "  Voice: $VOICE"
echo "  WPM: $WPM"
echo "  Target Directory: $ABS_TARGET_DIR"
echo "  Hook Templates: $HOOK_DIR"
echo ""

# Create .claude directory structure in target directory
echo "Creating .claude directory structure..."
mkdir -p "$TARGET_DIR/.claude/hooks"

# Create settings.local.json with clean hooks configuration
echo "Creating .claude/settings.local.json..."
cat > "$TARGET_DIR/.claude/settings.local.json" << EOF
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/claude-notification-hook.sh"
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/claude-notification-hook.sh"
          }
        ]
      }
    ]
  }
}
EOF

# Expand tilde in hook directory path
HOOK_DIR="${HOOK_DIR/#\~/$HOME}"

# Find the source notification script in hook directory
SOURCE_SCRIPT="$HOOK_DIR/claude-notification-hook.sh"

if [[ ! -f "$SOURCE_SCRIPT" ]]; then
    echo "Error: Could not find claude-notification-hook.sh in $HOOK_DIR"
    echo "Please ensure the hook template exists in the hook directory."
    echo "You may need to copy it there first:"
    echo "  mkdir -p $HOOK_DIR"
    echo "  cp claude-notification-hook.sh $HOOK_DIR/"
    exit 1
fi

# Copy and customize the notification script
echo "Copying and customizing notification script..."
cp "$SOURCE_SCRIPT" "$TARGET_DIR/.claude/hooks/claude-notification-hook.sh"

# Update the script with custom voice and WPM settings
sed -i '' "s/DEFAULT_VOICE=\".*\"/DEFAULT_VOICE=\"$VOICE\"/" "$TARGET_DIR/.claude/hooks/claude-notification-hook.sh"
sed -i '' "s/SPEECH_RATE=.*/SPEECH_RATE=$WPM/" "$TARGET_DIR/.claude/hooks/claude-notification-hook.sh"

# Make sure the script is executable
chmod +x "$TARGET_DIR/.claude/hooks/claude-notification-hook.sh"

echo ""
echo "✅ Claude Code hooks setup complete!"
echo ""
echo "Configuration:"
echo "  📁 Settings: $TARGET_DIR/.claude/settings.local.json" 
echo "  🔊 Hook script: $TARGET_DIR/.claude/hooks/claude-notification-hook.sh"
echo "  🎤 Voice: $VOICE"
echo "  ⚡ Speed: $WPM WPM"
echo "  📂 Directory: $ABS_TARGET_DIR"
echo ""
echo "The hooks will now trigger audio notifications when:"
echo "  • Claude finishes responding (Stop event)"
echo "  • Claude needs input (Notification event)"
echo ""
echo "Note: Changes to hooks take effect in new Claude sessions."