# Claude Code Audio Notification Hook 🔔

I always wanted a nice notification system for Claude Code. Initially I wanted to have a banner notification, but unfortunately I never got it to work, but voice seemed to work! I picked the most delightful and fun of the voices (my favorite is "Good News"--try for yourself!). And have fun :)

## Compatibility
- **macOS only** (uses `say` command and system sounds)
- **Claude Code** with hooks support

## Features
🔊 Audio notifications when Claude finishes or needs input  
🎤 7+ customizable voices (try "Good News"!)  
⚡ Adjustable speech rate  
🛠️ One-command global setup

## Setup

### Global Installation (Recommended)
```bash
# Install globally
mkdir -p ~/.local/share/claude-hooks/
cp claude-notification-hook.sh ~/.local/share/claude-hooks/
cp notification-setup.sh ~/.local/bin/notification-setup
chmod +x ~/.local/bin/notification-setup
```

### Use Anywhere
```bash
cd ~/your_project
notification-setup --voice "Good News" --wpm 200
claude  # Start Claude Code - you'll now get audio notifications!
```

What you'll hear:
- 🛑 **Claude finishes**: "In project_name, Claude finished responding"
- 📢 **Claude needs input**: "In project_name, Claude needs input"

## Usage

```bash
# Use defaults (Good News voice, 170 WPM)
notification-setup

# Customize voice and speed  
notification-setup --voice "Samantha" --wpm 200

# Setup for different directory
notification-setup -d ~/other_project --voice "Daniel"

# Get help
notification-setup --help
```

## Popular Voices
- **"Good News"** - Cheerful, upbeat (my favorite!)
- **"Samantha"** - Standard US female  
- **"Daniel"** - British male
- **"Albert"** - Standard US male

[Try all 7+ voices →](Details.md#available-voices)

## Quick Test
```bash
# Test it works
echo '{"hook_event_name": "Stop", "cwd": "'$(pwd)'"}' | .claude/hooks/claude-notification-hook.sh
```

---

**Need more details?** → [See Details.md](Details.md) for troubleshooting, customization, technical info, and more voices.

*Have fun with your audio-enhanced Claude Code! 🎉*