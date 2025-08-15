#!/bin/bash

# Claude Code Audio Notification Script
# Uses sound notifications since visual notifications aren't working in tmux

# Configuration - Edit these to customize or use environment variables
# Recommended voices for notifications (macOS built-in):
#   "Good News" - Cheerful, upbeat voice (default)
#   "Bad News"  - Serious, dramatic voice  
#   "Cellos"    - Deep, musical voice
#   "Thomas"    - Clear French-accented English
#   "Albert"    - Standard US male voice
#   "Samantha"  - Standard US female voice
#   "Daniel"    - British male voice
DEFAULT_VOICE="${CLAUDE_VOICE:-Good News}"  

# Speech rate in words per minute (default: ~180, range: 90-720)
# Recommended: 150-200 for clarity, 200-250 for quick notifications
SPEECH_RATE="${CLAUDE_WPM:-170}"

# Read JSON input from stdin
json_input=$(cat)

# Extract relevant fields
hook_event=$(echo "$json_input" | jq -r '.hook_event_name // "Unknown"')
session_id=$(echo "$json_input" | jq -r '.session_id // "unknown"')
cwd=$(echo "$json_input" | jq -r '.cwd // ""')
transcript_path=$(echo "$json_input" | jq -r '.transcript_path // ""')
message=$(echo "$json_input" | jq -r '.message // ""')
stop_hook_active=$(echo "$json_input" | jq -r '.stop_hook_active // false')

# If cwd is empty, get current working directory
if [ -z "$cwd" ] || [ "$cwd" = "null" ]; then
    cwd=$(pwd)
fi

# Get instance name - read from .claude/instance_name.txt if it exists
# Check both the current working directory and parent directories
if [ -f "$cwd/.claude/instance_name.txt" ]; then
    dir_name=$(cat "$cwd/.claude/instance_name.txt")
elif [ -f ".claude/instance_name.txt" ]; then
    dir_name=$(cat ".claude/instance_name.txt")
elif [ -n "$CLAUDE_INSTANCE_NAME" ]; then
    # Fall back to environment variable if set
    dir_name="$CLAUDE_INSTANCE_NAME"
else
    # Get directory name from path as final fallback
    dir_name=$(basename "$cwd")
fi

# Determine notification content and sound based on hook type
if [ "$hook_event" = "Stop" ]; then
    spoken_message="From $dir_name, finished"
    sound_file="/System/Library/Sounds/Glass.aiff"
    # Play a distinctive pattern for completion
    afplay "$sound_file" &
    sleep 0.3
    afplay "$sound_file" &
elif [ "$hook_event" = "Notification" ]; then
    spoken_message="From $dir_name, needs input"
    sound_file="/System/Library/Sounds/Ping.aiff"
    # Play three quick pings for attention
    for i in {1..3}; do
        afplay "$sound_file" &
        sleep 0.2
    done
else
    spoken_message="From $dir_name, $hook_event"
    sound_file="/System/Library/Sounds/Pop.aiff"
    afplay "$sound_file" &
fi

# Use text-to-speech for the notification with configured voice and rate
# Don't run in background to ensure it completes
say -v "$DEFAULT_VOICE" -r "$SPEECH_RATE" "$spoken_message"

# Log for debugging
echo "$(date): $hook_event - $spoken_message" >> /Users/wz/.claude/hooks/notification.log

exit 0