#!/bin/bash

# Claude Code Audio Notification Script
# Uses sound notifications since visual notifications aren't working in tmux

# Configuration - Edit these to customize
# Recommended voices for notifications (macOS built-in):
#   "Good News" - Cheerful, upbeat voice (default)
#   "Bad News"  - Serious, dramatic voice  
#   "Cellos"    - Deep, musical voice
#   "Thomas"    - Clear French-accented English
#   "Albert"    - Standard US male voice
#   "Samantha"  - Standard US female voice
#   "Daniel"    - British male voice
DEFAULT_VOICE="Good News"  

# Speech rate in words per minute (default: ~180, range: 90-720)
# Recommended: 150-200 for clarity, 200-250 for quick notifications
SPEECH_RATE=170

# Read JSON input from stdin
json_input=$(cat)

# Extract relevant fields
hook_event=$(echo "$json_input" | jq -r '.hook_event_name // "Unknown"')
session_id=$(echo "$json_input" | jq -r '.session_id // "unknown"')
cwd=$(echo "$json_input" | jq -r '.cwd // "."')
transcript_path=$(echo "$json_input" | jq -r '.transcript_path // ""')
message=$(echo "$json_input" | jq -r '.message // ""')

# Get short session ID (first 6 chars)
short_session="${session_id:0:6}"

# Get directory name from path
dir_name=$(basename "$cwd")

# Determine notification content and sound based on hook type
if [ "$hook_event" = "Stop" ]; then
    title="Claude finished"
    notification_message="completed task in $dir_name"
    sound_file="/System/Library/Sounds/Glass.aiff"
    # Play a distinctive pattern for completion
    afplay "$sound_file" &
    sleep 0.3
    afplay "$sound_file" &
elif [ "$hook_event" = "Notification" ]; then
    title="Claude needs input"
    if [ -n "$message" ]; then
        notification_message="$message"
    else
        notification_message="waiting in $dir_name"
    fi
    sound_file="/System/Library/Sounds/Ping.aiff"
    # Play three quick pings for attention
    for i in {1..3}; do
        afplay "$sound_file" &
        sleep 0.2
    done
else
    title="Claude event"
    notification_message="$hook_event in $dir_name"
    sound_file="/System/Library/Sounds/Pop.aiff"
    afplay "$sound_file" &
fi

# Create spoken notification with context
spoken_message="$title, $notification_message in $dir_name"

# Try to extract context from transcript if available
if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
    # Get last user message (if possible)
    last_user_msg=$(tail -10 "$transcript_path" 2>/dev/null | grep '"role":"user"' | tail -1 | jq -r '.content // ""' 2>/dev/null | cut -c1-50)
    if [ -n "$last_user_msg" ]; then
        spoken_message="$title, $notification_message. Context: $last_user_msg"
    fi
fi

# Use text-to-speech for the notification with configured voice and rate
# Don't run in background to ensure it completes
say -v "$DEFAULT_VOICE" -r "$SPEECH_RATE" "$spoken_message"

# Log for debugging
echo "$(date): $hook_event - $title: $notification_message [Session: $short_session]" >> /Users/wz/.claude/hooks/notification.log
echo "Spoken: $spoken_message" >> /Users/wz/.claude/hooks/notification.log

exit 0