# Detailed Documentation - Audio Notification Hook

This document contains comprehensive information, troubleshooting, and advanced usage for the Claude Code audio notification hook.

## Complete Command Line Options

| Option | Description | Default |
|--------|-------------|---------|
| `--voice VOICE` | TTS voice to use | "Good News" |
| `--wpm WPM` | Words per minute for speech | 170 |
| `-d, --directory DIR` | Directory to setup hooks in | Current directory |
| `--hook-dir DIR` | Hook templates directory | `~/.local/share/claude-hooks` |
| `-h, --help` | Show help message | - |

## Available Voices

| Voice | Description |
|-------|-------------|
| "Good News" | Cheerful, upbeat voice (default) |
| "Bad News" | Serious, dramatic voice |
| "Cellos" | Deep, musical voice |
| "Thomas" | Clear French-accented English |
| "Albert" | Standard US male voice |
| "Samantha" | Standard US female voice |
| "Daniel" | British male voice |

Test any voice: `say -v "Voice Name" "Hello, this is a test"`

## What Gets Created

When you run `notification-setup`, it creates:

```
your_project/
├── .claude/
│   ├── settings.local.json          # Claude Code hooks configuration
│   └── hooks/
│       └── claude-notification-hook.sh  # Audio notification script
```

The `settings.local.json` configures Claude Code to run the notification script on Stop and Notification events.

## Advanced Usage Examples

### Setup for Different Projects

```bash
# Web development project with energetic voice
notification-setup -d ~/web_project --voice "Good News" --wpm 200

# Data science project with calm voice  
notification-setup -d ~/data_project --voice "Albert" --wpm 150

# Documentation project with clear voice
notification-setup -d ~/docs_project --voice "Daniel" --wpm 180
```

### Team Setup

```bash
# Create a shared hooks directory for your team
mkdir ~/team_hooks
cp claude-notification-hook.sh ~/team_hooks/

# Each team member can use the same templates
notification-setup --hook-dir ~/team_hooks -d ~/team_project
```

### Local Installation (Without Global Setup)

```bash
cd /path/to/your/project
/path/to/fun_hooks/hooks/notification_hook/notification-setup.sh --voice "Samantha" --wpm 200
```

## Customization

### Modify Notification Messages

Edit the hook script to customize messages:

```bash
# Edit the installed hook script
nano .claude/hooks/claude-notification-hook.sh
```

### Change Sound Effects

The script uses different system sounds for different events:
- **Stop events**: Glass.aiff (double ping)
- **Notification events**: Ping.aiff (triple ping)  
- **Other events**: Pop.aiff (single ping)

You can modify these in the hook script by changing the sound file paths.

### Environment Variables

The hook script supports environment variables to override settings:
- `CLAUDE_VOICE`: Override the voice setting
- `CLAUDE_WPM`: Override the words-per-minute setting

```bash
export CLAUDE_VOICE="Samantha"
export CLAUDE_WPM=200
# These will override the script's built-in settings
```

## Manual Testing

### Test Stop Event
```bash
echo '{"hook_event_name": "Stop", "cwd": "'$(pwd)'"}' | .claude/hooks/claude-notification-hook.sh
```

### Test Notification Event
```bash
echo '{"hook_event_name": "Notification", "cwd": "'$(pwd)'", "message": "Task completed"}' | .claude/hooks/claude-notification-hook.sh
```

### Test Different Voices
```bash
# Test a voice directly
say -v "Good News" "In $(basename $(pwd)), Claude finished responding"
say -v "Samantha" "In $(basename $(pwd)), Claude needs input"
```

## Troubleshooting

### "Could not find claude-notification-hook.sh"

Make sure you've installed the hook template:

```bash
mkdir -p ~/.local/share/claude-hooks/
cp claude-notification-hook.sh ~/.local/share/claude-hooks/
```

### No Audio Output

1. **Check system audio**: Ensure your Mac's audio is working and not muted
2. **Test `say` command**: Run `say "Hello"` to verify text-to-speech works
3. **Check script permissions**: `chmod +x .claude/hooks/claude-notification-hook.sh`
4. **Verify sound files**: Test `afplay /System/Library/Sounds/Glass.aiff`

### Hooks Not Triggering

1. **Restart Claude Code** after installing hooks - changes don't take effect immediately
2. **Check settings file exists**: `ls -la .claude/settings.local.json`
3. **Verify hook script path** in settings.local.json points to the right location
4. **Check Claude Code version** - ensure your version supports hooks

### Permission Issues

Make sure all scripts are executable:

```bash
chmod +x ~/.local/bin/notification-setup
chmod +x ~/.local/share/claude-hooks/claude-notification-hook.sh
chmod +x .claude/hooks/claude-notification-hook.sh
```

### Voice Not Working

1. **Check voice exists**: `say -v "?" | grep "Voice Name"`
2. **Test voice directly**: `say -v "Voice Name" "test"`
3. **Try default voice**: Remove `--voice` parameter to use "Good News"

### tmux/Terminal Issues

If running in tmux and audio doesn't work:
1. Install reattach-to-user-namespace: `brew install reattach-to-user-namespace`
2. Add to your `.tmux.conf`: `set -g default-command "reattach-to-user-namespace -l $SHELL"`

## Technical Details

### How It Works

1. **Hook Installation**: `notification-setup` creates `.claude/settings.local.json` with hooks configuration
2. **Event Triggers**: Claude Code calls the hook script on Stop and Notification events  
3. **JSON Input**: The hook script receives event data as JSON via stdin
4. **Audio Generation**: Uses macOS `say` command for speech and `afplay` for sounds
5. **Context Awareness**: Extracts directory name from `cwd` field for announcements

### File Structure After Installation

```
~/.local/bin/notification-setup                          # Main installation script
~/.local/share/claude-hooks/claude-notification-hook.sh  # Hook template
project/.claude/settings.local.json                     # Claude Code configuration  
project/.claude/hooks/claude-notification-hook.sh       # Project-specific hook script
```

### JSON Event Format

The hook script receives JSON data like this:

**Stop Event:**
```json
{
  "hook_event_name": "Stop",
  "session_id": "abc123",
  "transcript_path": "/path/to/conversation.jsonl",
  "cwd": "/Users/username/project",
  "stop_hook_active": false
}
```

**Notification Event:**
```json
{
  "hook_event_name": "Notification", 
  "session_id": "abc123",
  "transcript_path": "/path/to/conversation.jsonl",
  "cwd": "/Users/username/project",
  "message": "Claude needs permission to run this command"
}
```

### System Requirements

- **macOS** 10.7+ (for `say` command)
- **Claude Code** with hooks support
- **Bash** shell
- **Audio output** capability
- **jq** for JSON parsing (usually pre-installed on macOS)

## Files in This Directory

- **`claude-notification-hook.sh`** - Main hook script that handles audio notifications
- **`notification-setup.sh`** - Installation script that sets up hooks in projects  
- **`README.md`** - Quick start guide and basic usage
- **`Details.md`** - This comprehensive documentation file

## Installation Quick Reference

### Global Setup (Recommended)
```bash
mkdir -p ~/.local/share/claude-hooks/
cp claude-notification-hook.sh ~/.local/share/claude-hooks/
cp notification-setup.sh ~/.local/bin/notification-setup
chmod +x ~/.local/bin/notification-setup
```

### Use Anywhere
```bash
cd ~/any_project
notification-setup --voice "Your Favorite Voice" --wpm 200
```

### Verify Installation
```bash
which notification-setup                    # Should show: /Users/username/.local/bin/notification-setup
ls ~/.local/share/claude-hooks/             # Should show: claude-notification-hook.sh
notification-setup --help                  # Should show help message
```

---

*This documentation covers everything you need to know about the audio notification hook. If you encounter issues not covered here, feel free to modify the scripts or reach out for help!*