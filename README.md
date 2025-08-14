# Fun Hooks for Claude Code

A collection of delightful hooks for Claude Code to enhance your development experience.

## 🔔 Claude Notification Hook

Get audio notifications when Claude finishes tasks or needs your input - perfect for tmux users!

### Features

- **Voice Notifications**: Uses macOS text-to-speech with customizable voices
- **Sound Effects**: Different sound patterns for different events
- **Session Context**: Includes session ID and working directory in notifications
- **Tmux Compatible**: Works inside tmux sessions

### Installation

1. Copy the hook script to your Claude hooks directory:
```bash
cp claude-notification-hook.sh ~/.claude/hooks/notify.sh
chmod +x ~/.claude/hooks/notify.sh
```

2. Add the hooks to your Claude settings (`~/.claude/settings.json`):
```json
{
  "hooks": {
    "Stop": [
      {
        "type": "command",
        "command": "/Users/[YOUR_USERNAME]/.claude/hooks/notify.sh"
      }
    ],
    "Notification": [
      {
        "type": "command",
        "command": "/Users/[YOUR_USERNAME]/.claude/hooks/notify.sh"
      }
    ]
  }
}
```

### Configuration

Edit the script to customize your experience:

```bash
# Recommended voices for notifications:
#   "Good News" - Cheerful, upbeat voice (default)
#   "Bad News"  - Serious, dramatic voice  
#   "Cellos"    - Deep, musical voice
#   "Thomas"    - Clear French-accented English
DEFAULT_VOICE="Good News"  

# Speech rate in words per minute
SPEECH_RATE=170  # Range: 90-720
```

### Events

- **Stop Hook**: Triggered when Claude finishes responding
  - Sound: Double Glass chime
  - Voice: "Claude finished, completed task in [directory], session [id]"

- **Notification Hook**: Triggered when Claude needs input/permission
  - Sound: Triple Ping
  - Voice: "Claude needs input, waiting in [directory], session [id]"

### Testing

Test the hook manually:
```bash
# Test Stop event
echo '{"hook_event_name": "Stop", "session_id": "test123", "cwd": "/Users/wz", "transcript_path": ""}' | ~/.claude/hooks/notify.sh

# Test Notification event  
echo '{"hook_event_name": "Notification", "session_id": "test456", "cwd": "/Users/wz", "message": "Permission needed"}' | ~/.claude/hooks/notify.sh
```

### Troubleshooting

If notifications aren't working:
1. Check that `say` and `afplay` commands work: `say "test" && afplay /System/Library/Sounds/Glass.aiff`
2. For tmux users: Ensure `reattach-to-user-namespace` is installed: `brew install reattach-to-user-namespace`
3. Check the log file: `tail ~/.claude/hooks/notification.log`

### Voice Samples

Try different voices with the included test script:
```bash
./test_voices.sh
```

## Contributing

Feel free to submit PRs with your own fun hooks!

## License

MIT